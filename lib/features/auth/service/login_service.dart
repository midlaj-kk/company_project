import 'package:auto_care_app/core/api/api_client.dart';
import 'package:auto_care_app/core/storage/shared_prefernce.dart';

/// Handles the login API call and everything that must happen
/// right after: saving tokens, fetching the user's role.
class LoginService {
  final _dio = ApiClient().dio;

  /// Calls POST /auth/login/, saves the tokens, then calls
  /// GET /auth/me/ to find out the user's role.
  /// Returns the role string (e.g. "admin", "mechanic") on success.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final loginResponse = await _dio.post(
      '/auth/login/',
      data: {'email': email, 'password': password},
    );

    final accessToken = loginResponse.data['access'] as String;
    final refreshToken = loginResponse.data['refresh'] as String;

    await SecureStorage().saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    final meResponse = await _dio.get('/auth/me/');
    final meData = meResponse.data is Map && meResponse.data['data'] is Map
        ? meResponse.data['data']
        : meResponse.data;
    final role = meData['role'] as String;

    await SecureStorage().saveUserRole(role);
    return role;
  }
}