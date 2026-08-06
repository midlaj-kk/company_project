import 'package:auto_care_app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import '../service/advisor_service.dart';

/// Holds state for the Customer List screen: search text and the
/// fetched customer list.
class CustomerListController extends ChangeNotifier {
  final AdvisorService _advisorService = AdvisorService();

  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  List<dynamic> customers = [];
  int totalCount = 0;

  Future<void> loadCustomers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      customers = await _advisorService.getCustomers(
        search: searchController.text.trim(),
      );
      totalCount = customers.length;
    } catch (_) {
      errorMessage = 'Could not load customers. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onSearchSubmitted(String _) => loadCustomers();

  /// Opens the first vehicle of a customer. The raw backend only
  /// returns vehicle counts, so resolve the id before navigating
  /// (previously this hardcoded vehicleId: 1, opening the wrong car).
  Future<void> openCustomer(
    BuildContext context,
    Map<String, dynamic> customer,
  ) async {
    try {
      final vehicles = await _advisorService
          .getCustomerVehicles(customer['id'] as int);
      if (vehicles.isEmpty || !context.mounted) return;
      AppRouter.toVehicleDetail(context, vehicleId: vehicles.first['id'] as int);
    } catch (_) {
      // Ignore — tapping again will retry.
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}