import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/interview_models.dart';
import '../../../../di.dart';
import '../../../../domain/repo/interview_repo.dart';
import 'interview_event.dart';
import 'interview_state.dart';

class InterviewBloc extends Bloc<InterviewEvent, InterviewBlocState> {
  InterviewModel? _interviewData;
  final IInterviewRepository _interviewRepo = getIt<IInterviewRepository>();


  InterviewBloc() : super(InterviewInitial()) {
    on<StartInterview>(_onStartInterview);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<EndInterview>(_onEndInterview);
    on<SetInterviewState>(_onSetInterviewState);
  }

  Future<void> _onStartInterview(
      StartInterview event,
      Emitter<InterviewBlocState> emit,
      ) async {
    print("🚀 [InterviewBloc] StartInterview event received");
    emit(InterviewLoading());
    try {
      print("📤 [InterviewBloc] Sending initial request to start interview...");
      final response =
      await _interviewRepo.manageInterview(event.initialState, null);
      _interviewData = response;

      print("📥 [InterviewBloc] StartInterview response: "
          "done=${response.done}, "
          "status=${response.sessionStatus}, "
          "question=${response.currentQuestion}");

      if (response.done || response.sessionStatus == 'done') {
        print("✅ [InterviewBloc] Interview is already completed at start");
        emit(InterviewCompleted(response));
      } else {
        print("📝 [InterviewBloc] Interview started with first question");
        emit(InterviewLoaded(response));
      }
    } catch (e) {
      print("❌ [InterviewBloc] Error in StartInterview: $e");
      emit(InterviewError(e.toString()));
    }
  }

  Future<void> _onSubmitAnswer(
      SubmitAnswer event,
      Emitter<InterviewBlocState> emit,
      ) async {
    print("🚀 [InterviewBloc] SubmitAnswer event received");
    print("📝 [InterviewBloc] Answer submitted: ${event.answer}");

    if (_interviewData == null) {
      print("⚠️ [InterviewBloc] Interview not initialized before submitting answer");
      emit(const InterviewError('Interview not initialized'));
      return;
    }

    emit(InterviewLoading());
    try {
      final response =
      await _interviewRepo.manageInterview(_interviewData, event.answer);
      _interviewData = response;

      print("📥 [InterviewBloc] SubmitAnswer response: "
          "done=${response.done}, "
          "status=${response.sessionStatus}, "
          "next_question=${response.currentQuestion}");

      if (response.done || response.sessionStatus == 'done') {
        print("✅ [InterviewBloc] Interview completed after this answer");
        emit(InterviewCompleted(response));
      } else {
        print("➡️ [InterviewBloc] Moving to next question");
        emit(InterviewLoaded(response));
      }
    } catch (e) {
      print("❌ [InterviewBloc] Error in SubmitAnswer: $e");
      emit(InterviewError(e.toString()));
    }
  }

  Future<void> _onEndInterview(
      EndInterview event,
      Emitter<InterviewBlocState> emit,
      ) async {
    print("🚀 [InterviewBloc] EndInterview event received");
    emit(InterviewLoading());
    try {
      final response =
      await _interviewRepo.manageInterview(_interviewData, null);
      _interviewData = response;
      print("✅ [InterviewBloc] Interview ended manually");
      emit(InterviewCompleted(response));
    } catch (e) {
      print("❌ [InterviewBloc] Error in EndInterview: $e");
      emit(InterviewError(e.toString()));
    }
  }

  Future<void> _onSetInterviewState(
      SetInterviewState event,
      Emitter<InterviewBlocState> emit,
      ) async {
    print("🚀 [InterviewBloc] SetInterviewState event received");
    _interviewData = event.interview;

    print("📦 [InterviewBloc] State set manually: "
        "done=${_interviewData!.done}, "
        "status=${_interviewData!.sessionStatus}, "
        "question=${_interviewData!.currentQuestion}");

    if (_interviewData!.sessionStatus == 'done' ||
        _interviewData!.done == true) {
      print("✅ [InterviewBloc] State indicates interview is completed");
      emit(InterviewCompleted(_interviewData!));
    } else {
      print("📝 [InterviewBloc] State indicates interview is still in progress");
      emit(InterviewLoaded(_interviewData!));
    }
  }
}
