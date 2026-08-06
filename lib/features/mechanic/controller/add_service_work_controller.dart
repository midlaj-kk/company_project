import 'package:flutter/material.dart';
import '../service/mechanic_service.dart';

/// Holds state for the "Add Service Work" bottom sheet.
class AddServiceWorkController extends ChangeNotifier {
  AddServiceWorkController({required this.jobId});

  final int jobId;
  final MechanicService _mechanicService = MechanicService();

  final TextEditingController workNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController labourChargeController = TextEditingController();

  bool isSubmitting = false;
  String? errorMessage;
  bool addedSuccessfully = false;

  Future<void> submit() async {
    if (workNameController.text.trim().isEmpty) {
      errorMessage = 'Please enter a work name';
      notifyListeners();
      return;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _mechanicService.addServiceWork(
        jobId: jobId,
        workName: workNameController.text.trim(),
        description: descriptionController.text.trim(),
        labourCharge:
            double.tryParse(labourChargeController.text.trim()) ?? 0,
      );
      addedSuccessfully = true;
    } catch (_) {
      errorMessage = 'Could not add work item. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    workNameController.dispose();
    descriptionController.dispose();
    labourChargeController.dispose();
    super.dispose();
  }
}