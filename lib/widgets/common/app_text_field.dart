import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Pill-shaped input field with a leading icon, used across
/// login, forms, and search bars throughout the app.
///
/// Example:
///   AppTextField(
///     controller: emailController,
///     hint: 'you@autocare.com',
///     icon: Icons.email_outlined,
///   )
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.trailing,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? trailing;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        suffixIcon: trailing,
      ),
    );
  }
}