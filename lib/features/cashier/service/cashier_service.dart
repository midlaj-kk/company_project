import 'package:auto_care_app/core/api/api_client.dart';


/// All API calls used by the Cashier role live here.
class CashierService {
  final _dio = ApiClient().dio;

  /// GET /service-jobs/?status=ready_for_bill
  Future<List<dynamic>> getJobsReadyForBilling() async {
    final response = await _dio.get(
      '/service-jobs/',
      queryParameters: {'status': 'ready_for_bill'},
    );
    return response.data['results'] as List<dynamic>;
  }

  /// GET /payments/pending/
  Future<List<dynamic>> getPendingPayments() async {
    final response = await _dio.get('/payments/pending/');
    final data = response.data;
    return data is List ? data : data['results'] as List<dynamic>;
  }

  /// GET /dashboard/summary/ — reused for "Revenue Today" stat.
  Future<Map<String, dynamic>> getDashboardSummary() async {
    final response = await _dio.get('/dashboard/summary/');
    return response.data as Map<String, dynamic>;
  }

  /// GET /service-jobs/{id}/
  Future<Map<String, dynamic>> getJobDetail(int jobId) async {
    final response = await _dio.get('/service-jobs/$jobId/');
    return response.data as Map<String, dynamic>;
  }

  /// POST /bills/
  Future<Map<String, dynamic>> createBill({
    required int serviceJobId,
    required double labourCharge,
    required double partsCharge,
    double tax = 0,
    double discount = 0,
  }) async {
    final response = await _dio.post('/bills/', data: {
      'service_job': serviceJobId,
      'labour_charge': labourCharge,
      'parts_charge': partsCharge,
      'tax': tax,
      'discount': discount,
    });
    return response.data as Map<String, dynamic>;
  }

  /// GET /bills/{id}/
  Future<Map<String, dynamic>> getBillDetail(int billId) async {
    final response = await _dio.get('/bills/$billId/');
    return response.data as Map<String, dynamic>;
  }

  /// POST /payments/
  Future<Map<String, dynamic>> recordPayment({
    required int billId,
    required String paymentMethod,
    required double paidAmount,
    required String paymentDate,
  }) async {
    final response = await _dio.post('/payments/', data: {
      'bill': billId,
      'payment_method': paymentMethod,
      'paid_amount': paidAmount,
      'payment_date': paymentDate,
    });
    return response.data as Map<String, dynamic>;
  }

  /// GET /delivery/ready/
  Future<List<dynamic>> getDeliveryReady() async {
    final response = await _dio.get('/delivery/ready/');
    final data = response.data;
    return data is List ? data : data['results'] as List<dynamic>;
  }

  /// POST /delivery/
  Future<Map<String, dynamic>> completeDelivery({
    required int serviceJobId,
    required String deliveryDate,
    required bool customerReceived,
    String? remarks,
  }) async {
    final response = await _dio.post('/delivery/', data: {
      'service_job': serviceJobId,
      'delivery_date': deliveryDate,
      'customer_received': customerReceived,
      if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
    });
    return response.data as Map<String, dynamic>;
  }
}