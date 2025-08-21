// data/api/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constant/exception/custom_exception.dart';

class ApiClient {
  late http.Client _client;

  static const String _tokenKey = 'auth_token';

  ApiClient() {
    _client = http.Client();
  }

  /// Save token manually (optional if not using SharedPreferences)
  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Clear token from both memory and SharedPreferences
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Builds headers dynamically (fetches token if available)
  Future<Map<String, String>> _headers({bool requiresAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    try {
      final Map<String, dynamic> jsonResponse = jsonDecode(body);

      if (statusCode >= 200 && statusCode < 300) {
        return jsonResponse;
      } else if (statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(jsonResponse['message'] ?? 'Server error');
      }
    } on SocketException {
      throw const NetworkException("No Internet connection.");
    } on FormatException {
      throw const UnexpectedException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = false}) async {
    final response = await _client.get(
      Uri.parse(endpoint),
      headers: await _headers(requiresAuth: requiresAuth),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {bool requiresAuth = false}) async {
    final response = await _client.post(
      Uri.parse(endpoint),
      headers: await _headers(requiresAuth: requiresAuth),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data,
      {bool requiresAuth = false}) async {
    final response = await _client.put(
      Uri.parse(endpoint),
      headers: await _headers(requiresAuth: requiresAuth),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = false}) async {
    final response = await _client.delete(
      Uri.parse(endpoint),
      headers: await _headers(requiresAuth: requiresAuth),
    );
    return _handleResponse(response);
  }

  void dispose() {
    _client.close();
  }
}
