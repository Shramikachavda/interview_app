from typing import List, Dict
from langchain_core.messages import SystemMessage, HumanMessage
from models.interview_feedback import InterviewFeedback
from models.interview import InterviewModel
from typing import List, Dict
from langchain_core.messages import SystemMessage, HumanMessage
from langchain_core.output_parsers import PydanticOutputParser
from models.pdf_feedback import InterviewPDFFeedback


# Prepare the parser for structured output into InterviewFeedback pydantic model
parser = PydanticOutputParser(pydantic_object=InterviewPDFFeedback)

# System message that instructs the LLM what to do
system_msg = SystemMessage(content=(
    "You are an interview evaluator. "
    "Given the following Q&A, provide structured feedback in JSON format."
))

# Async function to generate detailed feedback using LLM
async def generate_unified_pdf_feedback(experience: str, qa_list: List[Dict[str, str]], llm) -> InterviewPDFFeedback:
    """
    Generates structured feedback from an LLM given experience level and Q&A pairs.
    """
    formatted_qa = "\n\n".join(
        [f"Q{i+1}: {item['question']}\nA{i+1}: {item['answer']}" for i, item in enumerate(qa_list)]
    )
    print(f"🔍 Formatted Q&A preview:\n{formatted_qa[:500]}{'...' if len(formatted_qa) > 500 else ''}")

    human_msg_content = (
        f"Experience Level: {experience}\n\n"
        f"Here are the questions and answers from the interview session:\n\n{formatted_qa}\n\n"
        "Please provide structured feedback in JSON format matching the InterviewPDFFeedback model:\n"
        "- overall_score (0–10)\n"
        "- summary: Summary of the candidate's performance\n"
        "- strengths: 3–5 bullet points\n"
        "- improvements: 3–5 bullet points\n"
        "- detailed_feedback: a list of objects, each containing:\n"
        "    - question\n"
        "    - answer\n"
        "    - evaluation\n"
        "    - score\n\n"
        "Important:\n"
        "- Each question score should vary based on the quality of the answer.\n"
        "- The average of all question scores should be close to the overall_score.\n"
        "- Return strictly valid JSON only."
    )

    human_msg = HumanMessage(content=human_msg_content)
    print(f"🔍 Human message length: {len(human_msg_content)} characters")

    chain = llm.with_structured_output(InterviewPDFFeedback)
    print(f"🔍 LLM chain prepared with structured output: {InterviewPDFFeedback}")

    try:
        if hasattr(chain, "ainvoke"):
            print("🔄 Invoking LLM asynchronously...")
            feedback = await chain.ainvoke([system_msg, human_msg])
        else:
            print("⚠️ LLM async method 'ainvoke' not found, falling back to sync invoke (not recommended)")
            feedback = chain.invoke([system_msg, human_msg])
        print("✅ LLM invocation completed")
    except Exception as e:
        print(f"❌ Exception during LLM invocation: {e}")
        import traceback
        traceback.print_exc()
        raise e

    print("📝 === GENERATE_UNIFIED_FEEDBACK END ===\n")
    print(feedback)
    print("")
    print("")

    print("")

    return feedback


async def generate_unified_feedback(experience: str, qa_list: List[Dict[str, str]], llm) -> InterviewFeedback:
    print("\n📝 === GENERATE_UNIFIED_FEEDBACK START ===")
    if not llm:
        raise RuntimeError("LLM is not initialized")
    print(f"🔍 Experience level: {experience}")
    print(f"🔍 Number of Q&A pairs received: {len(qa_list)}")

    formatted_qa = "\n\n".join(
        [f"Q{i+1}: {item['question']}\nA{i+1}: {item['answer']}" for i, item in enumerate(qa_list)]
    )
    print(f"🔍 Formatted Q&A preview:\n{formatted_qa[:500]}{'...' if len(formatted_qa) > 500 else ''}")

    system_msg = SystemMessage(content="You are an expert interviewer giving structured feedback.")
    human_msg_content = (
        f"Experience Level: {experience}\n\n"
        f"Here are the questions and answers from the interview session:\n\n{formatted_qa}\n\n"
        "Please provide feedback in the following format:\n"
        "- Score (0–10)\n"
        "- Summary of candidate's performance\n"
        "- 3 to 5 areas for improvement (bullet points)"
    )
    human_msg = HumanMessage(content=human_msg_content)
    print(f"🔍 Human message length: {len(human_msg_content)} characters")

    chain = llm.with_structured_output(InterviewFeedback)
    print(f"🔍 LLM chain prepared with structured output: {InterviewFeedback}")

    try:
        if hasattr(chain, "ainvoke"):
            print("🔄 Invoking LLM asynchronously...")
            feedback = await chain.ainvoke([system_msg, human_msg])
        else:
            print("🔄 Invoking LLM synchronously...")
            feedback = chain.invoke([system_msg, human_msg])
        print("✅ LLM invocation completed")
    except Exception as e:
        print(f"❌ Exception during LLM invocation: {e}")
        import traceback
        traceback.print_exc()
        raise e

    print("📝 === GENERATE_UNIFIED_FEEDBACK END ===\n")
    print("data from  feedback:")
    print(feedback)

    return feedback


async def generate_feedback_node(state: InterviewModel, config: dict = None) -> InterviewModel:
    print("\n📝 === GENERATE_FEEDBACK NODE START ===")
    if config is None:
        config = {}

    llm = config.get("configurable", {}).get("llm")
    print(f"🔍 LLM instance found: {'Yes' if llm else 'No'}")
    if not llm:
        raise RuntimeError("LLM instance missing in config")

    print(f"🔍 Generating feedback for experience level: {state.level}")
    print(f"🔍 Number of Q&A pairs: {len(state.q_a_pair)}")

    try:
        feedback = await generate_unified_feedback(state.level, state.q_a_pair, llm)
        print(f"✅ Feedback generated successfully:")
        print(feedback)  # you can customize how much to print based on your feedback model

        # Attach feedback to state
        if hasattr(feedback, "model_dump"):
            state.feedback = feedback.model_dump()
            print(f"🔍 Feedback model dumped to dict")
        elif hasattr(feedback, "dict"):
            state.feedback = feedback.dict()
            print(f"🔍 Feedback converted to dict")
        else:
            state.feedback = feedback
            print(f"🔍 Feedback attached as-is")

        state.session_status = "done"
        state.current_question = None

    except Exception as e:
        print(f"❌ Error generating feedback: {e}")
        import traceback
        traceback.print_exc()
        state.feedback = "Error generating feedback."
        state.session_status = "done"
        state.current_question = None

    print("📝 === GENERATE_FEEDBACK NODE END ===\n")
    return state
