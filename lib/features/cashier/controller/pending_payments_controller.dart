import 'package:flutter/material.dart';
import '../service/cashier_service.dart';

/// Holds state for the Pending Payments screen: the selected
/// status filter and the fetched list of unpaid/partial bills.
class PendingPaymentsController extends ChangeNotifier {
  final CashierService _cashierService = CashierService();

  bool isLoading = true;
  String? errorMessage;
  String selectedFilter = 'all'; // all | pending | partial

  List<dynamic> allBills = [];
  List<dynamic> get filteredBills => selectedFilter == 'all'
      ? allBills
      : allBills.where((b) => b['payment_status'] == selectedFilter).toList();

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      allBills = await _cashierService.getPendingPayments();
    } catch (_) {
      errorMessage = 'Could not load pending payments. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}