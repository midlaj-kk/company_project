import 'package:auto_care_app/features/auth/screen/login_screen.dart';
import 'package:auto_care_app/features/splash/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const AutoCareApp());
}

class AutoCareApp extends StatelessWidget {
  const AutoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoCare Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}