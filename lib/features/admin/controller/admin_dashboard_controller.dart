import 'package:auto_care_app/features/admin/service/admin_service.dart';
import 'package:flutter/material.dart';

/// Holds all state for the Admin Dashboard screen: loading, error,
/// and the fetched summary/jobs data. Follows the same
/// ChangeNotifier + Provider pattern as LoginController.
class AdminDashboardController extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  bool isLoading = true;
  String? errorMessage;

  int activeJobs = 0;
  int pendingQc = 0;
  int lowStockItems = 0;
  List<dynamic> recentJobs = [];

  Future<void> loadDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final summary = await _adminService.getDashboardSummary();
      final jobs = await _adminService.getRecentJobs(limit: 3);

      activeJobs = summary['active_jobs'] ?? 0;
      pendingQc = summary['pending_qc'] ?? 0;
      lowStockItems = summary['low_stock_items'] ?? 0;
      recentJobs = jobs;
    } catch (_) {
      errorMessage = 'Could not load dashboard. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}