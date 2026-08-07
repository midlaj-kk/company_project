import 'package:auto_care_app/features/auth/service/login_service.dart';
import 'package:flutter/material.dart';

/// Holds all mutable state for the Login screen (loading, error,
/// password visibility, remember-me) and notifies listeners on
/// change. The screen no longer calls setState() directly — it
/// reads values from this controller via Provider/Consumer.
class LoginController extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;
  bool isLoading = false;
  String? errorMessage;

  /// Result role after a successful login, so the UI can navigate.
  String? loggedInRole;

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Please enter both email and password';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final role = await _loginService.login(email: email, password: password);
      loggedInRole = role;
    } catch (e, stackTrace) {
      // TEMPORARY debug logging — remove once the real cause is found.
      debugPrint('LOGIN ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Call after the UI has consumed loggedInRole (e.g. after
  /// navigating) so a rebuild doesn't try to navigate again.
  void clearLoginResult() {
    loggedInRole = null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}