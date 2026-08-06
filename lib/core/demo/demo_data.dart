/// In-memory store that backs the whole app while [demoMode] is on.
///
/// Holds realistic seed data (customers, vehicles, staff, spare parts,
/// jobs, work items, parts used and bills) and exposes low-level
/// mutation helpers. All reads / higher-level business logic live in
/// [DemoRepository] so that the rest of the app keeps talking to
/// service-shaped methods exactly like the real backend.
class DemoData {
  DemoData._();

  static final DemoData instance = DemoData._();

  final List<Map<String, dynamic>> customers = _buildCustomers();
  final List<Map<String, dynamic>> vehicles = _buildVehicles();
  final List<Map<String, dynamic>> staff = _buildStaff();
  final List<Map<String, dynamic>> spareParts = _buildSpareParts();
  final List<Map<String, dynamic>> jobs = _buildJobs();
  final List<Map<String, dynamic>> works = _buildWorks();
  final List<Map<String, dynamic>> partsUsed = _buildPartsUsed();
  final List<Map<String, dynamic>> bills = _buildBills();

  int _nextCustomerId = 100;
  int _nextVehicleId = 100;
  int _nextStaffId = 100;
  int _nextPartId = 100;
  int _nextJobId = 100;
  int _nextWorkId = 100;
  int _nextPartUsedId = 100;
  int _nextBillId = 100;

  static String _iso(Duration offset) =>
      DateTime.now().subtract(offset).toIso8601String();

  // ---------------------------------------------------------------------
  // Seeds
  // ---------------------------------------------------------------------

  static List<Map<String, dynamic>> _buildCustomers() {
    return [
      {
        'id': 1,
        'name': 'Vikram Malhotra',
        'phone': '+91 98220 11223',
        'email': 'vikram.malhotra@example.com',
        'address': '12 Marine Drive, Mumbai',
        'vehicle_count': 1,
        'created_at': _iso(const Duration(days: 220)),
      },
      {
        'id': 2,
        'name': 'Karan Mehta',
        'phone': '+91 99871 44556',
        'email': 'karan.mehta@example.com',
        'address': '8 Residency Road, Bengaluru',
        'vehicle_count': 1,
        'created_at': _iso(const Duration(days: 190)),
      },
      {
        'id': 3,
        'name': 'Ananya Iyer',
        'phone': '+91 98450 77889',
        'email': 'ananya.iyer@example.com',
        'address': '221 MG Road, Pune',
        'vehicle_count': 1,
        'created_at': _iso(const Duration(days: 150)),
      },
      {
        'id': 4,
        'name': 'Arjun Reddy',
        'phone': '+91 90001 22334',
        'email': 'arjun.reddy@example.com',
        'address': '45 Jubilee Hills, Hyderabad',
        'vehicle_count': 2,
        'created_at': _iso(const Duration(days: 120)),
      },
      {
        'id': 5,
        'name': 'Farah Khan',
        'phone': '+91 98765 43210',
        'email': 'farah.khan@example.com',
        'address': '3 Linking Road, Mumbai',
        'vehicle_count': 1,
        'created_at': _iso(const Duration(days: 90)),
      },
    ];
  }

  static List<Map<String, dynamic>> _buildVehicles() {
    return [
      {
        'id': 1,
        'customer_id': 1,
        'customer_name': 'Vikram Malhotra',
        'vehicle_number': 'MH-12-CD-3392',
        'brand': 'Porsche',
        'model': '911 GT3',
        'year': 2023,
        'kilometers': 4200,
        'fuel_type': 'Petrol',
        'transmission': 'Automatic',
        'engine_cc': 3996,
        'last_checkup': '2025-11-18',
        'created_at': _iso(const Duration(days: 220)),
      },
      {
        'id': 2,
        'customer_id': 2,
        'customer_name': 'Karan Mehta',
        'vehicle_number': 'KL-07-BV-4455',
        'brand': 'Mercedes-Benz',
        'model': 'GLC 300',
        'year': 2022,
        'kilometers': 18300,
        'fuel_type': 'Petrol',
        'transmission': 'Automatic',
        'engine_cc': 1999,
        'last_checkup': '2026-01-05',
        'created_at': _iso(const Duration(days: 190)),
      },
      {
        'id': 3,
        'customer_id': 3,
        'customer_name': 'Ananya Iyer',
        'vehicle_number': 'KA-01-MJ-1234',
        'brand': 'Audi',
        'model': 'Q7',
        'year': 2021,
        'kilometers': 27600,
        'fuel_type': 'Diesel',
        'transmission': 'Automatic',
        'engine_cc': 2967,
        'last_checkup': '2025-12-20',
        'created_at': _iso(const Duration(days: 150)),
      },
      {
        'id': 4,
        'customer_id': 5,
        'customer_name': 'Farah Khan',
        'vehicle_number': 'TS-09-ER-7788',
        'brand': 'Range Rover',
        'model': 'Sport HSE',
        'year': 2023,
        'kilometers': 9100,
        'fuel_type': 'Petrol',
        'transmission': 'Automatic',
        'engine_cc': 5000,
        'last_checkup': '2025-10-02',
        'created_at': _iso(const Duration(days: 90)),
      },
      {
        'id': 5,
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'vehicle_number': 'KA-05-PQ-9901',
        'brand': 'BMW',
        'model': 'M5 Competition',
        'year': 2022,
        'kilometers': 15700,
        'fuel_type': 'Petrol',
        'transmission': 'Automatic',
        'engine_cc': 4395,
        'last_checkup': '2025-09-14',
        'created_at': _iso(const Duration(days: 120)),
      },
      {
        'id': 6,
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'vehicle_number': 'KA-05-PQ-9902',
        'brand': 'Porsche',
        'model': 'Cayenne S',
        'year': 2023,
        'kilometers': 6800,
        'fuel_type': 'Petrol',
        'transmission': 'Automatic',
        'engine_cc': 3996,
        'last_checkup': '2026-02-01',
        'created_at': _iso(const Duration(days: 90)),
      },
    ];
  }

  static List<Map<String, dynamic>> _buildStaff() {
    return [
      {
        'id': 1,
        'name': 'Neha Sharma',
        'email': 'admin@autocare.demo',
        'phone': '+91 90000 00001',
        'role': 'admin',
        'status': 'active',
        'specialization': '',
        'created_at': _iso(const Duration(days: 300)),
      },
      {
        'id': 2,
        'name': 'Rajesh Verma',
        'email': 'advisor@autocare.demo',
        'phone': '+91 90000 00002',
        'role': 'service_advisor',
        'status': 'active',
        'specialization': '',
        'created_at': _iso(const Duration(days: 280)),
      },
      {
        'id': 3,
        'name': 'Ramesh Kumar',
        'email': 'mechanic@autocare.demo',
        'phone': '+91 90000 00003',
        'role': 'mechanic',
        'status': 'active',
        'specialization': 'Engine & Transmission',
        'created_at': _iso(const Duration(days: 260)),
      },
      {
        'id': 4,
        'name': 'Suresh Patil',
        'email': 'suresh.patil@autocare.demo',
        'phone': '+91 90000 00004',
        'role': 'mechanic',
        'status': 'active',
        'specialization': 'Brakes & Suspension',
        'created_at': _iso(const Duration(days: 240)),
      },
      {
        'id': 5,
        'name': 'Priya Nair',
        'email': 'cashier@autocare.demo',
        'phone': '+91 90000 00005',
        'role': 'cashier',
        'status': 'active',
        'specialization': '',
        'created_at': _iso(const Duration(days: 200)),
      },
    ];
  }

  static List<Map<String, dynamic>> _buildSpareParts() {
    return [
      {
        'id': 1,
        'name': 'Engine Oil 5W-30 (1L)',
        'part_number': 'LUB-EO-5W30',
        'stock_quantity': 24,
        'minimum_stock': 15,
        'unit': 'L',
        'purchase_price': 480.0,
        'selling_price': 650.0,
        'location': 'Rack A-12',
        'supplier': 'Castrol Distributors',
        'created_at': _iso(const Duration(days: 200)),
      },
      {
        'id': 2,
        'name': 'Engine Oil 10W-40 (1L)',
        'part_number': 'LUB-EO-10W40',
        'stock_quantity': 6,
        'minimum_stock': 10,
        'unit': 'L',
        'purchase_price': 440.0,
        'selling_price': 600.0,
        'location': 'Rack A-13',
        'supplier': 'Castrol Distributors',
        'created_at': _iso(const Duration(days: 200)),
      },
      {
        'id': 3,
        'name': 'Oil Filter',
        'part_number': 'FLT-OIL-003',
        'stock_quantity': 32,
        'minimum_stock': 12,
        'unit': 'pcs',
        'purchase_price': 180.0,
        'selling_price': 280.0,
        'location': 'Rack B-02',
        'supplier': 'Bosch India',
        'created_at': _iso(const Duration(days: 180)),
      },
      {
        'id': 4,
        'name': 'Air Filter',
        'part_number': 'FLT-AIR-007',
        'stock_quantity': 18,
        'minimum_stock': 10,
        'unit': 'pcs',
        'purchase_price': 220.0,
        'selling_price': 340.0,
        'location': 'Rack B-03',
        'supplier': 'Bosch India',
        'created_at': _iso(const Duration(days: 180)),
      },
      {
        'id': 5,
        'name': 'Brake Pads (Front Set)',
        'part_number': 'BRK-PAD-012',
        'stock_quantity': 9,
        'minimum_stock': 8,
        'unit': 'set',
        'purchase_price': 1250.0,
        'selling_price': 1850.0,
        'location': 'Rack C-01',
        'supplier': 'Bosch India',
        'created_at': _iso(const Duration(days: 160)),
      },
      {
        'id': 6,
        'name': 'Spark Plugs (Set of 4)',
        'part_number': 'IGN-SPK-004',
        'stock_quantity': 4,
        'minimum_stock': 6,
        'unit': 'set',
        'purchase_price': 900.0,
        'selling_price': 1350.0,
        'location': 'Rack C-05',
        'supplier': 'NGK',
        'created_at': _iso(const Duration(days: 160)),
      },
      {
        'id': 7,
        'name': 'Wiper Blades (Pair)',
        'part_number': 'WIP-PR-001',
        'stock_quantity': 21,
        'minimum_stock': 10,
        'unit': 'set',
        'purchase_price': 350.0,
        'selling_price': 550.0,
        'location': 'Rack D-02',
        'supplier': 'Bosch India',
        'created_at': _iso(const Duration(days: 140)),
      },
      {
        'id': 8,
        'name': 'Coolant (5L)',
        'part_number': 'FLU-COL-005',
        'stock_quantity': 13,
        'minimum_stock': 6,
        'unit': 'L',
        'purchase_price': 520.0,
        'selling_price': 780.0,
        'location': 'Rack A-08',
        'supplier': 'Valvoline',
        'created_at': _iso(const Duration(days: 140)),
      },
    ];
  }

  static List<Map<String, dynamic>> _buildJobs() {
    return [
      {
        'id': 1,
        'job_number': 'SJ-2026-00001',
        'vehicle_id': 1,
        'vehicle_number': 'MH-12-CD-3392',
        'vehicle_model': 'Porsche 911 GT3',
        'customer_id': 1,
        'customer_name': 'Vikram Malhotra',
        'customer_phone': '+91 98220 11223',
        'service_type': 'Periodic Maintenance',
        'complaint': 'Annual service due. Car brought in for a routine check-up.',
        'status': 'waiting',
        'mechanic_id': null,
        'mechanic_name': null,
        'mechanic_specialization': null,
        'odometer_reading': 4200,
        'created_at': _iso(const Duration(hours: 2)),
        'updated_at': _iso(const Duration(hours: 2)),
        'remarks': '',
        'total_labour': 0,
        'total_parts': 0,
      },
      {
        'id': 2,
        'job_number': 'SJ-2026-00002',
        'vehicle_id': 5,
        'vehicle_number': 'KA-05-PQ-9901',
        'vehicle_model': 'BMW M5 Competition',
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'customer_phone': '+91 90001 22334',
        'service_type': 'Engine Repair',
        'complaint': 'Check engine light on, rough idling and low power.',
        'status': 'in_progress',
        'mechanic_id': 3,
        'mechanic_name': 'Ramesh Kumar',
        'mechanic_specialization': 'Engine & Transmission',
        'odometer_reading': 15700,
        'created_at': _iso(const Duration(hours: 26)),
        'updated_at': _iso(const Duration(hours: 1)),
        'remarks': '',
        'total_labour': 0,
        'total_parts': 0,
      },
      {
        'id': 3,
        'job_number': 'SJ-2026-00003',
        'vehicle_id': 3,
        'vehicle_number': 'KA-01-MJ-1234',
        'vehicle_model': 'Audi Q7',
        'customer_id': 3,
        'customer_name': 'Ananya Iyer',
        'customer_phone': '+91 98450 77889',
        'service_type': 'Brake Service',
        'complaint': 'Brake pedal feels spongy, front brake noise on braking.',
        'status': 'in_progress',
        'mechanic_id': 4,
        'mechanic_name': 'Suresh Patil',
        'mechanic_specialization': 'Brakes & Suspension',
        'odometer_reading': 27600,
        'created_at': _iso(const Duration(hours: 30)),
        'updated_at': _iso(const Duration(hours: 2)),
        'remarks': '',
        'total_labour': 0,
        'total_parts': 0,
      },
      {
        'id': 4,
        'job_number': 'SJ-2026-00004',
        'vehicle_id': 2,
        'vehicle_number': 'KL-07-BV-4455',
        'vehicle_model': 'Mercedes-Benz GLC 300',
        'customer_id': 2,
        'customer_name': 'Karan Mehta',
        'customer_phone': '+91 99871 44556',
        'service_type': 'AC Service',
        'complaint': 'AC not cooling enough, weak airflow.',
        'status': 'qc_pending',
        'mechanic_id': 3,
        'mechanic_name': 'Ramesh Kumar',
        'mechanic_specialization': 'Engine & Transmission',
        'odometer_reading': 18300,
        'created_at': _iso(const Duration(hours: 50)),
        'updated_at': _iso(const Duration(minutes: 45)),
        'remarks': '',
        'total_labour': 0,
        'total_parts': 0,
      },
      {
        'id': 5,
        'job_number': 'SJ-2026-00005',
        'vehicle_id': 4,
        'vehicle_number': 'TS-09-ER-7788',
        'vehicle_model': 'Range Rover Sport HSE',
        'customer_id': 5,
        'customer_name': 'Farah Khan',
        'customer_phone': '+91 98765 43210',
        'service_type': 'Periodic Maintenance',
        'complaint': 'Oil change plus a full check-up before a long trip.',
        'status': 'ready_for_bill',
        'mechanic_id': 4,
        'mechanic_name': 'Suresh Patil',
        'mechanic_specialization': 'Brakes & Suspension',
        'odometer_reading': 9100,
        'created_at': _iso(const Duration(hours: 74)),
        'updated_at': _iso(const Duration(minutes: 30)),
        'remarks': '',
        'total_labour': 2500,
        'total_parts': 3530,
      },
      {
        'id': 6,
        'job_number': 'SJ-2026-00006',
        'vehicle_id': 6,
        'vehicle_number': 'KA-05-PQ-9902',
        'vehicle_model': 'Porsche Cayenne S',
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'customer_phone': '+91 90001 22334',
        'service_type': 'Periodic Maintenance',
        'complaint': 'Routine annual maintenance and software update.',
        'status': 'ready_for_bill',
        'mechanic_id': 3,
        'mechanic_name': 'Ramesh Kumar',
        'mechanic_specialization': 'Engine & Transmission',
        'odometer_reading': 6800,
        'created_at': _iso(const Duration(hours: 96)),
        'updated_at': _iso(const Duration(minutes: 20)),
        'remarks': '',
        'total_labour': 3000,
        'total_parts': 12000,
      },
      {
        'id': 7,
        'job_number': 'SJ-2026-00007',
        'vehicle_id': 2,
        'vehicle_number': 'KL-07-BV-4455',
        'vehicle_model': 'Mercedes-Benz GLC 300',
        'customer_id': 2,
        'customer_name': 'Karan Mehta',
        'customer_phone': '+91 99871 44556',
        'service_type': 'Accident Repair',
        'complaint': 'Rear bumper dent and paint work needed.',
        'status': 'ready_for_delivery',
        'mechanic_id': 4,
        'mechanic_name': 'Suresh Patil',
        'mechanic_specialization': 'Brakes & Suspension',
        'odometer_reading': 18350,
        'created_at': _iso(const Duration(hours: 120)),
        'updated_at': _iso(const Duration(hours: 3)),
        'remarks': '',
        'total_labour': 9500,
        'total_parts': 7000,
      },
      {
        'id': 8,
        'job_number': 'SJ-2026-00008',
        'vehicle_id': 5,
        'vehicle_number': 'KA-05-PQ-9901',
        'vehicle_model': 'BMW M5 Competition',
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'customer_phone': '+91 90001 22334',
        'service_type': 'Wheel Alignment',
        'complaint': 'Pulls to the left, tyres wearing unevenly.',
        'status': 'delivered',
        'mechanic_id': 3,
        'mechanic_name': 'Ramesh Kumar',
        'mechanic_specialization': 'Engine & Transmission',
        'odometer_reading': 15650,
        'created_at': _iso(const Duration(days: 3)),
        'updated_at': _iso(const Duration(days: 2)),
        'remarks': '',
        'total_labour': 2500,
        'total_parts': 4000,
      },
      {
        'id': 9,
        'job_number': 'SJ-2026-00009',
        'vehicle_id': 3,
        'vehicle_number': 'KA-01-MJ-1234',
        'vehicle_model': 'Audi Q7',
        'customer_id': 3,
        'customer_name': 'Ananya Iyer',
        'customer_phone': '+91 98450 77889',
        'service_type': 'Engine Repair',
        'complaint': 'Timing chain noise, intermittent power loss.',
        'status': 'ready_for_delivery',
        'mechanic_id': 4,
        'mechanic_name': 'Suresh Patil',
        'mechanic_specialization': 'Brakes & Suspension',
        'odometer_reading': 27800,
        'created_at': _iso(const Duration(days: 4)),
        'updated_at': _iso(const Duration(hours: 6)),
        'remarks': '',
        'total_labour': 6000,
        'total_parts': 6500,
      },
      {
        'id': 10,
        'job_number': 'SJ-2026-00010',
        'vehicle_id': 4,
        'vehicle_number': 'TS-09-ER-7788',
        'vehicle_model': 'Range Rover Sport HSE',
        'customer_id': 5,
        'customer_name': 'Farah Khan',
        'customer_phone': '+91 98765 43210',
        'service_type': 'Body & Paint',
        'complaint': 'Door scratch repair and front bumper repaint.',
        'status': 'delivered',
        'mechanic_id': 3,
        'mechanic_name': 'Ramesh Kumar',
        'mechanic_specialization': 'Engine & Transmission',
        'odometer_reading': 8600,
        'created_at': _iso(const Duration(days: 7)),
        'updated_at': _iso(const Duration(days: 6)),
        'remarks': '',
        'total_labour': 16000,
        'total_parts': 16000,
      },
      {
        'id': 11,
        'job_number': 'SJ-2026-00011',
        'vehicle_id': 6,
        'vehicle_number': 'KA-05-PQ-9902',
        'vehicle_model': 'Porsche Cayenne S',
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'customer_phone': '+91 90001 22334',
        'service_type': 'Wheel Alignment',
        'complaint': 'Steering wheel off-centre after hitting a pothole.',
        'status': 'delivered',
        'mechanic_id': 4,
        'mechanic_name': 'Suresh Patil',
        'mechanic_specialization': 'Brakes & Suspension',
        'odometer_reading': 6400,
        'created_at': _iso(const Duration(days: 13)),
        'updated_at': _iso(const Duration(days: 12)),
        'remarks': '',
        'total_labour': 2500,
        'total_parts': 12000,
      },
    ];
  }

  static List<Map<String, dynamic>> _buildWorks() {
    return [
      {
        'id': 1,
        'service_job_id': 2,
        'work_name': 'Diagnostic Scan',
        'description': 'Full OBD-II scan to read and clear fault codes.',
        'labour_charge': 800.0,
        'status': 'completed',
        'created_at': _iso(const Duration(hours: 5)),
      },
      {
        'id': 2,
        'service_job_id': 2,
        'work_name': 'Spark Plug Replacement',
        'description': 'Replaced all four spark plugs, checked ignition coils.',
        'labour_charge': 1200.0,
        'status': 'in_progress',
        'created_at': _iso(const Duration(hours: 2)),
      },
      {
        'id': 3,
        'service_job_id': 3,
        'work_name': 'Brake Pad Replacement',
        'description': 'Replaced front brake pads and resurfaced the discs.',
        'labour_charge': 1500.0,
        'status': 'in_progress',
        'created_at': _iso(const Duration(hours: 4)),
      },
      {
        'id': 4,
        'service_job_id': 4,
        'work_name': 'AC Gas Refill',
        'description': 'Evacuated old gas, leak tested and recharged with R-134a.',
        'labour_charge': 2000.0,
        'status': 'completed',
        'created_at': _iso(const Duration(hours: 20)),
      },
      {
        'id': 5,
        'service_job_id': 5,
        'work_name': 'Oil Change',
        'description': 'Drained old oil, replaced the oil filter and filled 5W-30.',
        'labour_charge': 800.0,
        'status': 'completed',
        'created_at': _iso(const Duration(hours: 10)),
      },
      {
        'id': 6,
        'service_job_id': 5,
        'work_name': 'Multi-Point Inspection',
        'description': 'Tyres, brakes, fluids, suspension and alignment check.',
        'labour_charge': 1700.0,
        'status': 'completed',
        'created_at': _iso(const Duration(hours: 8)),
      },
      {
        'id': 7,
        'service_job_id': 6,
        'work_name': 'Routine Maintenance',
        'description': 'Annual maintenance, software update and fluid top-ups.',
        'labour_charge': 3000.0,
        'status': 'completed',
        'created_at': _iso(const Duration(hours: 12)),
      },
      {
        'id': 8,
        'service_job_id': 7,
        'work_name': 'Bumper Repair & Paint',
        'description': 'Dent repair, filler work, base coat and clear coat.',
        'labour_charge': 6000.0,
        'status': 'completed',
        'created_at': _iso(const Duration(hours: 8)),
      },
      {
        'id': 9,
        'service_job_id': 7,
        'work_name': 'Paint Polishing',
        'description': 'Buff and polish the repaired panel to blend with paint.',
        'labour_charge': 3500.0,
        'status': 'completed',
        'created_at': _iso(const Duration(hours: 4)),
      },
    ];
  }

  static List<Map<String, dynamic>> _buildPartsUsed() {
    return [
      {
        'id': 1,
        'service_job_id': 2,
        'part_id': 6,
        'part_name': 'Spark Plugs (Set of 4)',
        'part_number': 'IGN-SPK-004',
        'unit': 'set',
        'quantity': 1,
        'price': 1350.0,
        'created_at': _iso(const Duration(hours: 2)),
      },
      {
        'id': 2,
        'service_job_id': 3,
        'part_id': 5,
        'part_name': 'Brake Pads (Front Set)',
        'part_number': 'BRK-PAD-012',
        'unit': 'set',
        'quantity': 1,
        'price': 1850.0,
        'created_at': _iso(const Duration(hours: 4)),
      },
      {
        'id': 3,
        'service_job_id': 5,
        'part_id': 1,
        'part_name': 'Engine Oil 5W-30 (1L)',
        'part_number': 'LUB-EO-5W30',
        'unit': 'L',
        'quantity': 5,
        'price': 650.0,
        'created_at': _iso(const Duration(hours: 10)),
      },
      {
        'id': 4,
        'service_job_id': 5,
        'part_id': 3,
        'part_name': 'Oil Filter',
        'part_number': 'FLT-OIL-003',
        'unit': 'pcs',
        'quantity': 1,
        'price': 280.0,
        'created_at': _iso(const Duration(hours: 10)),
      },
    ];
  }

  static List<Map<String, dynamic>> _buildBills() {
    return [
      {
        'id': 1,
        'invoice_number': 'INV-2026-0031',
        'service_job_id': 10,
        'job_number': 'SJ-2026-00010',
        'customer_id': 5,
        'customer_name': 'Farah Khan',
        'vehicle_number': 'TS-09-ER-7788',
        'labour_charge': 16000.0,
        'parts_charge': 16000.0,
        'tax': 0,
        'discount': 0,
        'total_amount': 32000.0,
        'amount_paid': 15000.0,
        'payment_status': 'partial',
        'payment_method': 'UPI',
        'created_at': _iso(const Duration(days: 6)),
        'payment_date': _iso(const Duration(days: 6)),
      },
      {
        'id': 2,
        'invoice_number': 'INV-2026-0032',
        'service_job_id': 11,
        'job_number': 'SJ-2026-00011',
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'vehicle_number': 'KA-05-PQ-9902',
        'labour_charge': 2500.0,
        'parts_charge': 12000.0,
        'tax': 0,
        'discount': 0,
        'total_amount': 14500.0,
        'amount_paid': 0,
        'payment_status': 'pending',
        'payment_method': null,
        'created_at': _iso(const Duration(days: 12)),
        'payment_date': null,
      },
      {
        'id': 3,
        'invoice_number': 'INV-2026-0033',
        'service_job_id': 8,
        'job_number': 'SJ-2026-00008',
        'customer_id': 4,
        'customer_name': 'Arjun Reddy',
        'vehicle_number': 'KA-05-PQ-9901',
        'labour_charge': 2500.0,
        'parts_charge': 4000.0,
        'tax': 0,
        'discount': 0,
        'total_amount': 6500.0,
        'amount_paid': 6500.0,
        'payment_status': 'paid',
        'payment_method': 'Card',
        'created_at': _iso(const Duration(days: 2)),
        'payment_date': _iso(const Duration(days: 2)),
      },
      {
        'id': 4,
        'invoice_number': 'INV-2026-0034',
        'service_job_id': 7,
        'job_number': 'SJ-2026-00007',
        'customer_id': 2,
        'customer_name': 'Karan Mehta',
        'vehicle_number': 'KL-07-BV-4455',
        'labour_charge': 9500.0,
        'parts_charge': 7000.0,
        'tax': 0,
        'discount': 0,
        'total_amount': 16500.0,
        'amount_paid': 16500.0,
        'payment_status': 'paid',
        'payment_method': 'Cash',
        'created_at': _iso(const Duration(hours: 3)),
        'payment_date': _iso(const Duration(hours: 3)),
      },
      {
        'id': 5,
        'invoice_number': 'INV-2026-0035',
        'service_job_id': 9,
        'job_number': 'SJ-2026-00009',
        'customer_id': 3,
        'customer_name': 'Ananya Iyer',
        'vehicle_number': 'KA-01-MJ-1234',
        'labour_charge': 6000.0,
        'parts_charge': 6500.0,
        'tax': 0,
        'discount': 0,
        'total_amount': 12500.0,
        'amount_paid': 12500.0,
        'payment_status': 'paid',
        'payment_method': 'UPI',
        'created_at': _iso(const Duration(hours: 6)),
        'payment_date': _iso(const Duration(hours: 6)),
      },
    ];
  }

  // ---------------------------------------------------------------------
  // Low-level mutations (called from DemoRepository)
  // ---------------------------------------------------------------------

  int nextCustomerId() => _nextCustomerId++;
  int nextVehicleId() => _nextVehicleId++;
  int nextStaffId() => _nextStaffId++;
  int nextPartId() => _nextPartId++;
  int nextJobId() => _nextJobId++;
  int nextWorkId() => _nextWorkId++;
  int nextPartUsedId() => _nextPartUsedId++;
  int nextBillId() => _nextBillId++;

  Map<String, dynamic>? findJob(int jobId) {
    for (final job in jobs) {
      if (job['id'] == jobId) return job;
    }
    return null;
  }

  Map<String, dynamic>? findCustomer(int customerId) {
    for (final customer in customers) {
      if (customer['id'] == customerId) return customer;
    }
    return null;
  }

  Map<String, dynamic>? findVehicle(int vehicleId) {
    for (final vehicle in vehicles) {
      if (vehicle['id'] == vehicleId) return vehicle;
    }
    return null;
  }

  Map<String, dynamic>? findStaff(int staffId) {
    for (final member in staff) {
      if (member['id'] == staffId) return member;
    }
    return null;
  }

  Map<String, dynamic>? findPart(int partId) {
    for (final part in spareParts) {
      if (part['id'] == partId) return part;
    }
    return null;
  }

  Map<String, dynamic>? findBill(int billId) {
    for (final bill in bills) {
      if (bill['id'] == billId) return bill;
    }
    return null;
  }
}
