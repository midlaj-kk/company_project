import 'package:auto_care_app/core/api/api_client.dart';
import 'package:auto_care_app/core/demo/demo_config.dart';
import 'package:auto_care_app/core/demo/demo_repository.dart';


/// All API calls used by the Admin role live here.
/// Screens/controllers call these methods instead of using Dio directly.
class AdminService {
  final _dio = ApiClient().dio;

  /// GET /dashboard/summary/
  /// Returns: total_jobs_today, active_jobs, pending_qc,
  /// ready_for_delivery, revenue_today, low_stock_items
  Future<Map<String, dynamic>> getDashboardSummary() async {
    if (demoMode) {
      return DemoRepository.instance.getDashboardSummary();
    }
    final response = await _dio.get('/dashboard/summary/');
    return response.data as Map<String, dynamic>;
  }

  /// GET /service-jobs/?ordering=-created_at&page_size=3
  /// Returns the most recent jobs for the "Recent Jobs" section.
  Future<List<dynamic>> getRecentJobs({int limit = 3}) async {
    if (demoMode) {
      return DemoRepository.instance.getRecentJobs(limit: limit);
    }
    final response = await _dio.get(
      '/service-jobs/',
      queryParameters: {
        'ordering': '-created_at',
        'page_size': limit,
      },
    );
    return response.data['results'] as List<dynamic>;
  }

  /// GET /service-jobs/?status=qc_pending&ordering=-created_at
  /// Used by the Quality Check quick action to list jobs awaiting QC.
  Future<List<dynamic>> getQcPendingJobs() async {
    if (demoMode) {
      return DemoRepository.instance.getJobs(status: 'qc_pending');
    }
    final response = await _dio.get(
      '/service-jobs/',
      queryParameters: {'status': 'qc_pending', 'ordering': '-created_at'},
    );
    return response.data['results'] as List<dynamic>;
  }

  /// GET /users/?search=&role=
  /// Returns the staff list, optionally filtered by search text
  /// and/or role ("admin", "service_advisor", "mechanic", "cashier").
  Future<List<dynamic>> getStaff({String? search, String? role}) async {
    if (demoMode) {
      return DemoRepository.instance.getStaff(search: search, role: role);
    }
    final response = await _dio.get(
      '/users/',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (role != null && role != 'all') 'role': role,
      },
    );
    return response.data['results'] as List<dynamic>;
  }

  /// POST /users/
  /// Creates a new staff member (admin, service_advisor, mechanic,
  /// or cashier). specialization is only relevant for mechanics.
  Future<Map<String, dynamic>> createStaff({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String password,
    String? specialization,
  }) async {
    if (demoMode) {
      return DemoRepository.instance.createStaff(
        name: name,
        email: email,
        phone: phone,
        role: role,
        password: password,
        specialization: specialization,
      );
    }
    final response = await _dio.post('/users/', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'password': password,
      if (specialization != null && specialization.isNotEmpty)
        'specialization': specialization,
    });
    return response.data as Map<String, dynamic>;
  }

  /// GET /spare-parts/?search=&low_stock=
  Future<List<dynamic>> getSpareParts({
    String? search,
    bool lowStockOnly = false,
  }) async {
    if (demoMode) {
      return DemoRepository.instance.getSpareParts(
        search: search,
        lowStockOnly: lowStockOnly,
      );
    }
    final path = lowStockOnly ? '/spare-parts/low_stock/' : '/spare-parts/';
    final response = await _dio.get(
      path,
      queryParameters: {
        if (!lowStockOnly && search != null && search.isNotEmpty)
          'search': search,
      },
    );
    // low_stock/ returns a plain list; the paginated list endpoint
    // returns {"results": [...]}
    final data = response.data;
    return data is List ? data : data['results'] as List<dynamic>;
  }

  /// POST /spare-parts/{id}/add_stock/
  Future<void> addStock(int partId, double quantity) async {
    if (demoMode) {
      return DemoRepository.instance.addStock(partId, quantity);
    }
    await _dio.post('/spare-parts/$partId/add_stock/', data: {
      'quantity': quantity,
    });
  }

  /// POST /spare-parts/{id}/reduce_stock/
  Future<void> reduceStock(int partId, double quantity, {String? reason}) async {
    if (demoMode) {
      return DemoRepository.instance.reduceStock(partId, quantity,
          reason: reason);
    }
    await _dio.post('/spare-parts/$partId/reduce_stock/', data: {
      'quantity': quantity,
      if (reason != null) 'reason': reason,
    });
  }

  /// GET /spare-parts/{id}/
  Future<Map<String, dynamic>> getSparePartDetail(int partId) async {
    if (demoMode) {
      return DemoRepository.instance.getSparePartDetail(partId);
    }
    final response = await _dio.get('/spare-parts/$partId/');
    return response.data as Map<String, dynamic>;
  }

  /// GET /spare-parts/{id}/stock_history/
  Future<List<dynamic>> getStockHistory(int partId) async {
    if (demoMode) {
      return DemoRepository.instance.getStockHistory(partId);
    }
    final response = await _dio.get('/spare-parts/$partId/stock_history/');
    return response.data['results'] as List<dynamic>;
  }

  /// GET /service-jobs/{id}/
  /// Used by the Quality Check screen to show vehicle/customer/
  /// mechanic summary at the top of the form.
  Future<Map<String, dynamic>> getServiceJobDetail(int jobId) async {
    if (demoMode) {
      return DemoRepository.instance.getServiceJobDetail(jobId);
    }
    final response = await _dio.get('/service-jobs/$jobId/');
    return response.data as Map<String, dynamic>;
  }

  /// POST /quality-checks/
  /// checklist keys: brake_check, engine_check, oil_leakage_check,
  /// ac_check, tyre_check, test_drive (each "passed"/"failed"/"na",
  /// oil_leakage_check uses "no_issue"/"issue_found"/"na").
  /// overallStatus: "approved" | "rework_required"
  Future<void> submitQualityCheck({
    required int serviceJobId,
    required Map<String, String> checklist,
    required String overallStatus,
    String? remarks,
  }) async {
    if (demoMode) {
      return DemoRepository.instance.submitQualityCheck(
        serviceJobId: serviceJobId,
        checklist: checklist,
        overallStatus: overallStatus,
        remarks: remarks,
      );
    }
    await _dio.post('/quality-checks/', data: {
      'service_job': serviceJobId,
      ...checklist,
      'overall_status': overallStatus,
      if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
    });
  }

  /// GET /reports/monthly-revenue/?month=&year=
  Future<Map<String, dynamic>> getMonthlyRevenue(int month, int year) async {
    if (demoMode) {
      return DemoRepository.instance.getMonthlyRevenue(month, year);
    }
    final response = await _dio.get('/reports/monthly-revenue/',
        queryParameters: {'month': month, 'year': year});
    return response.data as Map<String, dynamic>;
  }

  /// GET /reports/completed-services/?from=&to=
  Future<Map<String, dynamic>> getCompletedServices(
      String from, String to) async {
    if (demoMode) {
      return DemoRepository.instance.getCompletedServices(from, to);
    }
    final response = await _dio.get('/reports/completed-services/',
        queryParameters: {'from': from, 'to': to});
    return response.data as Map<String, dynamic>;
  }

  /// GET /reports/mechanic-productivity/?from=&to=
  Future<Map<String, dynamic>> getMechanicProductivity(
      String from, String to) async {
    if (demoMode) {
      return DemoRepository.instance.getMechanicProductivity(from, to);
    }
    final response = await _dio.get('/reports/mechanic-productivity/',
        queryParameters: {'from': from, 'to': to});
    return response.data as Map<String, dynamic>;
  }

  /// GET /reports/spare-parts-usage/?from=&to=
  Future<Map<String, dynamic>> getSparePartsUsage(
      String from, String to) async {
    if (demoMode) {
      return DemoRepository.instance.getSparePartsUsage(from, to);
    }
    final response = await _dio.get('/reports/spare-parts-usage/',
        queryParameters: {'from': from, 'to': to});
    return response.data as Map<String, dynamic>;
  }

  /// GET /payments/pending/
  Future<List<dynamic>> getPendingPaymentsReport() async {
    if (demoMode) {
      return DemoRepository.instance.getPendingPaymentsReport();
    }
    final response = await _dio.get('/payments/pending/');
    final data = response.data;
    return data is List ? data : data['results'] as List<dynamic>;
  }
}
