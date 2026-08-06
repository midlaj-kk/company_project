import 'package:auto_care_app/core/api/api_client.dart';


/// All API calls used by the Mechanic role live here.
/// The backend automatically filters /service-jobs/ to only the
/// logged-in mechanic's own jobs (see get_queryset() in the docs),
/// so no extra "assigned to me" filter is needed client-side.
class MechanicService {
  final _dio = ApiClient().dio;

  /// GET /service-jobs/?status=
  Future<List<dynamic>> getMyJobs({String? status}) async {
    final response = await _dio.get(
      '/service-jobs/',
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        'ordering': '-created_at',
      },
    );
    return response.data['results'] as List<dynamic>;
  }

  /// GET /service-jobs/{id}/
  Future<Map<String, dynamic>> getJobDetail(int jobId) async {
    final response = await _dio.get('/service-jobs/$jobId/');
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /service-jobs/{id}/status/
  Future<void> updateJobStatus(int jobId, String status) async {
    await _dio.patch('/service-jobs/$jobId/status/', data: {
      'status': status,
    });
  }

  /// GET /works/?service_job=
  Future<List<dynamic>> getServiceWork(int jobId) async {
    final response = await _dio.get(
      '/works/',
      queryParameters: {'service_job': jobId},
    );
    return response.data['results'] as List<dynamic>;
  }

  /// POST /works/
  Future<Map<String, dynamic>> addServiceWork({
    required int jobId,
    required String workName,
    required String description,
    required double labourCharge,
  }) async {
    final response = await _dio.post('/works/', data: {
      'service_job': jobId,
      'work_name': workName,
      'description': description,
      'labour_charge': labourCharge,
    });
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /works/{id}/status/
  Future<void> updateWorkStatus(int workId, String status) async {
    await _dio.patch('/works/$workId/status/', data: {'status': status});
  }

  /// DELETE /works/{id}/
  Future<void> deleteWork(int workId) async {
    await _dio.delete('/works/$workId/');
  }

  /// GET /parts-used/?service_job=
  Future<List<dynamic>> getPartsUsed(int jobId) async {
    final response = await _dio.get(
      '/parts-used/',
      queryParameters: {'service_job': jobId},
    );
    return response.data['results'] as List<dynamic>;
  }

  /// GET /spare-parts/?search= — used to search parts when adding
  /// a part used to a job.
  Future<List<dynamic>> searchSpareParts(String query) async {
    final response = await _dio.get(
      '/spare-parts/',
      queryParameters: {if (query.isNotEmpty) 'search': query},
    );
    return response.data['results'] as List<dynamic>;
  }

  /// POST /parts-used/
  Future<Map<String, dynamic>> addPartUsed({
    required int jobId,
    required int partId,
    required double quantity,
  }) async {
    final response = await _dio.post('/parts-used/', data: {
      'service_job': jobId,
      'part_id': partId,
      'quantity': quantity,
    });
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /parts-used/{id}/ (restores stock automatically)
  Future<void> deletePartUsed(int partUsedId) async {
    await _dio.delete('/parts-used/$partUsedId/');
  }

  /// GET /auth/me/ — used on the Profile screen.
  Future<Map<String, dynamic>> getMyProfile() async {
    final response = await _dio.get('/auth/me/');
    return response.data as Map<String, dynamic>;
  }
}