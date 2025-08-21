import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/feedback_response.dart';
import '../data/models/interview_models.dart';
import '../presantation/landing_screen/interview/interview_bloc/interview_event.dart';

Future<void> saveFeedbackAndInterview(
    InterviewFeedback feedback, InterviewModel interview) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('feedback_data', jsonEncode(feedback.toJson()));
  await prefs.setString('interview_state', jsonEncode(interview.toJson()));
}


Future<Map<String, dynamic>?> loadFeedbackAndInterview() async {
  final prefs = await SharedPreferences.getInstance();

  final feedbackJson = prefs.getString('feedback_data');
  final interviewJson = prefs.getString('interview_state');

  if (feedbackJson == null || interviewJson == null) {
    return null;
  }

  return {
    'feedback': InterviewFeedback.fromJson(jsonDecode(feedbackJson)),
    'interviewState': InterviewModel.fromJson(jsonDecode(interviewJson)),
  };
}


Future<void> clearSavedFeedback() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('feedback_data');
  await prefs.remove('interview_state');
}


