import 'package:auto_care_app/core/demo/demo_repository.dart';

/// All data used by the Service Advisor role lives here. The app
/// runs in demo mode and reads from the in-memory [DemoRepository].
class AdvisorService {
  Future<List<dynamic>> getJobs({String? status}) {
    return DemoRepository.instance.getJobs(status: status);
  }

  Future<List<dynamic>> getCustomers({String? search}) {
    return DemoRepository.instance.getCustomers(search: search);
  }

  Future<Map<String, dynamic>> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) {
    return DemoRepository.instance.createCustomer(
      name: name,
      phone: phone,
      email: email,
      address: address,
    );
  }

  Future<Map<String, dynamic>> createVehicle({
    required int customerId,
    required String vehicleNumber,
    required String brand,
    required String model,
    int? year,
    int? kilometers,
  }) {
    return DemoRepository.instance.createVehicle(
      customerId: customerId,
      vehicleNumber: vehicleNumber,
      brand: brand,
      model: model,
      year: year,
      kilometers: kilometers,
    );
  }

  Future<List<dynamic>> getCustomerVehicles(int customerId) {
    return DemoRepository.instance.getCustomerVehicles(customerId);
  }

  Future<Map<String, dynamic>> getVehicleDetail(int vehicleId) {
    return DemoRepository.instance.getVehicleDetail(vehicleId);
  }

  Future<List<dynamic>> getVehicleHistory(int vehicleId) {
    return DemoRepository.instance.getVehicleHistory(vehicleId);
  }

  Future<List<dynamic>> getMechanics() {
    return DemoRepository.instance.getMechanics();
  }

  Future<Map<String, dynamic>> createServiceJob({
    required int vehicleId,
    required String complaint,
    required String serviceType,
    int? odometerReading,
    int? assignedMechanicId,
  }) {
    return DemoRepository.instance.createServiceJob(
      vehicleId: vehicleId,
      complaint: complaint,
      serviceType: serviceType,
      odometerReading: odometerReading,
      assignedMechanicId: assignedMechanicId,
    );
  }

  Future<Map<String, dynamic>> getJobDetail(int jobId) {
    return DemoRepository.instance.getJobDetail(jobId);
  }

  Future<void> assignMechanic(int jobId, int mechanicId) {
    return DemoRepository.instance.assignMechanic(jobId, mechanicId);
  }

  Future<void> changeMechanic(int jobId, int mechanicId) {
    return DemoRepository.instance.changeMechanic(jobId, mechanicId);
  }

  Future<void> updateJobStatus(int jobId, String status) {
    return DemoRepository.instance.updateJobStatus(jobId, status);
  }

  Future<void> cancelJob(int jobId) {
    return DemoRepository.instance.cancelJob(jobId);
  }
}
