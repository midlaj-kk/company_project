import 'package:auto_care_app/core/api/api_client.dart';
import 'package:auto_care_app/core/demo/demo_config.dart';
import 'package:auto_care_app/core/storage/shared_prefernce.dart';

/// Handles the login API call and everything that must happen
/// right after: saving tokens, fetching the user's role.
class LoginService {
  final _dio = ApiClient().dio;

  /// TEMPORARY DEMO MODE:
  /// Mirrors the observable result of the real login flow (saves the
  /// role so the existing navigation works exactly as designed) but
  /// performs no network calls. The email decides which dashboard to
  /// land on:
  ///   * email containing "advisor"  -> Service Advisor dashboard
  ///   * email containing "mechanic" -> Mechanic dashboard
  ///   * email containing "cashier"  -> Cashier dashboard
  ///   * anything else               -> Admin dashboard
  Future<String> _demoLogin({required String email}) async {
    final String role;
    final String normalized = email.toLowerCase();
    if (normalized.contains('advisor')) {
      role = 'service_advisor';
    } else if (normalized.contains('mechanic')) {
      role = 'mechanic';
    } else if (normalized.contains('cashier')) {
      role = 'cashier';
    } else {
      role = 'admin';
    }

    await SecureStorage().saveUserRole(role);
    return role;
  }

  /// Calls POST /auth/login/, saves the tokens, then calls
  /// GET /auth/me/ to find out the user's role.
  /// Returns the role string (e.g. "admin", "mechanic") on success.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    // DEMO MODE:
    // Skip the backend entirely. Set [demoMode] to false (see
    // lib/core/demo/demo_config.dart) to restore real authentication.
    if (demoMode) {
      return _demoLogin(email: email);
    }

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