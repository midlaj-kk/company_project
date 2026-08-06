import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/cashier_service.dart';

/// Holds state for the Complete Delivery screen.
class CompleteDeliveryController extends ChangeNotifier {
  CompleteDeliveryController({
    required this.jobId,
    required this.jobNumber,
    required this.vehicleLabel,
    required this.customerName,
  });

  final int jobId;
  final String jobNumber;
  final String vehicleLabel;
  final String customerName;

  final CashierService _cashierService = CashierService();

  DateTime deliveryDateTime = DateTime.now();
  bool customerReceived = true;
  final TextEditingController remarksController = TextEditingController();

  bool isSubmitting = false;
  String? errorMessage;
  bool completedSuccessfully = false;

  void setDateTime(DateTime newDateTime) {
    deliveryDateTime = newDateTime;
    notifyListeners();
  }

  void toggleCustomerReceived(bool value) {
    customerReceived = value;
    notifyListeners();
  }

  Future<void> submit() async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _cashierService.completeDelivery(
        serviceJobId: jobId,
        deliveryDate: deliveryDateTime.toIso8601String(),
        customerReceived: customerReceived,
        remarks: remarksController.text.trim(),
      );
      completedSuccessfully = true;
    } on DioException catch (e) {
      errorMessage = e.response?.data is Map
          ? (e.response?.data['detail'] ?? 'Could not complete delivery.')
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
    remarksController.dispose();
    super.dispose();
  }
}