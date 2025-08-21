#!/usr/bin/env python3
"""
Simple test script to verify the unified interview API works correctly.
"""

import json
import requests

# Base URL for the API
BASE_URL = "http://localhost:8000/api/interview"

def test_start_interview():
    """Test starting a new interview"""
    print("Testing start interview...")
    
    # Request payload for starting an interview
    payload = {
        "state": {
            "user_id": 1,
            "session_type": "hr",
            "level": "medium",
            "current_question_index": 0,
            "total_questions": 0,
            "q_a_pair": [],
            "asked_question_ids": [],
            "asked_llm_questions": [],
            "session_status": "not_done",
            "current_question": None,
            "feedback": None,
            "latest_answer": None
        }
    }
    
    try:
        response = requests.post(f"{BASE_URL}/interview", json=payload)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Interview started successfully!")
            print(f"Message: {data['message']}")
            print(f"Done: {data['done']}")
            print(f"State keys: {list(data['state'].keys())}")
            return data['state']
        else:
            print(f"Failed to start interview: {response.text}")
            return None
            
    except Exception as e:
        print(f"Error: {e}")
        return None

def test_continue_interview(state):
    """Test continuing an interview"""
    if not state:
        print("No state provided for continuing interview")
        return None
        
    print("🧪 Testing continue interview...")
    
    # Update the state with the latest answer
    state['latest_answer'] = "I handled a difficult team situation by first understanding the root cause, then facilitating open communication between team members to resolve conflicts."
    
    # Request payload for continuing an interview
    payload = {
        "state": state
    }
    
    try:
        response = requests.post(f"{BASE_URL}/interview", json=payload)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print("Interview continued successfully!")
            print(f"Message: {data['message']}")
            print(f"Done: {data['done']}")
            print(f"Q&A pairs: {len(data['state']['q_a_pair'])}")
            return data['state']
        else:
            print(f"Failed to continue interview: {response.text}")
            return None
            
    except Exception as e:
        print(f"Error: {e}")
        return None

if __name__ == "__main__":
    print("🚀 Testing Unified Interview API")
    print("=" * 50)
    
    # Test starting an interview
    state = test_start_interview()
    
    if state:
        print("\n" + "=" * 50)
        # Test continuing the interview
        test_continue_interview(state)
    
    print("\n✅ Test completed!") 