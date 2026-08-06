import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/advisor_service.dart';

/// Holds state for the 2-step Add Customer + Vehicle flow.
/// Step 1 creates the customer; step 2 creates a vehicle linked
/// to that customer.
class AddCustomerController extends ChangeNotifier {
  final AdvisorService _advisorService = AdvisorService();

  int currentStep = 1; // 1 = Customer, 2 = Vehicle

  // --- Step 1: Customer fields ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // --- Step 2: Vehicle fields ---
  final TextEditingController vehicleNumberController =
      TextEditingController();
  String? selectedBrand;
  final TextEditingController modelController = TextEditingController();
  int year = DateTime.now().year;
  final TextEditingController kilometersController = TextEditingController();

  void setBrand(String? brand) {
    selectedBrand = brand;
    notifyListeners();
  }

  void setYear(int newYear) {
    year = newYear;
    notifyListeners();
  }

  bool isLoading = false;
  String? errorMessage;
  bool completedSuccessfully = false;

  int? _createdCustomerId;

  Future<void> submitCustomerStep() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      errorMessage = 'Please enter at least name and phone number';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final customer = await _advisorService.createCustomer(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
      );
      _createdCustomerId = customer['id'] as int;
      currentStep = 2;
    } on DioException catch (e) {
      errorMessage = e.response?.data is Map
          ? (e.response?.data.values.first is List
                  ? e.response?.data.values.first[0]
                  : 'Could not save customer.')
              .toString()
          : 'Could not reach the server. Check your connection.';
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void skipVehicleStep() {
    completedSuccessfully = true;
    notifyListeners();
  }

  Future<void> submitVehicleStep() async {
    if (_createdCustomerId == null) {
      errorMessage = 'Customer was not saved correctly. Please start over.';
      notifyListeners();
      return;
    }
    if (vehicleNumberController.text.trim().isEmpty ||
        selectedBrand == null ||
        modelController.text.trim().isEmpty) {
      errorMessage = 'Please fill in vehicle number, brand, and model';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _advisorService.createVehicle(
        customerId: _createdCustomerId!,
        vehicleNumber: vehicleNumberController.text.trim().toUpperCase(),
        brand: selectedBrand!,
        model: modelController.text.trim(),
        year: year,
        kilometers: int.tryParse(kilometersController.text.trim()),
      );
      completedSuccessfully = true;
    } on DioException catch (e) {
      errorMessage = e.response?.data is Map
          ? (e.response?.data.values.first is List
                  ? e.response?.data.values.first[0]
                  : 'Could not save vehicle.')
              .toString()
          : 'Could not reach the server. Check your connection.';
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void goBackToStep1() {
    currentStep = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    vehicleNumberController.dispose();
    modelController.dispose();
    kilometersController.dispose();
    super.dispose();
  }
}