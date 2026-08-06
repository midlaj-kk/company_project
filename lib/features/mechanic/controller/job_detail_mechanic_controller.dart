import 'package:flutter/material.dart';
import '../service/mechanic_service.dart';

/// Holds state for the Job Detail (Mechanic view) screen.
/// Pass the job's id in when navigating to this screen.
class JobDetailMechanicController extends ChangeNotifier {
  JobDetailMechanicController({required this.jobId});

  final int jobId;
  final MechanicService _mechanicService = MechanicService();

  bool isLoading = true;
  String? errorMessage;

  Map<String, dynamic>? job;
  List<dynamic> workItems = [];
  List<dynamic> partsUsed = [];

  double get totalLabour => workItems.fold(
      0, (sum, w) => sum + ((w['labour_charge'] as num?)?.toDouble() ?? 0));

  double get totalParts => partsUsed.fold(
      0,
      (sum, p) =>
          sum +
          (((p['price'] as num?)?.toDouble() ?? 0) *
              ((p['quantity'] as num?)?.toDouble() ?? 0)));

  bool get allWorkCompleted =>
      workItems.isNotEmpty &&
      workItems.every((w) => w['status'] == 'completed');

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      job = await _mechanicService.getJobDetail(jobId);
      workItems = await _mechanicService.getServiceWork(jobId);
      partsUsed = await _mechanicService.getPartsUsed(jobId);
    } catch (_) {
      errorMessage = 'Could not load job details. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleWorkStatus(int workId, String currentStatus) async {
    final next = currentStatus == 'pending'
        ? 'in_progress'
        : currentStatus == 'in_progress'
            ? 'completed'
            : 'pending';
    try {
      await _mechanicService.updateWorkStatus(workId, next);
      await load();
    } catch (_) {
      errorMessage = 'Could not update work status.';
      notifyListeners();
    }
  }

  Future<void> deletePart(int partUsedId) async {
    try {
      await _mechanicService.deletePartUsed(partUsedId);
      await load();
    } catch (_) {
      errorMessage = 'Could not remove part.';
      notifyListeners();
    }
  }

  bool isSubmittingQc = false;

  Future<void> sendForQualityCheck() async {
    if (!allWorkCompleted) return;
    isSubmittingQc = true;
    notifyListeners();
    try {
      await _mechanicService.updateJobStatus(jobId, 'qc_pending');
      await load();
    } catch (_) {
      errorMessage = 'Could not send for quality check.';
    } finally {
      isSubmittingQc = false;
      notifyListeners();
    }
  }
}