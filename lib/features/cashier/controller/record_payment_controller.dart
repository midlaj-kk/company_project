import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/cashier_service.dart';

/// Holds state for the Record Payment screen.
/// Pass the bill's id in when navigating to this screen.
class RecordPaymentController extends ChangeNotifier {
  RecordPaymentController({required this.billId});

  final int billId;
  final CashierService _cashierService = CashierService();

  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? bill;

  final TextEditingController amountController = TextEditingController();
  String selectedMethod = 'cash';
  DateTime paymentDate = DateTime.now();

  bool isSubmitting = false;
  bool paidSuccessfully = false;
  bool fullyPaid = false;

  double get totalAmount => (bill?['total_amount'] as num?)?.toDouble() ?? 0;
  double get amountPaid => (bill?['amount_paid'] as num?)?.toDouble() ?? 0;
  double get remaining => totalAmount - amountPaid;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      bill = await _cashierService.getBillDetail(billId);
    } catch (_) {
      errorMessage = 'Could not load bill. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectMethod(String method) {
    selectedMethod = method;
    notifyListeners();
  }

  void payFullAmount() {
    amountController.text = remaining.toStringAsFixed(0);
    notifyListeners();
  }

  Future<void> confirmPayment() async {
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      errorMessage = 'Please enter a valid amount';
      notifyListeners();
      return;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _cashierService.recordPayment(
        billId: billId,
        paymentMethod: selectedMethod,
        paidAmount: amount,
        paymentDate:
            '${paymentDate.year}-${paymentDate.month.toString().padLeft(2, '0')}-${paymentDate.day.toString().padLeft(2, '0')}',
      );
      fullyPaid = amount >= remaining;
      paidSuccessfully = true;
    } on DioException catch (e) {
      errorMessage = e.response?.data is Map
          ? (e.response?.data['detail'] ?? 'Could not record payment.')
              .toString()
          : 'Could not reach the server. Check your connection.';
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}