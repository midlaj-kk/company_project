import 'package:flutter/material.dart';

import '../../features/admin/screen/add_mechanic_screen.dart';
import '../../features/admin/screen/admin_dashboard_screen.dart';
import '../../features/admin/screen/inventory_list_screen.dart';
import '../../features/admin/screen/quality_check_screen.dart';
import '../../features/admin/screen/reports_screen.dart';
import '../../features/admin/screen/staff_management_screen.dart';
import '../../features/admin/screen/stock_history_screen.dart';
import '../../features/advisor/screen/add_customer_screen.dart';
import '../../features/advisor/screen/advisor_home_screen.dart';
import '../../features/advisor/screen/create_service_job_screen.dart';
import '../../features/advisor/screen/customer_list_screen.dart';
import '../../features/advisor/screen/job_detail_advisor_screen.dart';
import '../../features/advisor/screen/vehicle_detail_screen.dart';
import '../../features/auth/screen/login_screen.dart';
import '../../features/cashier/screen/cashier_home_screen.dart';
import '../../features/cashier/screen/create_bill_screen.dart';
import '../../features/cashier/screen/delivery_ready_screen.dart';
import '../../features/cashier/screen/pending_payments_screen.dart';
import '../../features/cashier/screen/record_payment_screen.dart';
import '../../features/mechanic/screen/job_detail_mechanic_screen.dart';
import '../../features/mechanic/screen/mechanic_home_screen.dart';
import '../../features/mechanic/screen/mechanic_profile_screen.dart';

/// Central navigation helper. Every screen in the app is reached
/// through one of the static methods below, so navigation stays
/// consistent across roles and screens never need to know each
/// other's constructors.
class AppRouter {
  AppRouter._();

  /// Routes to the role's home screen after login, clearing the
  /// entire back stack so the back button cannot return to login.
  static void afterLogin(BuildContext context, String role) {
    resetToRoleHome(context, _homeForRole(role));
  }

  /// Returns the home screen for a role string (defaults to Admin).
  static Widget _homeForRole(String role) {
    return switch (role) {
      'service_advisor' => const AdvisorHomeScreen(),
      'mechanic' => const MechanicHomeScreen(),
      'cashier' => const CashierHomeScreen(),
      _ => const AdminDashboardScreen(),
    };
  }

  /// Bottom-nav "Home" taps: reset the entire stack to the given
  /// home screen. This prevents the bug where tapping the active tab
  /// stacks a second copy of the home screen on top of the current
  /// one (so the back button returns to a stale duplicate).
  static void resetToRoleHome(BuildContext context, Widget screen) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  /// Bottom-nav "Home" tap for the Admin role.
  static void resetToAdminHome(BuildContext context) =>
      resetToRoleHome(context, const AdminDashboardScreen());

  /// Bottom-nav "Home" tap for the Advisor role.
  static void resetToAdvisorHome(BuildContext context) =>
      resetToRoleHome(context, const AdvisorHomeScreen());

  /// Bottom-nav "Home" tap for the Cashier role.
  static void resetToCashierHome(BuildContext context) =>
      resetToRoleHome(context, const CashierHomeScreen());

  /// Bottom-nav "My Jobs" tap for the Mechanic role.
  static void resetToMechanicHome(BuildContext context) =>
      resetToRoleHome(context, const MechanicHomeScreen());

  /// Bottom-nav "Profile" tap for the Mechanic role.
  static void resetToMechanicProfile(BuildContext context) =>
      resetToRoleHome(context, const MechanicProfileScreen());

  // -------------------------------------------------------------
  // Auth
  // -------------------------------------------------------------

  static void toLogin(BuildContext context, {bool replace = false}) {
    if (replace) {
      // Used after logout / on splash: wipe the whole stack so the
      // back button cannot return to a logged-in screen.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      _push(context, const LoginScreen());
    }
  }

  // -------------------------------------------------------------
  // Admin
  // -------------------------------------------------------------

  static void toAdminDashboard(BuildContext context, {bool replace = false}) {
    _push(context, const AdminDashboardScreen(), replace: replace);
  }

  static void toAddMechanic(BuildContext context) {
    _push(context, const AddMechanicScreen());
  }

  static void toInventory(BuildContext context) {
    _push(context, const InventoryListScreen());
  }

  static void toReports(BuildContext context) {
    _push(context, const ReportsScreen());
  }

  static void toQualityCheck(BuildContext context, {required int serviceJobId}) {
    _push(context, QualityCheckScreen(serviceJobId: serviceJobId));
  }

  static void toStaffManagement(BuildContext context) {
    _push(context, const StaffManagementScreen());
  }

  static void toStockHistory(BuildContext context, {required int partId}) {
    _push(context, StockHistoryScreen(partId: partId));
  }

  // -------------------------------------------------------------
  // Service Advisor
  // -------------------------------------------------------------

  static void toAdvisorHome(BuildContext context, {bool replace = false}) {
    _push(context, const AdvisorHomeScreen(), replace: replace);
  }

  static void toCustomerList(BuildContext context) {
    _push(context, const CustomerListScreen());
  }

  static void toJobDetailAdvisor(BuildContext context, {required int jobId}) {
    _push(context, JobDetailAdvisorScreen(jobId: jobId));
  }

  static void toAddCustomer(BuildContext context) {
    _push(context, const AddCustomerScreen());
  }

  static void toVehicleDetail(BuildContext context, {required int vehicleId}) {
    _push(context, VehicleDetailScreen(vehicleId: vehicleId));
  }

  static void toCreateServiceJob(
    BuildContext context, {
    required int vehicleId,
    required String vehicleLabel,
    required String customerName,
  }) {
    _push(
      context,
      CreateServiceJobScreen(
        vehicleId: vehicleId,
        vehicleLabel: vehicleLabel,
        customerName: customerName,
      ),
    );
  }

  // -------------------------------------------------------------
  // Mechanic
  // -------------------------------------------------------------

  static void toMechanicHome(BuildContext context, {bool replace = false}) {
    _push(context, const MechanicHomeScreen(), replace: replace);
  }

  static void toMechanicProfile(BuildContext context, {bool replace = false}) {
    _push(context, const MechanicProfileScreen(), replace: replace);
  }

  static void toJobDetailMechanic(BuildContext context, {required int jobId}) {
    _push(context, JobDetailMechanicScreen(jobId: jobId));
  }

  // -------------------------------------------------------------
  // Cashier
  // -------------------------------------------------------------

  static void toCashierHome(BuildContext context, {bool replace = false}) {
    _push(context, const CashierHomeScreen(), replace: replace);
  }

  static void toPendingPayments(BuildContext context) {
    _push(context, const PendingPaymentsScreen());
  }

  static void toDeliveryReady(BuildContext context) {
    _push(context, const DeliveryReadyScreen());
  }

  static void toCreateBill(
    BuildContext context, {
    required int jobId,
    required String jobNumber,
    required String vehicleLabel,
    required String vehicleModel,
    required String customerName,
  }) {
    _push(
      context,
      CreateBillScreen(
        jobId: jobId,
        jobNumber: jobNumber,
        vehicleLabel: vehicleLabel,
        vehicleModel: vehicleModel,
        customerName: customerName,
      ),
    );
  }

  static void toRecordPayment(BuildContext context, {required int billId}) {
    _push(context, RecordPaymentScreen(billId: billId));
  }

  // -------------------------------------------------------------

  static void _push(BuildContext context, Widget screen, {bool replace = false}) {
    final route = MaterialPageRoute<void>(builder: (_) => screen);
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }
}
