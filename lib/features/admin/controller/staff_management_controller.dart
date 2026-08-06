import 'package:auto_care_app/features/admin/service/admin_service.dart';
import 'package:flutter/material.dart';

/// Holds state for the Staff Management screen: the current search
/// text, selected role filter, and the fetched staff list.
class StaffManagementController extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  String selectedRole = 'all';
  List<dynamic> staffList = [];

  Future<void> loadStaff() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      staffList = await _adminService.getStaff(
        search: searchController.text.trim(),
        role: selectedRole,
      );
    } catch (_) {
      errorMessage = 'Could not load staff list. Pull down to retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onRoleSelected(String role) {
    selectedRole = role;
    loadStaff();
  }

  void onSearchChanged(String _) {
    // Simple debounce-free reload; for production, wrap this in a
    // Timer-based debounce so it doesn't call the API on every keystroke.
    loadStaff();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}