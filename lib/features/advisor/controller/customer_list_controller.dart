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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}