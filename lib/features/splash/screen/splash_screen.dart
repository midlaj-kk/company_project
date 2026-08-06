import 'dart:async';
import 'package:auto_care_app/core/router/app_router.dart';
import 'package:auto_care_app/core/theme/app_colors.dart';
import 'package:auto_care_app/core/theme/app_text_styles.dart';
import 'package:auto_care_app/features/splash/widgets/glowing_logo.dart';
import 'package:auto_care_app/features/splash/widgets/loading_dots.dart';
import 'package:flutter/material.dart';


/// First screen shown when the app opens.
/// Shows branding briefly, then routes to the login screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Short branding pause only — no artificial 2s stall, and this
    // demo always starts at the login screen.
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    AppRouter.toLogin(context, replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle background dot-grid pattern, matches the Stitch canvas look
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GlowingLogo(),
                const SizedBox(height: 28),
                Text('AutoCare Pro', style: AppTextStyles.heading1),
                const SizedBox(height: 8),
                Text(
                  'Workshop Management, Simplified',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),

          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(child: LoadingDots()),
          ),
        ],
      ),
    );
  }
}

/// Faint dot-grid background painter (purely decorative).
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.03);
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}