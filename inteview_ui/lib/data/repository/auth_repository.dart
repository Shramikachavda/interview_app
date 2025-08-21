import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constant/app_constant.dart';
import '../../core/constant/exception/custom_exception.dart';
import '../../domain/repo/auth_repo.dart';
import '../../netwrok/api_endpoint.dart';
import '../models/user_model.dart';

class AuthRepository implements IAuthRepository {

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse(ApiEndpoints.login);
    print("📡 [Repo] Sending login request to: $uri");
    print("📤 [Repo] Request Body: { email: $email, password: $password }");

    try {
      final response = await http.post(
        uri,
        headers: _headers(),
        body: json.encode({'email': email, 'password': password}),
      );

      print("📥 [Repo] Response Code: ${response.statusCode}");
      print("📥 [Repo] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("✅ [Repo] Parsed JSON: $jsonResponse");

        final data = jsonResponse['data'];
        final accessToken = data['access_token'];
        final userJson = data['user'];

        print("userJson");
        print(userJson);

        await _saveToken(accessToken);
        await _saveUser(User.fromJson(userJson));

        return {
          'success': true,
          'data': data,
        };
      } else if (response.statusCode == 401) {
        print("🚫 [Repo] Unauthorized (401) - Invalid credentials");
        throw const UnauthorizedException();
      } else {
        print("❌ [Repo] Server error: ${response.body}");
        throw ServerException(_parseError(response));
      }
    } on SocketException {
      print("🌐 [Repo] No internet connection");
      throw const NetworkException("No Internet connection.");
    } on FormatException {
      print("⚠️ [Repo] Format Exception while decoding JSON");
      throw const UnexpectedException();
    } catch (e) {
      print("💥 [Repo] Unexpected Exception: $e");
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      String level,
      ) async {
    final uri = Uri.parse(ApiEndpoints.register);
    print("📡 [Repo] Sending register request to: $uri");
    print("📤 [Repo] Request Body: { name: $name, email: $email, password: $password, level: $level }");

    try {
      final response = await http.post(
        uri,
        headers: _headers(),
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'level': level,
        }),
      );

      print("📥 [Repo] Response Code: ${response.statusCode}");
      print("📥 [Repo] Response Body: ${response.body}");

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        print("✅ [Repo] Parsed JSON: $jsonResponse");

        final data = jsonResponse['data'];
        final accessToken = data['access_token'];
        final userJson = data['user'];

        await _saveToken(accessToken);
        await _saveUser(User.fromJson(userJson));

        return {
          'success': true,
          'data': data,
        };
      } else {
        print("❌ [Repo] Server error: ${response.body}");
        throw ServerException(_parseError(response));
      }
    } on SocketException {
      print("🌐 [Repo] No internet connection");
      throw const NetworkException("No Internet connection.");
    } on FormatException {
      print("⚠️ [Repo] Format Exception while decoding JSON");
      throw const UnexpectedException();
    } catch (e) {
      print("💥 [Repo] Unexpected Exception: $e");
      throw UnexpectedException(e.toString());
    }
  }


  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final token = await _getToken();
    final uri = Uri.parse(ApiEndpoints.changePassword);
    try {
      final response = await http.post(
        uri,
        headers: _headers(token),
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(_parseError(response));
      }
    } on SocketException {
      throw const NetworkException("No Internet connection.");
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final uri = Uri.parse(ApiEndpoints.forgotPassword);
    try {
      final response = await http.post(
        uri,
        headers: _headers(),
        body: json.encode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw ServerException(_parseError(response));
      }
    } on SocketException {
      throw const NetworkException("No Internet connection.");
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final uri = Uri.parse(ApiEndpoints.resetPassword);
    try {
      final response = await http.post(
        uri,
        headers: _headers(),
        body: json.encode({'token': token, 'new_password': newPassword}),
      );

      if (response.statusCode != 200) {
        throw ServerException(_parseError(response));
      }
    } on SocketException {
      throw const NetworkException("No Internet connection.");
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    final token = await _getToken();
    final uri = Uri.parse(ApiEndpoints.logout);

    try {
      if (token != null) {
        final response = await http.post(uri, headers: _headers(token));

        if (response.statusCode != 200) {
          // Optional: Parse error response body if needed
          throw ServerException("Logout failed with status code ${response.statusCode}");
        }
      }
    } on SocketException {
      throw const NetworkException("No internet connection.");
    } on TimeoutException {
      throw const NetworkException("Logout request timed out.");
    } catch (e) {
      throw UnexpectedException("Unexpected error during logout: $e");
    } finally {
      await _clearAuthData();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _getToken();
    if (token == null) return null;

    final uri = Uri.parse(ApiEndpoints.currentUser);
    try {
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 401) {
        await _clearAuthData();
        return null;
      } else {
        throw ServerException(_parseError(response));
      }
    } on SocketException {
      throw const NetworkException("No Internet connection.");
    } on FormatException {
      throw const UnexpectedException("Invalid response format.");
    } catch (e) {
      throw UnexpectedException("Unexpected error while fetching user: $e");
    }
  }


  @override
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    final token = await _getToken();
    final uri = Uri.parse(ApiEndpoints.updateProfile);
    try {
      final response = await http.put(
        uri,
        headers: _headers(token),
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveUser(User.fromJson(data));
      } else {
        throw ServerException(_parseError(response));
      }
    } on SocketException {
      throw const NetworkException("No Internet connection.");
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _getToken() != null;
  }

  // ======================== PRIVATE HELPERS ========================

  Map<String, String> _headers([String? token]) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  String _parseError(http.Response response) {
    try {
      final data = json.decode(response.body);
      return data['message'] ?? 'Unexpected server error';
    } catch (_) {
      return 'Unexpected error: ${response.statusCode}';
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authTokenKey, token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.authTokenKey);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userDataKey, json.encode(user.toJson()));
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokenKey);
    await prefs.remove(AppConstants.userDataKey);
  }
}
