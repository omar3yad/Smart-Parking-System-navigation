import 'package:dio/dio.dart';

import '../models/auth_tokens.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/secure_storage_service.dart';

class AuthRepository {
  AuthRepository({
    ApiClient? apiClient,
    SecureStorageService? secureStorageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = secureStorageService ?? SecureStorageService();

  final ApiClient _apiClient;
  final SecureStorageService _storage;

  Future<(User, AuthTokens)> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final Response<dynamic> response =
          await _apiClient.post<dynamic>('/auth/register/', data: <String, dynamic>{
        'username': username,
        'password': password,
        'password_confirm': passwordConfirm,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = (response.data is Map<String, dynamic>)
            ? (response.data as Map<String, dynamic>)
            : <String, dynamic>{};

        // Backend register returns: { "user": {...}, "message": "..." } (no tokens).
        final user = data['user'] is Map<String, dynamic>
            ? User.fromJson(data['user'] as Map<String, dynamic>)
            : User.fromJson(data);

        // Login immediately to obtain JWT tokens for the new account.
        final loginResult = await login(username: username, password: password);
        final loggedInUser = loginResult.$1 ?? user;
        final tokens = loginResult.$2;
        return (loggedInUser, tokens);
      }
      throw Exception('Registration failed (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, fallback: 'Registration failed'));
    }
  }

  Future<(User?, AuthTokens)> login({
    required String username,
    required String password,
  }) async {
    try {
      final Response<dynamic> response =
          await _apiClient.post<dynamic>('/auth/login/', data: <String, dynamic>{
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final tokens = AuthTokens.fromJson(data);
        User? user;
        if (data['user'] != null) {
          user = User.fromJson(data['user'] as Map<String, dynamic>);
        }

        await _storage.saveTokens(
          accessToken: tokens.access,
          refreshToken: tokens.refresh,
        );
        return (user, tokens);
      }
      throw Exception('Login failed (${response.statusCode})');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, fallback: 'Login failed'));
    }
  }

  Future<void> logout() async {
    await _storage.clearTokens();
  }

  Future<bool> hasValidSession() async {
    final access = await _storage.readAccessToken();
    return access != null && access.isNotEmpty;
  }

  String _extractErrorMessage(DioException exception,
      {required String fallback}) {
    final response = exception.response;
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      if (data['detail'] != null) {
        return data['detail'].toString();
      }
      if (data['error'] != null) {
        return data['error'].toString();
      }
      // DRF validation errors usually look like:
      // { "field": ["msg1", "msg2"], "non_field_errors": ["msg"] }
      final formatted = _formatValidationErrors(data);
      if (formatted != null && formatted.isNotEmpty) {
        return formatted;
      }
    }
    return fallback;
  }

  String? _formatValidationErrors(Map<String, dynamic> data) {
    final lines = <String>[];

    void addLine(String key, String message) {
      final label = key == 'non_field_errors' ? 'Error' : key;
      lines.add('$label: $message');
    }

    for (final entry in data.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value == null) continue;

      if (value is List) {
        final msgs = value.map((e) => e.toString()).where((s) => s.isNotEmpty);
        final joined = msgs.join('\n- ');
        if (joined.isNotEmpty) {
          addLine(key, '- $joined');
        }
      } else if (value is Map) {
        // Rare: nested errors, stringify one level.
        addLine(key, value.toString());
      } else {
        final msg = value.toString();
        if (msg.isNotEmpty) addLine(key, msg);
      }
    }

    if (lines.isEmpty) return null;
    return lines.join('\n');
  }
}

