import 'package:equatable/equatable.dart';
import '../../../../data/models/interview_models.dart';

import 'package:equatable/equatable.dart';
import '../../../../data/models/interview_models.dart';

abstract class InterviewEvent extends Equatable {
  const InterviewEvent();

  @override
  List<Object?> get props => [];
}

class StartInterview extends InterviewEvent {
  final InterviewModel initialState;

  const StartInterview({required this.initialState});

  @override
  List<Object?> get props => [initialState];
}

class SubmitAnswer extends InterviewEvent {
  final String answer;

  const SubmitAnswer({required this.answer});

  @override
  List<Object?> get props => [answer];
}

class EndInterview extends InterviewEvent {
  const EndInterview();
}

class SetInterviewState extends InterviewEvent {
  final InterviewModel interview;

  const SetInterviewState({required this.interview});

  @override
  List<Object?> get props => [interview];
}


