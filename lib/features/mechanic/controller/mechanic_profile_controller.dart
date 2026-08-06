import 'package:flutter/material.dart';
import '../../../core/storage/shared_prefernce.dart';
import '../service/mechanic_service.dart';

/// Holds state for the Mechanic Profile screen.
class MechanicProfileController extends ChangeNotifier {
  final MechanicService _mechanicService = MechanicService();

  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? profile;

  // TODO: wire these up to real backend stats once a
  // "mechanic productivity" endpoint scoped to self is available.
  int jobsCompletedThisMonth = 15;
  String avgCompletionTime = '3h 20m';

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _mechanicService.getMyProfile();
    } catch (_) {
      errorMessage = 'Could not load profile. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await SecureStorage().clearAll();
  }
}