import 'package:flutter/material.dart';
import '../service/advisor_service.dart';

/// Holds state for the Vehicle Detail + Service History screen.
/// Pass the vehicle's id in when navigating to this screen.
class VehicleDetailController extends ChangeNotifier {
  VehicleDetailController({required this.vehicleId});

  final int vehicleId;
  final AdvisorService _advisorService = AdvisorService();

  bool isLoading = true;
  String? errorMessage;

  Map<String, dynamic>? vehicle;
  List<dynamic> history = [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      vehicle = await _advisorService.getVehicleDetail(vehicleId);
      history = await _advisorService.getVehicleHistory(vehicleId);
    } catch (_) {
      errorMessage = 'Could not load vehicle details. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}