# Unified Interview API Documentation

## Overview
The `/api/interview` endpoint is a single, unified API that handles the entire interview flow using a stateless architecture. All session data is stored in the `InterviewModel` that gets passed between requests.

## Endpoint
```
POST /api/interview
```

## Request Format

### Starting a New Interview
When starting a new interview, provide an initial state with `user_id`, `session_type`, and `level`:

```json
{
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
        "current_question": null,
        "feedback": null,
        "latest_answer": null
    }
}
```

### Continuing an Interview
When continuing an existing interview, update the `latest_answer` in the state and send the entire state:

```json
{
    "state": {
        "user_id": 1,
        "session_type": "hr",
        "level": "medium",
        "current_question_index": 1,
        "total_questions": 8,
        "q_a_pair": [
            {
                "question": "Tell me about a time you overcame a workplace challenge.",
                "answer": "I handled a difficult team situation..."
            }
        ],
        "asked_question_ids": [123],
        "asked_llm_questions": [],
        "session_status": "not_done",
        "current_question": "Describe a situation where you had to work with a difficult colleague.",
        "feedback": null,
        "latest_answer": "I handled a difficult team situation by first understanding the root cause..."
    }
}
```

## Response Format

### Ongoing Interview
```json
{
    "message": "Describe a situation where you had to work with a difficult colleague.",
    "done": false,
    "state": {
        "user_id": 1,
        "session_type": "hr",
        "level": "medium",
        "current_question_index": 2,
        "total_questions": 8,
        "q_a_pair": [
            {
                "question": "Tell me about a time you overcame a workplace challenge.",
                "answer": "I handled a difficult team situation..."
            }
        ],
        "asked_question_ids": [123],
        "asked_llm_questions": [],
        "session_status": "not_done",
        "current_question": "Describe a situation where you had to work with a difficult colleague.",
        "feedback": null,
        "latest_answer": null
    }
}
```

### Completed Interview
```json
{
    "message": "Interview completed successfully. Good technical knowledge demonstrated.",
    "done": true,
    "state": {
        "user_id": 1,
        "session_type": "hr",
        "level": "medium",
        "current_question_index": 8,
        "total_questions": 8,
        "q_a_pair": [
            {
                "question": "Tell me about a time you overcame a workplace challenge.",
                "answer": "I handled a difficult team situation..."
            }
        ],
        "asked_question_ids": [123],
        "asked_llm_questions": [],
        "session_status": "done",
        "current_question": null,
        "feedback": {
            "score": 8,
            "summary": "Good technical knowledge demonstrated.",
            "areas_for_improvement": ["Provide more detailed explanations"]
        },
        "latest_answer": null
    }
}
```

## Key Features

1. **Stateless Architecture**: No server-side session storage - everything in `InterviewModel`
2. **Unified Endpoint**: Single endpoint handles both starting and continuing interviews
3. **LangGraph Integration**: Clean modular nodes for interview flow
4. **Proper Error Handling**: Validation and meaningful error messages
5. **Flexible Question Sources**: Questions from database or LLM generation
6. **Simplified Request Structure**: Only the state object is sent

## Error Responses

### Invalid User
```json
{
    "detail": "User not found"
}
```

### Missing Required Fields
```json
{
    "detail": "For starting an interview, please provide user_id, session_type, and level in the state"
}
```

## Usage Examples

### Flutter/Dart Example
```dart
// Starting an interview
final response = await http.post(
  Uri.parse('http://localhost:8000/api/interview'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'state': {
      'user_id': 1,
      'session_type': 'hr',
      'level': 'medium',
      'current_question_index': 0,
      'total_questions': 0,
      'q_a_pair': [],
      'asked_question_ids': [],
      'asked_llm_questions': [],
      'session_status': 'not_done',
      'current_question': null,
      'feedback': null,
      'latest_answer': null
    }
  }),
);

// Continuing an interview
var currentState = jsonDecode(response.body)['state'];
currentState['latest_answer'] = 'User answer here';

final continueResponse = await http.post(
  Uri.parse('http://localhost:8000/api/interview'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'state': currentState,
  }),
);
```

## Notes

- The API automatically detects if it's a new interview (empty `q_a_pair`) or continuing interview
- All session data is preserved in the `state` object
- The `done` field indicates if the interview is complete
- The `message` field contains the next question or final feedback summary
- The `latest_answer` should be set in the state before sending the request
- No separate `latest_answer` field in the request - everything is in the state 