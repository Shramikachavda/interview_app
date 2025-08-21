
import '../../data/models/interview_models.dart';

abstract class IInterviewRepository {
  Future<InterviewModel> manageInterview(
      InterviewModel? state,
      String? latestAnswer,
      );

  Future<void> sendFeedbackEmail(InterviewModel state);
}
