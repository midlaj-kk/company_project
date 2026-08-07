import 'package:auto_care_app/core/storage/shared_prefernce.dart';

/// Handles login and everything that must happen right after:
/// saving the role so navigation works.
class LoginService {
  /// Demo-only login: the email decides which dashboard to land on.
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

  /// Returns the role string (e.g. "admin", "mechanic") on success.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    return _demoLogin(email: email);
  }
}
