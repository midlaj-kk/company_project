import 'package:auto_care_app/core/demo/demo_repository.dart';

/// All data used by the Mechanic role lives here. The app runs in
/// demo mode and reads from the in-memory [DemoRepository].
class MechanicService {
  Future<List<dynamic>> getMyJobs({String? status}) {
    return DemoRepository.instance.getMyJobs(status: status);
  }

  Future<Map<String, dynamic>> getJobDetail(int jobId) {
    return DemoRepository.instance.getJobDetail(jobId);
  }

  Future<void> updateJobStatus(int jobId, String status) {
    return DemoRepository.instance.updateJobStatus(jobId, status);
  }

  Future<List<dynamic>> getServiceWork(int jobId) {
    return DemoRepository.instance.getServiceWork(jobId);
  }

  Future<Map<String, dynamic>> addServiceWork({
    required int jobId,
    required String workName,
    required String description,
    required double labourCharge,
  }) {
    return DemoRepository.instance.addServiceWork(
      jobId: jobId,
      workName: workName,
      description: description,
      labourCharge: labourCharge,
    );
  }

  Future<void> updateWorkStatus(int workId, String status) {
    return DemoRepository.instance.updateWorkStatus(workId, status);
  }

  Future<void> deleteWork(int workId) {
    return DemoRepository.instance.deleteWork(workId);
  }

  Future<List<dynamic>> getPartsUsed(int jobId) {
    return DemoRepository.instance.getPartsUsed(jobId);
  }

  Future<List<dynamic>> searchSpareParts(String query) {
    return DemoRepository.instance.searchSpareParts(query);
  }

  Future<Map<String, dynamic>> addPartUsed({
    required int jobId,
    required int partId,
    required double quantity,
  }) {
    return DemoRepository.instance.addPartUsed(
      jobId: jobId,
      partId: partId,
      quantity: quantity,
    );
  }

  Future<void> deletePartUsed(int partUsedId) {
    return DemoRepository.instance.deletePartUsed(partUsedId);
  }

  Future<Map<String, dynamic>> getMyProfile() {
    return DemoRepository.instance.getMyProfile();
  }
}
