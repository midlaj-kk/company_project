import 'package:auto_care_app/core/demo/demo_repository.dart';

/// All data used by the Cashier role lives here. The app runs in
/// demo mode and reads from the in-memory [DemoRepository].
class CashierService {
  Future<List<dynamic>> getJobsReadyForBilling() {
    return DemoRepository.instance.getJobsReadyForBilling();
  }

  Future<List<dynamic>> getPendingPayments() {
    return DemoRepository.instance.getPendingPayments();
  }

  Future<Map<String, dynamic>> getDashboardSummary() {
    return DemoRepository.instance.getDashboardSummary();
  }

  Future<Map<String, dynamic>> getJobDetail(int jobId) {
    return DemoRepository.instance.getJobDetail(jobId);
  }

  Future<Map<String, dynamic>> createBill({
    required int serviceJobId,
    required double labourCharge,
    required double partsCharge,
    double tax = 0,
    double discount = 0,
  }) {
    return DemoRepository.instance.createBill(
      serviceJobId: serviceJobId,
      labourCharge: labourCharge,
      partsCharge: partsCharge,
      tax: tax,
      discount: discount,
    );
  }

  Future<Map<String, dynamic>> getBillDetail(int billId) {
    return DemoRepository.instance.getBillDetail(billId);
  }

  Future<Map<String, dynamic>> recordPayment({
    required int billId,
    required String paymentMethod,
    required double paidAmount,
    required String paymentDate,
  }) {
    return DemoRepository.instance.recordPayment(
      billId: billId,
      paymentMethod: paymentMethod,
      paidAmount: paidAmount,
      paymentDate: paymentDate,
    );
  }

  Future<List<dynamic>> getDeliveryReady() {
    return DemoRepository.instance.getDeliveryReady();
  }

  Future<Map<String, dynamic>> completeDelivery({
    required int serviceJobId,
    required String deliveryDate,
    required bool customerReceived,
    String? remarks,
  }) {
    return DemoRepository.instance.completeDelivery(
      serviceJobId: serviceJobId,
      deliveryDate: deliveryDate,
      customerReceived: customerReceived,
      remarks: remarks,
    );
  }
}
