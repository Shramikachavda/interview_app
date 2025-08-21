class ApiEndpoints {


  static const String baseUrl = 'http://127.0.0.1:8000/api';
  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String currentUser = '$baseUrl/auth/me';

  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  // Interview endpoints
  static const String interview = '$baseUrl/interview/interview';
  static const String feedbackEmail = '$baseUrl/interview/send_feedback_email';




  // Questions endpoints
  static const String questions = '/questions';
  static const String questionById = '/questions/{id}';
  static const String questionCategories = '/questions/categories';

  // Analytics endpoints
  static const String userStats = '/analytics/user-stats';
  static const String interviewStats = '/analytics/interview-stats';
  static const String performanceHistory = '/analytics/performance';

  // Settings endpoints
  static const String userSettings = '/settings';
  static const String updateSettings = '/settings';

  // Notifications endpoints
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String markAllNotificationsRead = '/notifications/read-all';
} 