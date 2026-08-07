import 'package:auto_care_app/core/demo/demo_repository.dart';

/// All data used by the Admin role lives here. The app runs in
/// demo mode and reads from the in-memory [DemoRepository].
class AdminService {
  Future<Map<String, dynamic>> getDashboardSummary() {
    return DemoRepository.instance.getDashboardSummary();
  }

  Future<List<dynamic>> getRecentJobs({int limit = 3}) {
    return DemoRepository.instance.getRecentJobs(limit: limit);
  }

  Future<List<dynamic>> getQcPendingJobs() {
    return DemoRepository.instance.getJobs(status: 'qc_pending');
  }

  Future<List<dynamic>> getStaff({String? search, String? role}) {
    return DemoRepository.instance.getStaff(search: search, role: role);
  }

  Future<Map<String, dynamic>> createStaff({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String password,
    String? specialization,
  }) {
    return DemoRepository.instance.createStaff(
      name: name,
      email: email,
      phone: phone,
      role: role,
      password: password,
      specialization: specialization,
    );
  }

  Future<List<dynamic>> getSpareParts({
    String? search,
    bool lowStockOnly = false,
  }) {
    return DemoRepository.instance.getSpareParts(
      search: search,
      lowStockOnly: lowStockOnly,
    );
  }

  Future<void> addStock(int partId, double quantity) {
    return DemoRepository.instance.addStock(partId, quantity);
  }

  Future<void> reduceStock(int partId, double quantity, {String? reason}) {
    return DemoRepository.instance.reduceStock(partId, quantity,
        reason: reason);
  }

  Future<Map<String, dynamic>> getSparePartDetail(int partId) {
    return DemoRepository.instance.getSparePartDetail(partId);
  }

  Future<List<dynamic>> getStockHistory(int partId) {
    return DemoRepository.instance.getStockHistory(partId);
  }

  Future<Map<String, dynamic>> getServiceJobDetail(int jobId) {
    return DemoRepository.instance.getServiceJobDetail(jobId);
  }

  Future<void> submitQualityCheck({
    required int serviceJobId,
    required Map<String, String> checklist,
    required String overallStatus,
    String? remarks,
  }) {
    return DemoRepository.instance.submitQualityCheck(
      serviceJobId: serviceJobId,
      checklist: checklist,
      overallStatus: overallStatus,
      remarks: remarks,
    );
  }

  Future<Map<String, dynamic>> getMonthlyRevenue(int month, int year) {
    return DemoRepository.instance.getMonthlyRevenue(month, year);
  }

  Future<Map<String, dynamic>> getCompletedServices(String from, String to) {
    return DemoRepository.instance.getCompletedServices(from, to);
  }

  Future<Map<String, dynamic>> getMechanicProductivity(String from, String to) {
    return DemoRepository.instance.getMechanicProductivity(from, to);
  }

  Future<Map<String, dynamic>> getSparePartsUsage(String from, String to) {
    return DemoRepository.instance.getSparePartsUsage(from, to);
  }

  Future<List<dynamic>> getPendingPaymentsReport() {
    return DemoRepository.instance.getPendingPaymentsReport();
  }
}
