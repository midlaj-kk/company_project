import 'package:flutter/material.dart';
import '../service/cashier_service.dart';

/// Holds state for the Delivery Ready List screen.
class DeliveryReadyController extends ChangeNotifier {
  final CashierService _cashierService = CashierService();

  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  List<dynamic> vehicles = [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      vehicles = await _cashierService.getDeliveryReady();
    } catch (_) {
      errorMessage = 'Could not load delivery list. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<dynamic> get filteredVehicles {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return vehicles;
    return vehicles.where((v) {
      final vehicleNumber = (v['vehicle_number'] ?? '').toString().toLowerCase();
      final customerName = (v['customer_name'] ?? '').toString().toLowerCase();
      return vehicleNumber.contains(query) || customerName.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}