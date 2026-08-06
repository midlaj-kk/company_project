import 'package:auto_care_app/core/router/app_router.dart';
import 'package:auto_care_app/core/theme/app_colors.dart';
import 'package:auto_care_app/core/theme/app_text_styles.dart';
import 'package:auto_care_app/features/auth/controller/login_controller.dart';
import 'package:auto_care_app/widgets/common/app_button.dart';
import 'package:auto_care_app/widgets/common/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// Staff login screen. Same design as before — the only change is
/// that state (loading, error, password visibility, remember-me)
/// now lives in LoginController instead of setState.
///
/// This screen provides its own LoginController via
/// ChangeNotifierProvider, so no changes are needed in main.dart.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  void _onLoginSuccess(BuildContext context, String role) {
    context.read<LoginController>().clearLoginResult();
    AppRouter.afterLogin(context, role);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for a successful login result and navigate once.
    final controller = context.watch<LoginController>();
    if (controller.loggedInRole != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          _onLoginSuccess(context, controller.loggedInRole!);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _HeroHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back', style: AppTextStyles.heading1),
                    const SizedBox(height: 6),
                    Text(
                      'Manage your workshop efficiently',
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 32),

                    AppTextField(
                      controller: controller.emailController,
                      hint: 'you@autocare.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

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
                        onPressed: () =>
                            context.read<LoginController>().toggleObscurePassword(),
                      ),
                    ),

                    if (controller.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        controller.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.statusError,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: controller.rememberMe,
                              activeThumbColor: AppColors.limeAccent,
                              onChanged: (value) => context
                                  .read<LoginController>()
                                  .toggleRememberMe(value),
                            ),
                            Text('Remember me',
                                style: AppTextStyles.bodySecondary),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Password reset is handled by your workshop admin.'),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: AppColors.limeAccent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    AppButton(
                      label: 'Login',
                      icon: Icons.arrow_forward,
                      isLoading: controller.isLoading,
                      onPressed: () => context.read<LoginController>().login(),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: AppColors.divider)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OR', style: AppTextStyles.caption),
                        ),
                        const Expanded(
                            child: Divider(color: AppColors.divider)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '© 2026 AutoCare Pro',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Privacy Policy  ·  Terms  ·  System Status',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Top hero image with dark gradient fade, matching the Stitch design.
///
/// STEP 1 — put your garage photo at: assets/images/garage_hero.jpg
/// STEP 2 — register it in pubspec.yaml under flutter/assets (see notes
///          at the bottom of this file for the exact lines to add)
/// STEP 3 — this widget will then display it automatically.
///
/// Until you add the asset, a network placeholder image is shown so
/// the screen still looks correct — this is only for preview and
/// should be replaced with your real photo before shipping.
class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/garage_hero.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Falls back to a network placeholder until the real
              // asset is added — remove this fallback once you've
              // wired up your own image.
              return Image.network(
                'https://images.unsplash.com/photo-1632823469850-2f77dd9c7d93?w=800&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.surface),
              );
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withOpacity(0.6),
                  AppColors.background,
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Text(
              'AUTOCARE PRO',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading1.copyWith(
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}