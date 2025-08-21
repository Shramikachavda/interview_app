/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/interview_models.dart';
import '../models/user_model.dart';

class InterviewRepository {


  // API Methods
  Future<List<InterviewSession>> getUserSessions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/sessions/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => InterviewSession.fromJson(json)).toList();
      } else {
        // Return mock data for now
        return _getMockSessions();
      }
    } catch (e) {
      // Return mock data on error
      return _getMockSessions();
    }
  }

  Future<InterviewSession> startInterview({
    required String userId,
    required String type,
    required String difficulty,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/interviews/start'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'type': type,
          'difficulty': difficulty,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return InterviewSession.fromJson(data);
      } else {
        // Return mock session
        return _createMockSession(userId, type, difficulty);
      }
    } catch (e) {
      // Return mock session on error
      return _createMockSession(userId, type, difficulty);
    }
  }

  Future<void> submitAnswer({
    required String sessionId,
    required String questionId,
    required String answer,
  }) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/interviews/$sessionId/answers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'question_id': questionId,
          'answer': answer,
        }),
      );
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<Map<String, dynamic>> submitInterview(String sessionId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/interviews/$sessionId/submit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Return mock results
        return _getMockResults();
      }
    } catch (e) {
      // Return mock results on error
      return _getMockResults();
    }
  }

  // Local Storage Methods
  Future<void> saveSession(InterviewSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getLocalSessions();
    sessions.add(session);
    
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await prefs.setString(_sessionsKey, json.encode(sessionsJson));
  }

  Future<List<InterviewSession>> getLocalSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString(_sessionsKey);
    
    if (sessionsJson != null) {
      final List<dynamic> data = json.decode(sessionsJson);
      return data.map((json) => InterviewSession.fromJson(json)).toList();
    }
    
    return [];
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<User?> getLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      final data = json.decode(userJson);
      return User.fromJson(data);
    }
    
    return null;
  }




} */
