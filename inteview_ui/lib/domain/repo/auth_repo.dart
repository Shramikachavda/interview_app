
import '../../data/models/user_model.dart';

abstract class IAuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      String level,
      ) ;
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> updateProfile(Map<String, dynamic> profileData);
  Future<bool> isAuthenticated();
}
