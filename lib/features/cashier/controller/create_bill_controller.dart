import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/cashier_service.dart';

/// Holds state for the Create Bill screen.
/// Pass the job's id and display info in when navigating here.
class CreateBillController extends ChangeNotifier {
  CreateBillController({
    required this.jobId,
    required this.jobNumber,
    required this.vehicleLabel,
    required this.vehicleModel,
    required this.customerName,
    double initialLabourCharge = 0,
    double initialPartsCharge = 0,
  }) {
    labourController =
        TextEditingController(text: initialLabourCharge.toStringAsFixed(0));
    partsController =
        TextEditingController(text: initialPartsCharge.toStringAsFixed(0));
    taxController = TextEditingController(
        text: (initialLabourCharge * 0.18).toStringAsFixed(0));
    discountController = TextEditingController(text: '0');

    labourController.addListener(notifyListeners);
    partsController.addListener(notifyListeners);
    taxController.addListener(notifyListeners);
    discountController.addListener(notifyListeners);
  }

  final int jobId;
  final String jobNumber;
  final String vehicleLabel;
  final String vehicleModel;
  final String customerName;

  final CashierService _cashierService = CashierService();

  late final TextEditingController labourController;
  late final TextEditingController partsController;
  late final TextEditingController taxController;
  late final TextEditingController discountController;

  bool isSubmitting = false;
  String? errorMessage;
  bool createdSuccessfully = false;
  Map<String, dynamic>? createdBill;

  double get labourCharge => double.tryParse(labourController.text) ?? 0;
  double get partsCharge => double.tryParse(partsController.text) ?? 0;
  double get tax => double.tryParse(taxController.text) ?? 0;
  double get discount => double.tryParse(discountController.text) ?? 0;

  double get totalAmount => labourCharge + partsCharge + tax - discount;

  Future<void> submit() async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final bill = await _cashierService.createBill(
        serviceJobId: jobId,
        labourCharge: labourCharge,
        partsCharge: partsCharge,
        tax: tax,
        discount: discount,
      );
      createdBill = bill;
      createdSuccessfully = true;
    } on DioException catch (e) {
      errorMessage = e.response?.data is Map
          ? (e.response?.data['detail'] ?? 'Could not create bill.').toString()
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
    labourController.dispose();
    partsController.dispose();
    taxController.dispose();
    discountController.dispose();
    super.dispose();
  }
}