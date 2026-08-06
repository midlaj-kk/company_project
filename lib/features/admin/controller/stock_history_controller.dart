import 'package:auto_care_app/features/admin/service/admin_service.dart';
import 'package:flutter/material.dart';

/// Holds state for the Stock History screen for a single spare part.
/// Pass the part's id in when navigating to this screen.
class StockHistoryController extends ChangeNotifier {
  StockHistoryController({required this.partId});

  final int partId;
  final AdminService _adminService = AdminService();

  bool isLoading = true;
  String? errorMessage;

  Map<String, dynamic>? partDetail;
  List<dynamic> movements = [];

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final detail = await _adminService.getSparePartDetail(partId);
      final history = await _adminService.getStockHistory(partId);
      partDetail = detail;
      movements = history;
    } catch (_) {
      errorMessage = 'Could not load stock history. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}