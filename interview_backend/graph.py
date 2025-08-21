import asyncio
from langchain_core.runnables import RunnableLambda
from sqlalchemy.orm import Session
from typing import Optional, List, Dict
from pydantic import BaseModel
from langgraph.graph import StateGraph, END
from models.models import QuestionBank, QuestionType, SessionType, DifficultyLevel
from services import ai_factory
from core.config import settings
import random
from sqlalchemy.sql import func
from typing_extensions import Literal
from sqlalchemy import cast, String

# Import modular nodes
from nodes.session_nodes import initialize_session, check_if_done
from nodes.question_nodes import ask_question, store_answer
from nodes.feedback_nodes import  generate_feedback_node

# Import the new InterviewModel
from models.interview import InterviewModel


class InterviewEngine:
    def __init__(self):
        print("🔧 Initializing InterviewEngine...")
        self.initial_graph = self._build_initial_graph()
        self.main_graph = self._build_main_graph()
        print("✅ InterviewEngine initialized successfully")

    def _build_initial_graph(self) -> StateGraph:
        workflow = StateGraph(InterviewModel)
        workflow.add_node("initialize_session", RunnableLambda(initialize_session))
        workflow.add_node("ask_question", RunnableLambda(ask_question))
        workflow.set_entry_point("initialize_session")
        workflow.add_edge("initialize_session", "ask_question")
        workflow.add_edge("ask_question", END)
        return workflow.compile()

    def _build_main_graph(self) -> StateGraph:
        workflow = StateGraph(InterviewModel)
        workflow.add_node("store_answer", RunnableLambda(store_answer))
        workflow.add_node("check_if_done", RunnableLambda(check_if_done))
        workflow.add_node("ask_question", RunnableLambda(ask_question))
        workflow.add_node("generate_feedback", RunnableLambda(generate_feedback_node))

        workflow.set_entry_point("store_answer")
        workflow.add_edge("store_answer", "check_if_done")
        workflow.add_conditional_edges(
            "check_if_done",
            lambda state: state.session_status,
            {
                "not_done": "ask_question",
                "done": "generate_feedback"
            }
        )
        workflow.add_edge("ask_question", "store_answer")
        workflow.add_edge("generate_feedback", END)
        return workflow.compile()

    async def run_step(self, state: InterviewModel, db: Session, first_call: bool = False) -> InterviewModel:
        print("🚀 === INTERVIEW ENGINE RUN_STEP START ===")
        print(f"🔍 latest_answer: {state.latest_answer}")
        print(f"🔍 current_question: {state.current_question}")
        print(f"🔍 q_a_pair: {state.q_a_pair}")

        graph = self.initial_graph if first_call else self.main_graph

        config = {"configurable": {"db": db, "llm": ai_factory.hr_ai.llm}}

        last_state = None
        async for step in graph.astream(state, config=config):
            node = list(step.keys())[0]
            node_state = list(step.values())[0]

            if isinstance(node_state, dict):
                node_state = InterviewModel(**node_state)

            last_state = node_state
            print(f"🔁 Node executed: {node}")

            if node in ("ask_question", "generate_feedback"):
                print(f"✅ Stopping at node: {node}")
                return node_state

        print("⚠️ No stop node found, returning last state")
        return last_state

