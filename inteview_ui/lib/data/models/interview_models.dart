import '../../core/constant/enums/difficulty_level.dart';
import '../../core/constant/enums/session_type.dart';
import 'feedback_response.dart';

class InterviewModel {
  final String? message;
  final bool done;

  // Interview State Fields
  final String? sessionId;
  final int userId;
  final SessionType sessionType;
  final DifficultyLevel level;
  final int currentQuestionIndex;
  final int totalQuestions;
  final String? currentQuestion; // <- use this to display question
  final int? currentQuestionId;
  final List<Map<String, dynamic>> qAPair; // FIXED type
  final List<int> askedQuestionIds;
  final List<String> askedLlmQuestions;
  final String sessionStatus;
  final InterviewFeedback? feedback;
  final String? currentQuestionType;
  final String? latestAnswer;

  InterviewModel({
    this.message,
    required this.done,
    this.sessionId,
    required this.userId,
    required this.sessionType,
    required this.level,
    this.currentQuestionIndex = 0,
    this.totalQuestions = 0,
    this.currentQuestion,
    this.currentQuestionId,
    this.qAPair = const [],
    this.askedQuestionIds = const [],
    this.askedLlmQuestions = const [],
    this.sessionStatus = 'not_done',
    this.feedback,
    this.currentQuestionType,
    this.latestAnswer,
  });

  InterviewModel copyWith({
    String? message,
    bool? done,
    String? sessionId,
    int? userId,
    SessionType? sessionType,
    DifficultyLevel? level,
    int? currentQuestionIndex,
    int? totalQuestions,
    String? currentQuestion,
    int? currentQuestionId,
    List<Map<String, dynamic>>? qAPair,
    List<int>? askedQuestionIds,
    List<String>? askedLlmQuestions,
    String? sessionStatus,
    InterviewFeedback? feedback,
    String? currentQuestionType,
    String? latestAnswer,
  }) {
    return InterviewModel(
      message: message ?? this.message,
      done: done ?? this.done,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      sessionType: sessionType ?? this.sessionType,
      level: level ?? this.level,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      currentQuestionId: currentQuestionId ?? this.currentQuestionId,
      qAPair: qAPair ?? this.qAPair,
      askedQuestionIds: askedQuestionIds ?? this.askedQuestionIds,
      askedLlmQuestions: askedLlmQuestions ?? this.askedLlmQuestions,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      feedback: feedback ?? this.feedback,
      currentQuestionType: currentQuestionType ?? this.currentQuestionType,
      latestAnswer: latestAnswer ?? this.latestAnswer,
    );
  }

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    final state = json['state'] ?? {};
    return InterviewModel(
      message: json['message'],
      done: json['done'] ?? false,
      sessionId: state['session_id']?.toString(),
      userId: state['user_id'] ?? 0,
      sessionType: SessionType.values.firstWhere(
            (e) => e.name == (state['session_type'] ?? '').toString(),
        orElse: () => SessionType.hr,
      ),
      level: DifficultyLevel.values.firstWhere(
            (e) => e.name == (state['level'] ?? '').toString(),
        orElse: () => DifficultyLevel.easy,
      ),
      currentQuestionIndex: state['current_question_index'] ?? 0,
      totalQuestions: state['total_questions'] ?? 0,
      currentQuestion: state['current_question'],
      currentQuestionId: state['current_question_id'],
      qAPair: (state['q_a_pair'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      askedQuestionIds: List<int>.from(state['asked_question_ids'] ?? []),
      askedLlmQuestions: List<String>.from(state['asked_llm_questions'] ?? []),
      sessionStatus: state['session_status'] ?? 'not_done',
      feedback: state['feedback'] != null
          ? InterviewFeedback.fromJson(state['feedback'])
          : null,
      currentQuestionType: state['current_question_type'],
      latestAnswer: state['latest_answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': {
        'session_id': sessionId,
        'user_id': userId,
        'session_type': sessionType.name,
        'level': level.name,
        'current_question_index': currentQuestionIndex,
        'total_questions': totalQuestions,
        'current_question': currentQuestion,
        'current_question_id': currentQuestionId,
        'q_a_pair': qAPair,
        'asked_question_ids': askedQuestionIds,
        'asked_llm_questions': askedLlmQuestions,
        'session_status': sessionStatus,
        'feedback': feedback?.toJson(),
        'current_question_type': currentQuestionType,
        'latest_answer': latestAnswer,
      }
    };
  }
}
