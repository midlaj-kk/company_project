import 'package:auto_care_app/features/admin/service/admin_service.dart';
import 'package:flutter/material.dart';

/// Holds state for the Inventory screen: search text, selected tab
/// (All Parts / Low Stock), and the fetched parts list.
class InventoryController extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  bool showLowStockOnly = false;

  List<dynamic> parts = [];
  int totalParts = 0;
  int lowStockCount = 0;

  Future<void> loadParts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Always fetch the full list to compute the header stats,
      // then apply the tab filter for what's actually displayed.
      final allParts = await _adminService.getSpareParts(
        search: searchController.text.trim(),
      );
      totalParts = allParts.length;
      lowStockCount = allParts
          .where((p) => (p['stock_quantity'] as num) <=
              (p['minimum_stock'] as num))
          .length;

      parts = showLowStockOnly
          ? allParts
              .where((p) => (p['stock_quantity'] as num) <=
                  (p['minimum_stock'] as num))
              .toList()
          : allParts;
    } catch (_) {
      errorMessage = 'Could not load inventory. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setTab(bool lowStockOnly) {
    showLowStockOnly = lowStockOnly;
    loadParts();
  }

  void onSearchSubmitted(String _) => loadParts();

  Future<void> addStock(int partId) async {
    try {
      await _adminService.addStock(partId, 1);
      await loadParts();
    } catch (_) {
      errorMessage = 'Could not update stock. Try again.';
      notifyListeners();
    }
  }

  Future<void> reduceStock(int partId) async {
    try {
      await _adminService.reduceStock(partId, 1, reason: 'Manual adjustment');
      await loadParts();
    } catch (_) {
      errorMessage = 'Could not update stock. Try again.';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}