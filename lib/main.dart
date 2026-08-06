import 'package:auto_care_app/features/admin/screen/add_mechanic_screen.dart';
import 'package:auto_care_app/features/admin/screen/admin_dashboard_screen.dart';
import 'package:auto_care_app/features/admin/screen/inventory_list_screen.dart';
import 'package:auto_care_app/features/admin/screen/quality_check_screen.dart';
import 'package:auto_care_app/features/admin/screen/reports_screen.dart';
import 'package:auto_care_app/features/admin/screen/staff_management_screen.dart';
import 'package:auto_care_app/features/admin/screen/stock_history_screen.dart';
import 'package:auto_care_app/features/advisor/screen/add_customer_screen.dart';
import 'package:auto_care_app/features/advisor/screen/advisor_home_screen.dart';
import 'package:auto_care_app/features/advisor/screen/job_creation_confirmation_screen.dart';
import 'package:auto_care_app/features/advisor/screen/job_detail_advisor_screen.dart';
import 'package:auto_care_app/features/advisor/screen/vehicle_detail_screen.dart';
import 'package:auto_care_app/features/auth/screen/login_screen.dart';
import 'package:auto_care_app/features/cashier/screen/cashier_home_screen.dart';
import 'package:auto_care_app/features/cashier/screen/record_payment_screen.dart';
import 'package:auto_care_app/features/mechanic/screen/add_part_used_sheet.dart';
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