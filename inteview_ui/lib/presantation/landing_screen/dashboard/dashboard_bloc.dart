/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class InterviewEvent extends Equatable {
  const InterviewEvent();

  @override
  List<Object?> get props => [];
}

class StartInterview extends InterviewEvent {
  final int userId;
  final String sessionType;
  final String userExperience;

  const StartInterview({
    required this.userId,
    required this.sessionType,
    required this.userExperience,
  });

  @override
  List<Object?> get props => [userId, sessionType, userExperience];
}

class LoadNextQuestion extends InterviewEvent {
  final int sessionId;

  const LoadNextQuestion(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SubmitResponse extends InterviewEvent {
  final int sessionId;
  final int questionId;
  final String responseText;
  final Map<String, dynamic>? responseData;

  const SubmitResponse({
    required this.sessionId,
    required this.questionId,
    required this.responseText,
    this.responseData,
  });

  @override
  List<Object?> get props => [sessionId, questionId, responseText, responseData];
}

class LoadSession extends InterviewEvent {
  final int sessionId;

  const LoadSession(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class LoadUserSessions extends InterviewEvent {
  final int userId;

  const LoadUserSessions(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ClearSession extends InterviewEvent {}

// States
abstract class InterviewState extends Equatable {
  const InterviewState();

  @override
  List<Object?> get props => [];
}

class InterviewInitial extends InterviewState {}

class InterviewLoading extends InterviewState {}

class InterviewLoaded extends InterviewState {
  final InterviewSession? session;
  final InterviewQuestion? currentQuestion;
  final List<InterviewQuestion> questions;
  final List<UserResponse> responses;
  final bool isComplete;

  const InterviewLoaded({
    this.session,
    this.currentQuestion,
    this.questions = const [],
    this.responses = const [],
    this.isComplete = false,
  });

  @override
  List<Object?> get props => [session, currentQuestion, questions, responses, isComplete];
}

class InterviewError extends InterviewState {
  final String message;

  const InterviewError(this.message);

  @override
  List<Object?> get props => [message];
}

class SessionsLoaded extends InterviewState {
  final List<InterviewSession> sessions;

  const SessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

// Models
class InterviewSession {
  final int id;
  final String sessionType;
  final String status;
  final int currentQuestionIndex;
  final int totalQuestions;
  final DateTime createdAt;
  final DateTime? completedAt;
  final double? overallScore;

  InterviewSession({
    required this.id,
    required this.sessionType,
    required this.status,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.createdAt,
    this.completedAt,
    this.overallScore,
  });

  factory InterviewSession.fromJson(Map<String, dynamic> json) {
    return InterviewSession(
      id: json['session_id'] ?? json['id'],
      sessionType: json['session_type'],
      status: json['status'],
      currentQuestionIndex: json['current_question_index'] ?? 0,
      totalQuestions: json['total_questions'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      overallScore: json['overall_score']?.toDouble(),
    );
  }
}

class InterviewQuestion {
  final int id;
  final String type;
  final String text;
  final Map<String, dynamic>? data;
  final int index;
  final bool isAnswered;

  InterviewQuestion({
    required this.id,
    required this.type,
    required this.text,
    this.data,
    required this.index,
    required this.isAnswered,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'],
      type: json['type'],
      text: json['text'],
      data: json['data'],
      index: json['index'],
      isAnswered: json['is_answered'] ?? false,
    );
  }
}

class UserResponse {
  final int id;
  final int? questionId;
  final String text;
  final Map<String, dynamic>? data;
  final String? aiFeedback;
  final int? score;
  final DateTime createdAt;

  UserResponse({
    required this.id,
    this.questionId,
    required this.text,
    this.data,
    this.aiFeedback,
    this.score,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      questionId: json['question_id'],
      text: json['text'],
      data: json['data'],
      aiFeedback: json['ai_feedback'],
      score: json['score'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// BLoC
class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  static const String _baseUrl = 'http://localhost:8000/api';

  InterviewBloc() : super(InterviewInitial()) {
    on<StartInterview>(_onStartInterview);
    on<LoadNextQuestion>(_onLoadNextQuestion);
    on<SubmitResponse>(_onSubmitResponse);
    on<LoadSession>(_onLoadSession);
    on<LoadUserSessions>(_onLoadUserSessions);
    on<ClearSession>(_onClearSession);
  }

  Future<void> _onStartInterview(
      StartInterview event,
      Emitter<InterviewState> emit,
      ) async {
    emit(InterviewLoading());

    try {
      final uri = Uri.parse('$_baseUrl/interview/start').replace(
        queryParameters: {
          'user_id': event.userId.toString(),
          'session_type': event.sessionType,
          'user_experience': event.userExperience,
        },
      );

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final session = InterviewSession.fromJson(data);
        emit(InterviewLoaded(session: session));
      } else {
        final errorData = json.decode(response.body);
        emit(InterviewError(errorData['detail'] ?? 'Failed to start interview'));
      }
    } catch (e) {
      emit(InterviewError('Network error: $e'));
    }
  }

  Future<void> _onLoadNextQuestion(
      LoadNextQuestion event,
      Emitter<InterviewState> emit,
      ) async {
    emit(InterviewLoading());

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/interview/${event.sessionId}/next-question'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final question = InterviewQuestion.fromJson(data['question']);
        emit(InterviewLoaded(currentQuestion: question));
      } else {
        final errorData = json.decode(response.body);
        emit(InterviewError(errorData['detail'] ?? 'Failed to get next question'));
      }
    } catch (e) {
      emit(InterviewError('Network error: $e'));
    }
  }

  Future<void> _onSubmitResponse(
      SubmitResponse event,
      Emitter<InterviewState> emit,
      ) async {
    emit(InterviewLoading());

    try {
      final queryParams = {
        'question_id': event.questionId.toString(),
        'response_text': event.responseText,
      };

      if (event.responseData != null) {
        queryParams['response_data'] = json.encode(event.responseData);
      }

      final uri = Uri.parse('$_baseUrl/interview/${event.sessionId}/submit-response').replace(
        queryParameters: queryParams,
      );

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isComplete = data['session_progress']['is_complete'] ?? false;

        if (isComplete) {
          // Load the complete session with final feedback
          add(LoadSession(event.sessionId));
        } else {
          // Load next question
          add(LoadNextQuestion(event.sessionId));
        }
      } else {
        final errorData = json.decode(response.body);
        emit(InterviewError(errorData['detail'] ?? 'Failed to submit response'));
      }
    } catch (e) {
      emit(InterviewError('Network error: $e'));
    }
  }

  Future<void> _onLoadSession(
      LoadSession event,
      Emitter<InterviewState> emit,
      ) async {
    emit(InterviewLoading());

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/interview/${event.sessionId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final session = InterviewSession.fromJson(data['session']);
        final questions = (data['questions'] as List)
            .map((q) => InterviewQuestion.fromJson(q))
            .toList();
        final responses = (data['responses'] as List)
            .map((r) => UserResponse.fromJson(r))
            .toList();

        emit(InterviewLoaded(
          session: session,
          questions: questions,
          responses: responses,
          isComplete: session.status == 'completed',
        ));
      } else {
        final errorData = json.decode(response.body);
        emit(InterviewError(errorData['detail'] ?? 'Failed to load session'));
      }
    } catch (e) {
      emit(InterviewError('Network error: $e'));
    }
  }

  Future<void> _onLoadUserSessions(
      LoadUserSessions event,
      Emitter<InterviewState> emit,
      ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/${event.userId}/sessions'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final sessions = data.map((s) => InterviewSession.fromJson(s)).toList();
        emit(SessionsLoaded(sessions));
      } else {
        emit(SessionsLoaded([]));
      }
    } catch (e) {
      emit(SessionsLoaded([]));
    }
  }

  void _onClearSession(
      ClearSession event,
      Emitter<InterviewState> emit,
      ) {
    emit(InterviewInitial());
  }
}*/
