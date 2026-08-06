import 'package:flutter/material.dart';
import '../service/advisor_service.dart';

/// Holds state for the Job Detail (Advisor view) screen.
/// Pass the job's id in when navigating to this screen.
class JobDetailAdvisorController extends ChangeNotifier {
  JobDetailAdvisorController({required this.jobId});

  final int jobId;
  final AdvisorService _advisorService = AdvisorService();

  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? job;

  List<dynamic> mechanics = [];

  String selectedTab = 'complaint'; // complaint | work_done | parts_used

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      job = await _advisorService.getJobDetail(jobId);
      mechanics = await _advisorService.getMechanics();
    } catch (_) {
      errorMessage = 'Could not load job details. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setTab(String tab) {
    selectedTab = tab;
    notifyListeners();
  }

  Future<void> changeMechanic(int mechanicId) async {
    try {
      await _advisorService.changeMechanic(jobId, mechanicId);
      await load();
    } catch (_) {
      errorMessage = 'Could not change mechanic. Try again.';
      notifyListeners();
    }
  }

  Future<void> updateStatus(String newStatus) async {
    try {
      await _advisorService.updateJobStatus(jobId, newStatus);
      await load();
    } catch (_) {
      errorMessage = 'Could not update status. Try again.';
      notifyListeners();
    }
  }
}