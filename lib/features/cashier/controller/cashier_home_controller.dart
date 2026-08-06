import 'package:flutter/material.dart';
import '../service/cashier_service.dart';

/// Holds state for the Cashier Home screen.
class CashierHomeController extends ChangeNotifier {
  final CashierService _cashierService = CashierService();

  bool isLoading = true;
  String? errorMessage;

  List<dynamic> readyForBilling = [];
  List<dynamic> pendingPayments = [];
  double revenueToday = 0;

  Future<void> loadHome() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      readyForBilling = await _cashierService.getJobsReadyForBilling();
      pendingPayments = await _cashierService.getPendingPayments();
      final summary = await _cashierService.getDashboardSummary();
      revenueToday = (summary['revenue_today'] as num?)?.toDouble() ?? 0;
    } catch (_) {
      errorMessage = 'Could not load data. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}