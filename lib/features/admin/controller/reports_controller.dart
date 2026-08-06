import 'package:auto_care_app/features/admin/service/admin_service.dart';
import 'package:flutter/material.dart';

/// Holds state for the Reports dashboard: fetches all report
/// summaries for the current month and exposes them for display.
class ReportsController extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  bool isLoading = true;
  String? errorMessage;

  double revenueThisMonth = 0;
  int completedServices = 0;
  String topMechanicName = '';
  int topMechanicJobs = 0;
  String mostUsedPartName = '';
  double pendingPaymentsTotal = 0;
  int lowStockCount = 0;

  Future<void> loadReports() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final monthStart =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
      final today =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final revenue = await _adminService.getMonthlyRevenue(now.month, now.year);
      revenueThisMonth = (revenue['total_revenue'] as num?)?.toDouble() ?? 0;

      final completed =
          await _adminService.getCompletedServices(monthStart, today);
      completedServices = completed['total_completed'] ?? 0;

      final productivity =
          await _adminService.getMechanicProductivity(monthStart, today);
      final mechanics = productivity['mechanics'] as List<dynamic>? ?? [];
      if (mechanics.isNotEmpty) {
        topMechanicName = mechanics.first['mechanic_name'] ?? '';
        topMechanicJobs = mechanics.first['completed_jobs'] ?? 0;
      }

      final partsUsage =
          await _adminService.getSparePartsUsage(monthStart, today);
      final parts = partsUsage['parts'] as List<dynamic>? ?? [];
      if (parts.isNotEmpty) {
        mostUsedPartName = parts.first['part_name'] ?? '';
      }

      final pending = await _adminService.getPendingPaymentsReport();
      pendingPaymentsTotal = pending.fold<double>(
        0,
        (sum, bill) =>
            sum + ((bill['total_amount'] as num?)?.toDouble() ?? 0),
      );

      final lowStock = await _adminService.getSpareParts(lowStockOnly: true);
      lowStockCount = lowStock.length;
    } catch (_) {
      errorMessage = 'Could not load reports. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}