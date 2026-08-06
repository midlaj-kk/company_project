import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/advisor_service.dart';

/// Holds state for the Create Service Job form.
/// Pass the vehicle id and display info in when navigating here
/// (e.g. from Vehicle Detail's "New Service Job" button).
class CreateServiceJobController extends ChangeNotifier {
  CreateServiceJobController({
    required this.vehicleId,
    required this.vehicleLabel,
    required this.customerName,
  });

  final int vehicleId;
  final String vehicleLabel; // e.g. "KA-01-MJ-1234"
  final String customerName;

  final AdvisorService _advisorService = AdvisorService();

  final TextEditingController complaintController = TextEditingController();
  final TextEditingController serviceTypeController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();

  bool isLoadingMechanics = true;
  List<dynamic> mechanics = [];
  int? selectedMechanicId;

  bool isSubmitting = false;
  String? errorMessage;
  bool createdSuccessfully = false;
  Map<String, dynamic>? createdJob;

  Future<void> loadMechanics() async {
    isLoadingMechanics = true;
    notifyListeners();
    try {
      mechanics = await _advisorService.getMechanics();
    } catch (_) {
      // Non-fatal — mechanic assignment can happen later.
      mechanics = [];
    } finally {
      isLoadingMechanics = false;
      notifyListeners();
    }
  }

  void selectMechanic(int? mechanicId) {
    selectedMechanicId = mechanicId;
    notifyListeners();
  }

  Future<void> submit() async {
    if (complaintController.text.trim().isEmpty ||
        serviceTypeController.text.trim().isEmpty) {
      errorMessage = 'Please describe the complaint and service type';
      notifyListeners();
      return;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final job = await _advisorService.createServiceJob(
        vehicleId: vehicleId,
        complaint: complaintController.text.trim(),
        serviceType: serviceTypeController.text.trim(),
        odometerReading: int.tryParse(odometerController.text.trim()),
        assignedMechanicId: selectedMechanicId,
      );
      createdJob = job;
      createdSuccessfully = true;
    } on DioException catch (e) {
      errorMessage = e.response?.data is Map
          ? (e.response?.data.values.first is List
                  ? e.response?.data.values.first[0]
                  : 'Could not create job.')
              .toString()
          : 'Could not reach the server. Check your connection.';
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void resetForNewJob() {
    complaintController.clear();
    serviceTypeController.clear();
    odometerController.clear();
    selectedMechanicId = null;
    createdSuccessfully = false;
    createdJob = null;
    notifyListeners();
  }

  @override
  void dispose() {
    complaintController.dispose();
    serviceTypeController.dispose();
    odometerController.dispose();
    super.dispose();
  }
}