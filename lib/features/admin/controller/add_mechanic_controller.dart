import 'dart:math';
import 'package:auto_care_app/features/admin/service/admin_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Holds state for the Add/Edit Staff form: text controllers,
/// selected role, temporary password, loading/error/success flags.
class AddMechanicController extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedRole = 'mechanic';
  bool obscurePassword = true;
  bool isLoading = false;
  String? errorMessage;
  bool createdSuccessfully = false;

  void setRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  /// Generates a readable random temporary password, e.g. "Ac7f2Kq9".
  void generatePassword() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789';
    final rand = Random.secure();
    passwordController.text =
        List.generate(10, (_) => chars[rand.nextInt(chars.length)]).join();
    notifyListeners();
  }

  bool get isMechanicRole => selectedRole == 'mechanic';

  Future<void> submit() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      errorMessage = 'Please fill in all required fields';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _adminService.createStaff(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        role: selectedRole,
        password: passwordController.text,
        specialization: isMechanicRole
            ? specializationController.text.trim()
            : null,
      );
      createdSuccessfully = true;
    } on DioException catch (e) {
      errorMessage = e.response?.data is Map
          ? (e.response?.data.values.first is List
                  ? e.response?.data.values.first[0]
                  : 'Could not create account.')
              .toString()
          : 'Could not reach the server. Check your connection.';
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    specializationController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}