/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/interview_models.dart';

class QuestionRepository {
  static const String _baseUrl = 'http://localhost:8000/api';

  // API Methods
  Future<List<InterviewQuestion>> getQuestions({
    String? type,
    String? difficulty,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (type != null) queryParams['type'] = type;
      if (difficulty != null) queryParams['difficulty'] = difficulty;
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();

      final uri = Uri.parse('$_baseUrl/questions').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => InterviewQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get questions: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock questions for demo
      return _getMockQuestions(type ?? 'hr', difficulty ?? 'medium');
    }
  }

  Future<InterviewQuestion> getQuestionById(String questionId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/questions/$questionId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return InterviewQuestion.fromJson(data);
      } else {
        throw Exception('Failed to get question: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock question for demo
      return _getMockQuestionById(questionId);
    }
  }

  Future<List<InterviewQuestion>> getRandomQuestions({
    required String type,
    required String difficulty,
    required int count,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/questions/random'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'type': type,
          'difficulty': difficulty,
          'count': count,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => InterviewQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get random questions: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock random questions for demo
      return _getMockRandomQuestions(type, difficulty, count);
    }
  }

  Future<Map<String, dynamic>> getQuestionStats() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/questions/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get question stats: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock stats for demo
      return _getMockQuestionStats();
    }
  }

  Future<List<Map<String, dynamic>>> getQuestionCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/questions/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get categories: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock categories for demo
      return _getMockCategories();
    }
  }

  Future<void> submitQuestionFeedback(String questionId, Map<String, dynamic> feedback) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/questions/$questionId/feedback'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedback),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit feedback: ${response.statusCode}');
      }
    } catch (e) {
      // Simulate success for demo
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // Mock Data Methods
  List<InterviewQuestion> _getMockQuestions(String type, String difficulty) {
    switch (type) {
      case 'hr':
        return [
          InterviewQuestion(
            id: '1',
            question: 'Tell me about yourself and your experience.',
            category: 'Introduction',
            type: 'hr',
            difficulty: difficulty,
          ),
          InterviewQuestion(
            id: '2',
            question: 'What are your strengths and weaknesses?',
            category: 'Self Assessment',
            type: 'hr',
            difficulty: difficulty,
          ),
          InterviewQuestion(
            id: '3',
            question: 'Why do you want to work for this company?',
            category: 'Motivation',
            type: 'hr',
            difficulty: difficulty,
          ),
          InterviewQuestion(
            id: '4',
            question: 'Describe a challenging situation you faced at work.',
            category: 'Behavioral',
            type: 'hr',
            difficulty: difficulty,
          ),
          InterviewQuestion(
            id: '5',
            question: 'Where do you see yourself in 5 years?',
            category: 'Career Goals',
            type: 'hr',
            difficulty: difficulty,
          ),
        ];
      case 'coding':
        return [
          InterviewQuestion(
            id: '6',
            question: 'Write a function to reverse a string.',
            category: 'Algorithms',
            type: 'coding',
            difficulty: difficulty,
            questionData: {
              'initial_code': 'def reverse_string(s):\n    pass',
              'test_cases': [
                {'input': '"hello"', 'output': '"olleh"'},
                {'input': '"world"', 'output': '"dlrow"'},
              ],
              'languages': ['python', 'javascript', 'java'],
            },
          ),
          InterviewQuestion(
            id: '7',
            question: 'Implement a binary search algorithm.',
            category: 'Data Structures',
            type: 'coding',
            difficulty: difficulty,
            questionData: {
              'initial_code': 'def binary_search(arr, target):\n    pass',
              'test_cases': [
                {'input': '[1,2,3,4,5], 3', 'output': '2'},
                {'input': '[1,2,3,4,5], 6', 'output': '-1'},
              ],
              'languages': ['python', 'javascript', 'java'],
            },
          ),
          InterviewQuestion(
            id: '8',
            question: 'Find the longest palindrome substring.',
            category: 'Algorithms',
            type: 'coding',
            difficulty: difficulty,
            questionData: {
              'initial_code': 'def longest_palindrome(s):\n    pass',
              'test_cases': [
                {'input': '"babad"', 'output': '"bab"'},
                {'input': '"cbbd"', 'output': '"bb"'},
              ],
              'languages': ['python', 'javascript', 'java'],
            },
          ),
        ];
      case 'sql':
        return [
          InterviewQuestion(
            id: '9',
            question: 'Write a query to find all users older than 25.',
            category: 'Basic Queries',
            type: 'sql',
            difficulty: difficulty,
            questionData: {
              'table_schema': {
                'users': [
                  {'name': 'id', 'type': 'INT', 'description': 'Primary key'},
                  {'name': 'name', 'type': 'VARCHAR(100)', 'description': 'User name'},
                  {'name': 'age', 'type': 'INT', 'description': 'User age'},
                  {'name': 'email', 'type': 'VARCHAR(255)', 'description': 'User email'},
                ],
              },
              'sample_data': [
                {'id': 1, 'name': 'John', 'age': 30, 'email': 'john@example.com'},
                {'id': 2, 'name': 'Jane', 'age': 25, 'email': 'jane@example.com'},
                {'id': 3, 'name': 'Bob', 'age': 35, 'email': 'bob@example.com'},
              ],
            },
          ),
          InterviewQuestion(
            id: '10',
            question: 'Write a query to get the average salary by department.',
            category: 'Aggregations',
            type: 'sql',
            difficulty: difficulty,
            questionData: {
              'table_schema': {
                'employees': [
                  {'name': 'id', 'type': 'INT', 'description': 'Primary key'},
                  {'name': 'name', 'type': 'VARCHAR(100)', 'description': 'Employee name'},
                  {'name': 'department', 'type': 'VARCHAR(50)', 'description': 'Department'},
                  {'name': 'salary', 'type': 'DECIMAL(10,2)', 'description': 'Salary'},
                ],
              },
              'sample_data': [
                {'id': 1, 'name': 'John', 'department': 'Engineering', 'salary': 80000},
                {'id': 2, 'name': 'Jane', 'department': 'Engineering', 'salary': 85000},
                {'id': 3, 'name': 'Bob', 'department': 'Sales', 'salary': 70000},
              ],
            },
          ),
        ];
      default:
        return [];
    }
  }

  InterviewQuestion _getMockQuestionById(String questionId) {
    return InterviewQuestion(
      id: questionId,
      question: 'Sample question for ID $questionId',
      category: 'General',
      type: 'hr',
      difficulty: 'medium',
    );
  }

  List<InterviewQuestion> _getMockRandomQuestions(String type, String difficulty, int count) {
    final allQuestions = _getMockQuestions(type, difficulty);
    return allQuestions.take(count).toList();
  }

  Map<String, dynamic> _getMockQuestionStats() {
    return {
      'total_questions': 150,
      'by_type': {
        'hr': 60,
        'coding': 50,
        'sql': 40,
      },
      'by_difficulty': {
        'easy': 50,
        'medium': 70,
        'hard': 30,
      },
      'by_category': {
        'Introduction': 20,
        'Algorithms': 30,
        'Data Structures': 25,
        'Basic Queries': 15,
        'Aggregations': 20,
        'Behavioral': 40,
      },
    };
  }

  List<Map<String, dynamic>> _getMockCategories() {
    return [
      {
        'id': '1',
        'name': 'Introduction',
        'type': 'hr',
        'question_count': 20,
        'description': 'Basic introduction and background questions',
      },
      {
        'id': '2',
        'name': 'Algorithms',
        'type': 'coding',
        'question_count': 30,
        'description': 'Algorithm implementation and optimization',
      },
      {
        'id': '3',
        'name': 'Data Structures',
        'type': 'coding',
        'question_count': 25,
        'description': 'Data structure manipulation and implementation',
      },
      {
        'id': '4',
        'name': 'Basic Queries',
        'type': 'sql',
        'question_count': 15,
        'description': 'Basic SQL query writing',
      },
      {
        'id': '5',
        'name': 'Aggregations',
        'type': 'sql',
        'question_count': 20,
        'description': 'SQL aggregation and grouping',
      },
      {
        'id': '6',
        'name': 'Behavioral',
        'type': 'hr',
        'question_count': 40,
        'description': 'Behavioral and situational questions',
      },
    ];
  }
} */
