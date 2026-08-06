import 'package:flutter/material.dart';
import '../service/advisor_service.dart';

/// Holds state for the Advisor Home screen: the selected status
/// filter tab, stat counts, and the fetched job list.
class AdvisorHomeController extends ChangeNotifier {
  final AdvisorService _advisorService = AdvisorService();

  bool isLoading = true;
  String? errorMessage;
  String selectedFilter = 'all'; // all | waiting | in_progress | qc_pending

  int waitingCount = 0;
  int inProgressCount = 0;
  int qcPendingCount = 0;
  List<dynamic> jobs = [];

  Future<void> loadJobs() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Fetch all jobs once to compute the stat counts, then apply
      // the selected tab filter for the displayed list.
      final allJobs = await _advisorService.getJobs();
      waitingCount = allJobs.where((j) => j['status'] == 'waiting').length;
      inProgressCount =
          allJobs.where((j) => j['status'] == 'in_progress').length;
      qcPendingCount =
          allJobs.where((j) => j['status'] == 'qc_pending').length;

      jobs = selectedFilter == 'all'
          ? allJobs
          : allJobs.where((j) => j['status'] == selectedFilter).toList();
    } catch (_) {
      errorMessage = 'Could not load jobs. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    loadJobs();
  }
}