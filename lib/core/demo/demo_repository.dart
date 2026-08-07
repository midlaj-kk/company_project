import 'demo_data.dart';

/// In-memory stand-in for the real backend.
///
/// Every method mirrors the exact signature and return shape of the
/// corresponding `*Service` method.
class DemoRepository {
  DemoRepository._();

  static final DemoRepository instance = DemoRepository._();

  final DemoData _data = DemoData.instance;

  final Map<int, List<Map<String, dynamic>>> _stockHistoryCache = {};

  static String _now() => DateTime.now().toIso8601String();

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // -------------------------------------------------------------------
  // Shared helpers
  // -------------------------------------------------------------------

  String _nextInvoiceNumber() {
    final n = 36 + _data.bills.length;
    return 'INV-2026-${n.toString().padLeft(4, '0')}';
  }

  String _nextJobNumber(int jobId) =>
      'SJ-2026-${jobId.toString().padLeft(5, '0')}';

  List<Map<String, dynamic>> _partsHistory(int partId) {
    final cached = _stockHistoryCache[partId];
    if (cached != null) return cached;

    final history = <Map<String, dynamic>>[
      {
        'movement_type': 'in',
        'quantity': 10,
        'reference_type': 'purchase',
        'reference_id': null,
        'created_by_name': 'Admin',
        'created_at': _data.spareParts.isEmpty
            ? _now()
            : DateTime.now()
                .subtract(const Duration(days: 7))
                .toIso8601String(),
      },
      {
        'movement_type': 'out',
        'quantity': 2,
        'reference_type': 'service_job',
        'reference_id': 2,
        'created_by_name': 'Admin',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
      },
    ];
    _stockHistoryCache[partId] = history;
    return history;
  }

  // -------------------------------------------------------------------
  // Admin
  // -------------------------------------------------------------------

  Future<Map<String, dynamic>> getDashboardSummary() async {
    const activeStatuses = {'waiting', 'in_progress'};
    final activeJobs = _data.jobs
        .where((j) => activeStatuses.contains(j['status']))
        .length;
    final pendingQc =
        _data.jobs.where((j) => j['status'] == 'qc_pending').length;
    final readyForDelivery =
        _data.jobs.where((j) => j['status'] == 'ready_for_delivery').length;
    final lowStockItems = _data.spareParts
        .where((p) =>
            (p['stock_quantity'] as num) <= (p['minimum_stock'] as num))
        .length;

    final today = DateTime.now();
    final revenueToday = _data.bills.where((b) {
      final paid = DateTime.tryParse(b['payment_date']?.toString() ?? '');
      return paid != null && _sameDay(paid, today);
    }).fold<double>(0, (sum, b) => sum + (b['total_amount'] as num).toDouble());

    final totalJobsToday =
        _data.jobs.where((j) {
              final created = DateTime.tryParse(j['created_at']?.toString() ?? '');
              return created != null && _sameDay(created, today);
            }).length;

    return {
      'total_jobs_today': totalJobsToday,
      'active_jobs': activeJobs,
      'pending_qc': pendingQc,
      'ready_for_delivery': readyForDelivery,
      'revenue_today': revenueToday,
      'low_stock_items': lowStockItems,
    };
  }

  Future<List<dynamic>> getRecentJobs({int limit = 3}) async {
    final sorted = _data.jobs.toList()
      ..sort((a, b) {
        final ta = DateTime.tryParse(a['created_at']?.toString() ?? '');
        final tb = DateTime.tryParse(b['created_at']?.toString() ?? '');
        return (tb ?? DateTime.now()).compareTo(ta ?? DateTime.now());
      });
    return sorted.take(limit).toList();
  }

  Future<List<dynamic>> getStaff({String? search, String? role}) async {
    final query = (search ?? '').toLowerCase();
    return _data.staff.where((s) {
      final matchesRole =
          role == null || role == 'all' || s['role'] == role;
      final matchesSearch = query.isEmpty ||
          (s['name']?.toString().toLowerCase().contains(query) ?? false) ||
          (s['email']?.toString().toLowerCase().contains(query) ?? false);
      return matchesRole && matchesSearch;
    }).toList();
  }

  Future<Map<String, dynamic>> createStaff({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String password,
    String? specialization,
  }) async {
    final staff = {
      'id': _data.nextStaffId(),
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'password': password,
      'specialization': specialization ?? '',
      'status': 'active',
      'created_at': _now(),
    };
    _data.staff.add(staff);
    return staff;
  }

  Future<List<dynamic>> getSpareParts({
    String? search,
    bool lowStockOnly = false,
  }) async {
    final query = (search ?? '').toLowerCase();
    return _data.spareParts.where((p) {
      if (lowStockOnly &&
          (p['stock_quantity'] as num) > (p['minimum_stock'] as num)) {
        return false;
      }
      if (query.isEmpty) return true;
      return (p['name']?.toString().toLowerCase().contains(query) ?? false) ||
          (p['part_number']?.toString().toLowerCase().contains(query) ??
              false);
    }).toList();
  }

  Future<void> addStock(int partId, double quantity) async {
    final part = _data.findPart(partId);
    if (part == null) return;
    part['stock_quantity'] = (part['stock_quantity'] as num) + quantity;
    _partsHistory(partId).insert(0, {
      'movement_type': 'in',
      'quantity': quantity,
      'reference_type': 'purchase',
      'reference_id': null,
      'created_by_name': 'Admin',
      'created_at': _now(),
    });
  }

  Future<void> reduceStock(int partId, double quantity, {String? reason}) async {
    final part = _data.findPart(partId);
    if (part == null) return;
    part['stock_quantity'] = (part['stock_quantity'] as num) - quantity;
    _partsHistory(partId).insert(0, {
      'movement_type': 'out',
      'quantity': quantity,
      'reference_type': '',
      'reference_id': null,
      'created_by_name': 'Admin',
      'created_at': _now(),
    });
  }

  Future<Map<String, dynamic>> getSparePartDetail(int partId) async {
    final part = _data.findPart(partId);
    if (part == null) throw Exception('Part not found');
    return part;
  }

  Future<List<dynamic>> getStockHistory(int partId) async {
    return _partsHistory(partId).toList();
  }

  Future<Map<String, dynamic>> getServiceJobDetail(int jobId) async {
    final job = _data.findJob(jobId);
    if (job == null) throw Exception('Job not found');
    return job;
  }

  Future<void> submitQualityCheck({
    required int serviceJobId,
    required Map<String, String> checklist,
    required String overallStatus,
    String? remarks,
  }) async {
    final job = _data.findJob(serviceJobId);
    if (job == null) return;
    job['status'] =
        overallStatus == 'rework_required' ? 'rework_required' : 'ready_for_bill';
    job['updated_at'] = _now();
    if (remarks != null && remarks.isNotEmpty) {
      job['remarks'] = remarks;
    }
  }

  Future<Map<String, dynamic>> getMonthlyRevenue(int month, int year) async {
    final total = _data.bills.where((b) {
      final created = DateTime.tryParse(b['created_at']?.toString() ?? '');
      return created != null &&
          created.month == month &&
          created.year == year;
    }).fold<double>(0, (sum, b) => sum + (b['total_amount'] as num).toDouble());
    return {'total_revenue': total};
  }

  Future<Map<String, dynamic>> getCompletedServices(
      String from, String to) async {
    const done = {'delivered', 'ready_for_delivery'};
    final total = _data.jobs.where((j) => done.contains(j['status'])).length;
    return {'total_completed': total};
  }

  Future<Map<String, dynamic>> getMechanicProductivity(
      String from, String to) async {
    const finished = {
      'qc_pending',
      'ready_for_bill',
      'ready_for_delivery',
      'delivered',
    };
    final counts = <String, int>{};
    for (final job in _data.jobs) {
      if (!finished.contains(job['status'])) continue;
      final name = job['mechanic_name']?.toString() ?? 'Unassigned';
      counts[name] = (counts[name] ?? 0) + 1;
    }
    final mechanics = counts.entries
        .map((e) => {
              'mechanic_name': e.key,
              'completed_jobs': e.value,
            })
        .toList()
      ..sort((a, b) =>
          (b['completed_jobs'] as int).compareTo(a['completed_jobs'] as int));
    return {'mechanics': mechanics};
  }

  Future<Map<String, dynamic>> getSparePartsUsage(
      String from, String to) async {
    final counts = <String, double>{};
    for (final pu in _data.partsUsed) {
      final name = pu['part_name']?.toString() ?? 'Part';
      counts[name] = (counts[name] ?? 0) + (pu['quantity'] as num).toDouble();
    }
    final parts = counts.entries
        .map((e) => {'part_name': e.key, 'quantity_used': e.value})
        .toList()
      ..sort((a, b) =>
          (b['quantity_used'] as num).compareTo(a['quantity_used'] as num));
    return {'parts': parts};
  }

  Future<List<dynamic>> getPendingPaymentsReport() async {
    return _data.bills
        .where((b) => b['payment_status'] != 'paid')
        .toList();
  }

  // -------------------------------------------------------------------
  // Advisor
  // -------------------------------------------------------------------

  Future<List<dynamic>> getJobs({String? status}) async {
    return _data.jobs.where((j) {
      if (status == null || status == 'all') return true;
      return j['status'] == status;
    }).toList();
  }

  Future<List<dynamic>> getCustomers({String? search}) async {
    final query = (search ?? '').toLowerCase();
    return _data.customers.where((c) {
      if (query.isEmpty) return true;
      return (c['name']?.toString().toLowerCase().contains(query) ?? false) ||
          (c['phone']?.toString().contains(query) ?? false);
    }).toList();
  }

  Future<Map<String, dynamic>> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    final customer = {
      'id': _data.nextCustomerId(),
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'vehicle_count': 0,
      'created_at': _now(),
    };
    _data.customers.add(customer);
    return customer;
  }

  Future<Map<String, dynamic>> createVehicle({
    required int customerId,
    required String vehicleNumber,
    required String brand,
    required String model,
    int? year,
    int? kilometers,
  }) async {
    final customer = _data.findCustomer(customerId);
    final vehicle = {
      'id': _data.nextVehicleId(),
      'customer_id': customerId,
      'customer_name': customer?['name'] ?? '',
      'vehicle_number': vehicleNumber,
      'brand': brand,
      'model': model,
      'year': year ?? DateTime.now().year,
      'kilometers': kilometers ?? 0,
      'fuel_type': 'Petrol',
      'transmission': 'Automatic',
      'engine_cc': null,
      'last_checkup': null,
      'created_at': _now(),
    };
    _data.vehicles.add(vehicle);
    if (customer != null) {
      customer['vehicle_count'] =
          (customer['vehicle_count'] as int? ?? 0) + 1;
    }
    return vehicle;
  }

  Future<List<dynamic>> getCustomerVehicles(int customerId) async {
    return _data.vehicles
        .where((v) => v['customer_id'] == customerId)
        .toList();
  }

  Future<Map<String, dynamic>> getVehicleDetail(int vehicleId) async {
    final vehicle = _data.findVehicle(vehicleId);
    if (vehicle == null) throw Exception('Vehicle not found');
    return vehicle;
  }

  Future<List<dynamic>> getVehicleHistory(int vehicleId) async {
    return _data.jobs
        .where((j) => j['vehicle_id'] == vehicleId)
        .toList();
  }

  Future<List<dynamic>> getMechanics() async {
    return _data.staff
        .where((s) => s['role'] == 'mechanic' && s['status'] == 'active')
        .map((s) => {
              'id': s['id'],
              'name': s['name'],
              'specialization': s['specialization'] ?? '',
            })
        .toList();
  }

  Future<Map<String, dynamic>> createServiceJob({
    required int vehicleId,
    required String complaint,
    required String serviceType,
    int? odometerReading,
    int? assignedMechanicId,
  }) async {
    final vehicle = _data.findVehicle(vehicleId);
    final mechanic = assignedMechanicId != null
        ? _data.findStaff(assignedMechanicId)
        : null;

    final jobId = _data.nextJobId();
    final job = {
      'id': jobId,
      'job_number': _nextJobNumber(jobId),
      'vehicle_id': vehicleId,
      'vehicle_number': vehicle?['vehicle_number'] ?? '',
      'vehicle_model':
          '${vehicle?['brand'] ?? ''} ${vehicle?['model'] ?? ''}'.trim(),
      'customer_id': vehicle?['customer_id'],
      'customer_name': vehicle?['customer_name'] ?? '',
      'customer_phone': '',
      'service_type': serviceType,
      'complaint': complaint,
      'status': 'waiting',
      'mechanic_id': mechanic?['id'],
      'mechanic_name': mechanic?['name'],
      'mechanic_specialization': mechanic?['specialization'],
      'odometer_reading': odometerReading ?? 0,
      'created_at': _now(),
      'updated_at': _now(),
      'remarks': '',
      'total_labour': 0,
      'total_parts': 0,
    };
    _data.jobs.insert(0, job);
    return job;
  }

  Future<Map<String, dynamic>> getJobDetail(int jobId) async {
    final job = _data.findJob(jobId);
    if (job == null) throw Exception('Job not found');
    return job;
  }

  Future<void> assignMechanic(int jobId, int mechanicId) async {
    final job = _data.findJob(jobId);
    final mechanic = _data.findStaff(mechanicId);
    if (job == null || mechanic == null) return;
    job['mechanic_id'] = mechanicId;
    job['mechanic_name'] = mechanic['name'];
    job['mechanic_specialization'] = mechanic['specialization'] ?? '';
    job['status'] = 'in_progress';
    job['updated_at'] = _now();
  }

  Future<void> changeMechanic(int jobId, int mechanicId) async {
    await assignMechanic(jobId, mechanicId);
  }

  Future<void> updateJobStatus(int jobId, String status) async {
    final job = _data.findJob(jobId);
    if (job == null) return;
    job['status'] = status;
    job['updated_at'] = _now();
  }

  Future<void> cancelJob(int jobId) async {
    _data.jobs.removeWhere((j) => j['id'] == jobId);
  }

  // -------------------------------------------------------------------
  // Mechanic
  // -------------------------------------------------------------------

  static const int _demoMechanicId = 3;

  Future<List<dynamic>> getMyJobs({String? status}) async {
    return _data.jobs.where((j) {
      if (j['mechanic_id'] != _demoMechanicId) return false;
      if (status == null || status == 'all') return true;
      return j['status'] == status;
    }).toList();
  }

  Future<List<dynamic>> getServiceWork(int jobId) async {
    return _data.works.where((w) => w['service_job_id'] == jobId).toList();
  }

  Future<Map<String, dynamic>> addServiceWork({
    required int jobId,
    required String workName,
    required String description,
    required double labourCharge,
  }) async {
    final work = {
      'id': _data.nextWorkId(),
      'service_job_id': jobId,
      'work_name': workName,
      'description': description,
      'labour_charge': labourCharge,
      'status': 'pending',
      'created_at': _now(),
    };
    _data.works.add(work);
    return work;
  }

  Future<void> updateWorkStatus(int workId, String status) async {
    for (final work in _data.works) {
      if (work['id'] == workId) {
        work['status'] = status;
        return;
      }
    }
  }

  Future<void> deleteWork(int workId) async {
    _data.works.removeWhere((w) => w['id'] == workId);
  }

  Future<List<dynamic>> getPartsUsed(int jobId) async {
    return _data.partsUsed
        .where((p) => p['service_job_id'] == jobId)
        .toList();
  }

  Future<List<dynamic>> searchSpareParts(String query) async {
    final q = query.toLowerCase();
    return _data.spareParts.where((p) {
      if (q.isEmpty) return true;
      return (p['name']?.toString().toLowerCase().contains(q) ?? false) ||
          (p['part_number']?.toString().toLowerCase().contains(q) ?? false);
    }).toList();
  }

  Future<Map<String, dynamic>> addPartUsed({
    required int jobId,
    required int partId,
    required double quantity,
  }) async {
    final part = _data.findPart(partId);
    if (part == null) throw Exception('Part not found');
    final entry = {
      'id': _data.nextPartUsedId(),
      'service_job_id': jobId,
      'part_id': partId,
      'part_name': part['name'],
      'part_number': part['part_number'],
      'unit': part['unit'],
      'quantity': quantity,
      'price': part['selling_price'],
      'created_at': _now(),
    };
    _data.partsUsed.add(entry);
    part['stock_quantity'] = (part['stock_quantity'] as num) - quantity;
    return entry;
  }

  Future<void> deletePartUsed(int partUsedId) async {
    final entry = _data.partsUsed
        .where((p) => p['id'] == partUsedId)
        .firstOrNull;
    if (entry == null) return;
    final part = _data.findPart(entry['part_id'] as int);
    if (part != null) {
      part['stock_quantity'] =
          (part['stock_quantity'] as num) + (entry['quantity'] as num);
    }
    _data.partsUsed.removeWhere((p) => p['id'] == partUsedId);
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    final profile = _data.findStaff(_demoMechanicId);
    if (profile == null) throw Exception('Profile not found');
    return profile;
  }

  // -------------------------------------------------------------------
  // Cashier
  // -------------------------------------------------------------------

  Future<List<dynamic>> getJobsReadyForBilling() async {
    final billedJobIds = _data.bills.map((b) => b['service_job_id']).toSet();
    return _data.jobs
        .where((j) =>
            j['status'] == 'ready_for_bill' &&
            !billedJobIds.contains(j['id']))
        .toList();
  }

  Future<List<dynamic>> getPendingPayments() async {
    return _data.bills
        .where((b) => b['payment_status'] != 'paid')
        .toList();
  }

  Future<Map<String, dynamic>> createBill({
    required int serviceJobId,
    required double labourCharge,
    required double partsCharge,
    double tax = 0,
    double discount = 0,
  }) async {
    final job = _data.findJob(serviceJobId);
    final total = labourCharge + partsCharge + tax - discount;
    final bill = {
      'id': _data.nextBillId(),
      'invoice_number': _nextInvoiceNumber(),
      'service_job_id': serviceJobId,
      'job_number': job?['job_number'],
      'customer_id': job?['customer_id'],
      'customer_name': job?['customer_name'] ?? '',
      'vehicle_number': job?['vehicle_number'] ?? '',
      'labour_charge': labourCharge,
      'parts_charge': partsCharge,
      'tax': tax,
      'discount': discount,
      'total_amount': total,
      'amount_paid': 0.0,
      'payment_status': 'pending',
      'payment_method': null,
      'created_at': _now(),
      'payment_date': null,
    };
    _data.bills.add(bill);
    if (job != null) {
      job['status'] = 'billed';
      job['updated_at'] = _now();
    }
    return bill;
  }

  Future<Map<String, dynamic>> getBillDetail(int billId) async {
    final bill = _data.findBill(billId);
    if (bill == null) throw Exception('Bill not found');
    return bill;
  }

  Future<Map<String, dynamic>> recordPayment({
    required int billId,
    required String paymentMethod,
    required double paidAmount,
    required String paymentDate,
  }) async {
    final bill = _data.findBill(billId);
    if (bill == null) throw Exception('Bill not found');

    final alreadyPaid = (bill['amount_paid'] as num?)?.toDouble() ?? 0;
    final newPaid = alreadyPaid + paidAmount;
    bill['amount_paid'] = newPaid;
    bill['payment_method'] = paymentMethod;
    bill['payment_date'] = paymentDate;

    if (newPaid >= (bill['total_amount'] as num).toDouble()) {
      bill['payment_status'] = 'paid';
      final job = _data.findJob(bill['service_job_id'] as int);
      if (job != null) {
        job['status'] = 'ready_for_delivery';
        job['updated_at'] = _now();
      }
    } else {
      bill['payment_status'] = 'partial';
    }
    return bill;
  }

  Future<List<dynamic>> getDeliveryReady() async {
    return _data.jobs
        .where((j) => j['status'] == 'ready_for_delivery')
        .toList();
  }

  Future<Map<String, dynamic>> completeDelivery({
    required int serviceJobId,
    required String deliveryDate,
    required bool customerReceived,
    String? remarks,
  }) async {
    final job = _data.findJob(serviceJobId);
    if (job != null) {
      job['status'] = 'delivered';
      job['updated_at'] = _now();
      if (remarks != null && remarks.isNotEmpty) {
        job['remarks'] = remarks;
      }
    }
    return {
      'service_job': serviceJobId,
      'delivery_date': deliveryDate,
      'customer_received': customerReceived,
      'remarks': remarks,
    };
  }
}
