import 'package:flutter/material.dart';
import '../service/mechanic_service.dart';

/// Holds state for the Mechanic Home screen: the selected status
/// filter, stat counts, and the fetched job list.
class MechanicHomeController extends ChangeNotifier {
  final MechanicService _mechanicService = MechanicService();

  bool isLoading = true;
  String? errorMessage;
  String selectedFilter = 'all'; // all | waiting | in_progress | rework

  int assignedCount = 0;
  int completedTodayCount = 0;
  List<dynamic> jobs = [];

  Future<void> loadJobs() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Backend already scopes /service-jobs/ to this mechanic only.
      final allJobs = await _mechanicService.getMyJobs();
      assignedCount = allJobs
          .where((j) => j['status'] != 'delivered' && j['status'] != 'cancelled')
          .length;

      final today = DateTime.now();
      completedTodayCount = allJobs.where((j) {
        if (j['status'] != 'qc_pending' && j['status'] != 'ready_for_bill') {
          return false;
        }
        final updated = DateTime.tryParse(j['updated_at'] ?? '');
        return updated != null &&
            updated.year == today.year &&
            updated.month == today.month &&
            updated.day == today.day;
      }).length;

      jobs = selectedFilter == 'all'
          ? allJobs
          : selectedFilter == 'rework'
              ? allJobs.where((j) => j['status'] == 'rework_required').toList()
              : allJobs.where((j) => j['status'] == selectedFilter).toList();
    } catch (_) {
      errorMessage = 'Could not load your jobs. Pull down to retry.';
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