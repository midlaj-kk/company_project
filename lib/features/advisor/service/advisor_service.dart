import 'package:auto_care_app/core/api/api_client.dart';
import 'package:auto_care_app/core/demo/demo_config.dart';
import 'package:auto_care_app/core/demo/demo_repository.dart';


/// All API calls used by the Service Advisor role live here.
class AdvisorService {
  final _dio = ApiClient().dio;

  /// GET /service-jobs/?status=&ordering=-created_at
  /// Returns jobs for the "Today's Jobs" list, optionally filtered
  /// by status ("waiting", "in_progress", "qc_pending", or null for all).
  Future<List<dynamic>> getJobs({String? status}) async {
    if (demoMode) {
      return DemoRepository.instance.getJobs(status: status);
    }
    final response = await _dio.get(
      '/service-jobs/',
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        'ordering': '-created_at',
      },
    );
    return response.data['results'] as List<dynamic>;
  }

  /// GET /customers/
  Future<List<dynamic>> getCustomers({String? search}) async {
    if (demoMode) {
      return DemoRepository.instance.getCustomers(search: search);
    }
    final response = await _dio.get(
      '/customers/',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return response.data['results'] as List<dynamic>;
  }

  /// POST /customers/
  Future<Map<String, dynamic>> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    if (demoMode) {
      return DemoRepository.instance.createCustomer(
        name: name,
        phone: phone,
        email: email,
        address: address,
      );
    }
    final response = await _dio.post('/customers/', data: {
      'name': name,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (address != null && address.isNotEmpty) 'address': address,
    });
    return response.data as Map<String, dynamic>;
  }

  /// POST /vehicles/
  Future<Map<String, dynamic>> createVehicle({
    required int customerId,
    required String vehicleNumber,
    required String brand,
    required String model,
    int? year,
    int? kilometers,
  }) async {
    if (demoMode) {
      return DemoRepository.instance.createVehicle(
        customerId: customerId,
        vehicleNumber: vehicleNumber,
        brand: brand,
        model: model,
        year: year,
        kilometers: kilometers,
      );
    }
    final response = await _dio.post('/vehicles/', data: {
      'customer': customerId,
      'vehicle_number': vehicleNumber,
      'brand': brand,
      'model': model,
      if (year != null) 'year': year,
      if (kilometers != null) 'kilometers': kilometers,
    });
    return response.data as Map<String, dynamic>;
  }

  /// GET /customers/{id}/vehicles/
  Future<List<dynamic>> getCustomerVehicles(int customerId) async {
    if (demoMode) {
      return DemoRepository.instance.getCustomerVehicles(customerId);
    }
    final response = await _dio.get('/customers/$customerId/vehicles/');
    final data = response.data;
    return data is List ? data : data['results'] as List<dynamic>;
  }

  /// GET /vehicles/{id}/
  Future<Map<String, dynamic>> getVehicleDetail(int vehicleId) async {
    if (demoMode) {
      return DemoRepository.instance.getVehicleDetail(vehicleId);
    }
    final response = await _dio.get('/vehicles/$vehicleId/');
    return response.data as Map<String, dynamic>;
  }

  /// GET /vehicles/{id}/history/
  Future<List<dynamic>> getVehicleHistory(int vehicleId) async {
    if (demoMode) {
      return DemoRepository.instance.getVehicleHistory(vehicleId);
    }
    final response = await _dio.get('/vehicles/$vehicleId/history/');
    return response.data['results'] as List<dynamic>;
  }

  /// GET /mechanics/ — used for the mechanic picker when creating/
  /// assigning a job.
  Future<List<dynamic>> getMechanics() async {
    if (demoMode) {
      return DemoRepository.instance.getMechanics();
    }
    final response = await _dio.get('/mechanics/');
    final data = response.data;
    return data is List ? data : data['results'] as List<dynamic>;
  }

  /// POST /service-jobs/
  Future<Map<String, dynamic>> createServiceJob({
    required int vehicleId,
    required String complaint,
    required String serviceType,
    int? odometerReading,
    int? assignedMechanicId,
  }) async {
    if (demoMode) {
      return DemoRepository.instance.createServiceJob(
        vehicleId: vehicleId,
        complaint: complaint,
        serviceType: serviceType,
        odometerReading: odometerReading,
        assignedMechanicId: assignedMechanicId,
      );
    }
    final response = await _dio.post('/service-jobs/', data: {
      'vehicle': vehicleId,
      'complaint': complaint,
      'service_type': serviceType,
      if (odometerReading != null) 'odometer_reading': odometerReading,
      if (assignedMechanicId != null) 'assigned_mechanic': assignedMechanicId,
    });
    return response.data as Map<String, dynamic>;
  }

  /// GET /service-jobs/{id}/
  Future<Map<String, dynamic>> getJobDetail(int jobId) async {
    if (demoMode) {
      return DemoRepository.instance.getJobDetail(jobId);
    }
    final response = await _dio.get('/service-jobs/$jobId/');
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /service-jobs/{id}/assign_mechanic/
  Future<void> assignMechanic(int jobId, int mechanicId) async {
    if (demoMode) {
      return DemoRepository.instance.assignMechanic(jobId, mechanicId);
    }
    await _dio.patch('/service-jobs/$jobId/assign_mechanic/', data: {
      'mechanic_id': mechanicId,
    });
  }

  /// PATCH /service-jobs/{id}/change_mechanic/
  Future<void> changeMechanic(int jobId, int mechanicId) async {
    if (demoMode) {
      return DemoRepository.instance.changeMechanic(jobId, mechanicId);
    }
    await _dio.patch('/service-jobs/$jobId/change_mechanic/', data: {
      'mechanic_id': mechanicId,
    });
  }

  /// PATCH /service-jobs/{id}/status/
  Future<void> updateJobStatus(int jobId, String status) async {
    if (demoMode) {
      return DemoRepository.instance.updateJobStatus(jobId, status);
    }
    await _dio.patch('/service-jobs/$jobId/status/', data: {
      'status': status,
    });
  }

  /// DELETE /service-jobs/{id}/ (cancel — Admin only per backend docs,
  /// kept here for completeness if role permissions allow it)
  Future<void> cancelJob(int jobId) async {
    if (demoMode) {
      return DemoRepository.instance.cancelJob(jobId);
    }
    await _dio.delete('/service-jobs/$jobId/');
  }
}