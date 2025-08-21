import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constant/exception/custom_exception.dart';
import '../../netwrok/api_endpoint.dart';
import '../../netwrok/app_client.dart';
import '../models/interview_models.dart';
import 'package:interview_ui/domain/repo/interview_repo.dart';

class InterviewRepoImpl implements IInterviewRepository {
  final ApiClient _apiClient;

  InterviewRepoImpl(this._apiClient);

  @override
  Future<InterviewModel> manageInterview(
      InterviewModel? state,
      String? latestAnswer,
      ) async {
    try {
      // Prepare state map
      final Map<String, dynamic> stateMap = state?.toJson()['state'] ?? {};
      stateMap['latest_answer'] = latestAnswer ?? state?.latestAnswer;

      final requestBody = {'state': stateMap};

      // Log outgoing request
      print("📤 [InterviewRepo] Sending POST to ${ApiEndpoints.interview}");
      print("📦 Request Body: $requestBody");

      // Call API
      final response = await _apiClient.post(ApiEndpoints.interview, requestBody);

      print("📥 [InterviewRepo] Raw Response: $response");

      final model = InterviewModel.fromJson(response);

      // Log parsed model details
      print("✅ [InterviewRepo] Parsed InterviewModel:");
      print("   done: ${model.done}");
      print("   message: ${model.message}");
      print("   currentQuestion: ${model.currentQuestion}");
      print("   total questions: ${model.totalQuestions}");
      print("   q_a_pair length: ${model.qAPair.length}");

      return model;
    } catch (error, stackTrace) {
      print("❌ [InterviewRepo] Error in manageInterview: $error");
      print("🪵 StackTrace: $stackTrace");
      rethrow;
    }
  }
  /// Sends entire interview state to backend to generate PDF and email
  @override
  Future<void> sendFeedbackEmail(InterviewModel state) async {
    // Convert the InterviewModel to JSON directly
    final Map<String, dynamic> data = state.toJson();
    print("\n📤 Sending Interview State:");
    print(data);
    final requestBody = data['state'];

    const int maxAttempts = 2;
    int attempt = 0;

    while (attempt < maxAttempts) {
      attempt++;
      try {
        print('📤 [InterviewRepo] Attempt $attempt - Sending feedback email...');
        print('   Request Body: $requestBody');

        final response = await _apiClient
            .post(ApiEndpoints.feedbackEmail, requestBody, requiresAuth: true)
            .timeout(const Duration(seconds: 20));

        // Log token
        final prefs = await SharedPreferences.getInstance();
        print("🔑 Auth Token: ${prefs.getString('auth_token')}");
        print("📥 Response: $response");

        // Check for server-side errors
        if (response is Map && (response['detail'] != null || response['error'] != null)) {
          final msg = response['detail'] ?? response['error'];
          throw Exception('Server error: $msg');
        }

        print('✅ Feedback email sent successfully.');
        return;
      } on TimeoutException catch (te) {
        print('⏱️ Timeout on attempt $attempt: $te');
        if (attempt >= maxAttempts) throw TimeoutException('Request timed out after $attempt attempts');
        await Future.delayed(const Duration(milliseconds: 500));
      } on UnauthorizedException catch (_) {
        print('🚫 Unauthorized access. Check token.');
        throw Exception('Unauthorized access. Please check your token.');
      } on Exception catch (e) {
        print('❌ Attempt $attempt failed: $e');
        if (attempt >= maxAttempts) rethrow;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }
}
