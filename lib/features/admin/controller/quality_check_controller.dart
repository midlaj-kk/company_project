import 'package:auto_care_app/features/admin/service/admin_service.dart';
import 'package:flutter/material.dart';

/// Holds state for the Quality Check form: the job being checked,
/// the current checklist selections, and submit logic.
class QualityCheckController extends ChangeNotifier {
  QualityCheckController({required this.serviceJobId});

  final int serviceJobId;
  final AdminService _adminService = AdminService();

  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;
  bool submittedSuccessfully = false;

  Map<String, dynamic>? job;

  // Checklist state — keys match the backend field names.
  final Map<String, String?> checklist = {
    'brake_check': null,
    'engine_check': null,
    'oil_leakage_check': null,
    'ac_check': null,
    'tyre_check': null,
    'test_drive': null,
  };

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      job = await _adminService.getServiceJobDetail(serviceJobId);
    } catch (_) {
      errorMessage = 'Could not load job details. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setChecklistValue(String key, String value) {
    checklist[key] = value;
    notifyListeners();
  }

  bool get isChecklistComplete =>
      checklist.values.every((v) => v != null);

  Future<void> submit(String overallStatus) async {
    if (!isChecklistComplete) {
      errorMessage = 'Please complete every checklist item first';
      notifyListeners();
      return;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _adminService.submitQualityCheck(
        serviceJobId: serviceJobId,
        checklist: checklist.map((k, v) => MapEntry(k, v!)),
        overallStatus: overallStatus,
      );
      submittedSuccessfully = true;
    } catch (_) {
      errorMessage = 'Could not submit quality check. Try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}