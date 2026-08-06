import 'package:auto_care_app/features/admin/controller/add_mechanic_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_text_field.dart';
import '../widgets/avatar_upload_picker.dart';
import '../widgets/role_selector.dart';

/// Admin "Add/Edit Mechanic" (staff) form — creates a new staff
/// account of any role (Admin, Advisor, Mechanic, Cashier).
class AddMechanicScreen extends StatelessWidget {
  const AddMechanicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMechanicController(),
      child: const _AddMechanicView(),
    );
  }
}

class _AddMechanicView extends StatelessWidget {
  const _AddMechanicView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddMechanicController>();

    // Once creation succeeds, show a confirmation and pop back.
    if (controller.createdSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff account created successfully')),
        );
        Navigator.of(context).maybePop();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      'Admin - Add/Edit Mechanic',
                      style: AppTextStyles.heading3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  children: [
                    AvatarUploadPicker(onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Profile photo upload is not available yet.'),
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    _FieldLabel('Full Name'),
                    AppTextField(
                      controller: controller.nameController,
                      hint: 'e.g. Robert Jensen',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),

                    _FieldLabel('Email Address'),
                    AppTextField(
                      controller: controller.emailController,
                      hint: 'r.jensen@autocare.pro',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    _FieldLabel('Phone Number'),
                    AppTextField(
                      controller: controller.phoneController,
                      hint: '+1 (555) 000-0000',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    if (controller.isMechanicRole) ...[
                      _FieldLabel('Specialization'),
                      AppTextField(
                        controller: controller.specializationController,
                        hint: 'e.g. Engine & Transmission',
                        icon: Icons.build_outlined,
                      ),
                      const SizedBox(height: 16),
                    ],

                    Align(
                      alignment: Alignment.centerLeft,
                      child: _FieldLabel('System Role'),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RoleSelector(
                        selectedRole: controller.selectedRole,
                        onChanged: (role) =>
                            context.read<AddMechanicController>().setRole(role),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: _FieldLabel('Temporary Password')),
                        TextButton(
                          onPressed: () => context
                              .read<AddMechanicController>()
                              .generatePassword(),
                          child: const Text('Generate',
                              style: TextStyle(color: AppColors.limeAccent)),
                        ),
                      ],
                    ),
                    AppTextField(
                      controller: controller.passwordController,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: controller.obscurePassword,
                      trailing: IconButton(
                        icon: Icon(
                          controller.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => context
                            .read<AddMechanicController>()
                            .toggleObscurePassword(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              color: AppColors.limeAccent, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Login credentials will be shared with the staff '
                              'member after creation. They will be prompted to '
                              'reset their password on first login.',
                              style: AppTextStyles.caption,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (controller.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.statusError,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Create Account',
                      isLoading: controller.isLoading,
                      onPressed: () =>
                          context.read<AddMechanicController>().submit(),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: Text('Cancel', style: AppTextStyles.bodySecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.limeAccent,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}