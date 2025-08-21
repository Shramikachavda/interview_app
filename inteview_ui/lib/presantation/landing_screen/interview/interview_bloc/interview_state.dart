import 'package:equatable/equatable.dart';
import '../../../../data/models/interview_models.dart';

abstract class InterviewBlocState extends Equatable {
  const InterviewBlocState();

  InterviewModel? get interview => null;

  @override
  List<Object?> get props => [];
}

class InterviewInitial extends InterviewBlocState {}
class InterviewLoading extends InterviewBlocState {}

class InterviewLoaded extends InterviewBlocState {
  final InterviewModel _interview;
  const InterviewLoaded(this._interview);

  @override
  InterviewModel? get interview => _interview;
  @override
  List<Object?> get props => [_interview];
}

class InterviewCompleted extends InterviewBlocState {
  final InterviewModel _interview;
  const InterviewCompleted(this._interview);

  @override
  InterviewModel? get interview => _interview;
  @override
  List<Object?> get props => [_interview];
}

class InterviewError extends InterviewBlocState {
  final String message;
  const InterviewError(this.message);

  @override
  List<Object?> get props => [message];
}


/*


// States
abstract class InterviewState extends Equatable {
  const InterviewState();

  @override
  List<Object?> get props => [];
}

class InterviewInitial extends InterviewState {}

class InterviewLoading extends InterviewState {}

class InterviewInProgress extends InterviewState {
  final InterviewSession session;
  final int currentQuestionIndex;

  const InterviewInProgress({
    required this.session,
    required this.currentQuestionIndex,
  });

  @override
  List<Object?> get props => [session, currentQuestionIndex];
}

class InterviewCompleted extends InterviewState {
  final InterviewSession session;
  final Map<String, dynamic> results;

  const InterviewCompleted({
    required this.session,
    required this.results,
  });

  @override
  List<Object?> get props => [session, results];
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
}*/
