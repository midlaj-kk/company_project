import 'dart:async';
import 'package:flutter/material.dart';
import '../service/mechanic_service.dart';

/// Holds state for the "Add Part Used" bottom sheet: search results,
/// the selected part, quantity, and stock validation.
class AddPartUsedController extends ChangeNotifier {
  AddPartUsedController({required this.jobId});

  final int jobId;
  final MechanicService _mechanicService = MechanicService();

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  bool isSearching = false;
  List<dynamic> searchResults = [];

  Map<String, dynamic>? selectedPart;
  int quantity = 1;

  bool isSubmitting = false;
  String? errorMessage;
  bool addedSuccessfully = false;

  double get availableStock =>
      (selectedPart?['stock_quantity'] as num?)?.toDouble() ?? 0;

  bool get exceedsStock => selectedPart != null && quantity > availableStock;

  double get totalPrice =>
      ((selectedPart?['selling_price'] as num?)?.toDouble() ?? 0) * quantity;

  /// Debounced so the service is not queried on every keystroke.
  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _runSearch(query));
  }

  Future<void> _runSearch(String query) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }
    isSearching = true;
    notifyListeners();
    try {
      searchResults = await _mechanicService.searchSpareParts(query.trim());
    } catch (_) {
      searchResults = [];
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  void selectPart(Map<String, dynamic> part) {
    selectedPart = part;
    searchResults = [];
    searchController.text = part['name'] ?? '';
    quantity = 1;
    notifyListeners();
  }

  void incrementQuantity() {
    quantity += 1;
    notifyListeners();
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity -= 1;
      notifyListeners();
    }
  }

  Future<void> submit() async {
    if (selectedPart == null) {
      errorMessage = 'Please select a part first';
      notifyListeners();
      return;
    }
    if (exceedsStock) {
      errorMessage = 'Not enough stock available';
      notifyListeners();
      return;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _mechanicService.addPartUsed(
        jobId: jobId,
        partId: selectedPart!['id'] as int,
        quantity: quantity.toDouble(),
      );
      addedSuccessfully = true;
    } catch (_) {
      errorMessage = 'Could not add part. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}