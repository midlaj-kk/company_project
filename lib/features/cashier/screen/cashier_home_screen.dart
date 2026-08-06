import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/cashier_home_controller.dart';
import '../widgets/pending_payment_tile.dart';
import '../widgets/ready_for_billing_card.dart';

/// Cashier home screen — matches the Stitch "Cashier Home
/// Dashboard" design.
class CashierHomeScreen extends StatelessWidget {
  const CashierHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CashierHomeController()..loadHome(),
      child: const _CashierHomeView(),
    );
  }
}

class _CashierHomeView extends StatelessWidget {
  const _CashierHomeView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CashierHomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<CashierHomeController>().loadHome(),
          color: AppColors.limeAccent,
          backgroundColor: AppColors.surface,
          child: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.limeAccent),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Top bar ---
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.inputFill,
                            child:
                                Icon(Icons.person, color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cashier - Home',
                                    style: AppTextStyles.heading3),
                                Text('BILLING COUNTER',
                                    style: AppTextStyles.caption
                                        .copyWith(letterSpacing: 1)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.cardBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_outlined,
                                color: AppColors.textPrimary, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- Stat cards ---
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'READY FOR\nBILLING',
                              value: controller.readyForBilling.length
                                  .toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'PENDING\nPAYMENTS',
                              value: controller.pendingPayments.length
                                  .toString(),
                              valueColor: AppColors.amberAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'REVENUE\nTODAY',
                              value:
                                  '₹${controller.revenueToday.toStringAsFixed(0)}',
                              valueColor: AppColors.limeAccent,
                              isHighlighted: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // --- Ready for Billing ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ready for Billing',
                              style: AppTextStyles.heading3),
                          Text(
                            '${controller.readyForBilling.length} JOBS',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.limeAccent),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      controller.readyForBilling.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('No jobs ready for billing',
                                  style: AppTextStyles.bodySecondary),
                            )
                          : SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.readyForBilling.length,
                                itemBuilder: (context, index) {
                                  final job = controller.readyForBilling[index];
                                  return ReadyForBillingCard(
                                    jobNumber: job['job_number'] ?? '',
                                    customerName: job['customer_name'] ?? '',
                                    vehicleInfo:
                                        '${job['vehicle_number'] ?? ''} • ${job['service_type'] ?? ''}',
                                    onCreateBill: () => AppRouter.toCreateBill(
                                      context,
                                      jobId: job['id'],
                                      jobNumber: job['job_number'] ?? '',
                                      vehicleLabel: job['vehicle_number'] ?? '',
                                      vehicleModel: job['service_type'] ?? '',
                                      customerName: job['customer_name'] ?? '',
                                    ),
                                  );
                                },
                              ),
                            ),
                      const SizedBox(height: 24),

                      // --- Pending Payments ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pending Payments',
                              style: AppTextStyles.heading3),
                          TextButton(
                            onPressed: () =>
                                AppRouter.toPendingPayments(context),
                            child: const Text('SEE ALL',
                                style: TextStyle(color: AppColors.limeAccent)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      controller.pendingPayments.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('No pending payments',
                                  style: AppTextStyles.bodySecondary),
                            )
                          : Column(
                              children:
                                  controller.pendingPayments.map((bill) {
                                return PendingPaymentTile(
                                  customerName:
                                      bill['customer_name'] ?? '',
                                  invoiceNumber: bill['invoice_number'] ?? '',
                                  amount: (bill['total_amount'] as num?)
                                          ?.toStringAsFixed(0) ??
                                      '0',
                                  paymentStatus:
                                      bill['payment_status'] ?? 'pending',
                                  onTap: () => AppRouter.toRecordPayment(
                                    context,
                                    billId: bill['id'],
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const _CashierBottomNav(),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.limeAccent.withOpacity(0.12)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(letterSpacing: 0.3),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              fontSize: 18,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CashierBottomNav extends StatelessWidget {
  const _CashierBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => AppRouter.toCashierHome(context, replace: true),
            child: const Icon(Icons.grid_view_rounded,
                color: AppColors.limeAccent, size: 24),
          ),
          InkWell(
            onTap: () => AppRouter.toPendingPayments(context),
            child: const Icon(Icons.receipt_long_outlined,
                color: AppColors.textMuted, size: 24),
          ),
          InkWell(
            onTap: () => AppRouter.toDeliveryReady(context),
            child: const Icon(Icons.directions_car_outlined,
                color: AppColors.textMuted, size: 24),
          ),
          const Icon(Icons.calendar_today_outlined,
              color: AppColors.textMuted, size: 24),
          const Icon(Icons.settings_outlined, color: AppColors.textMuted, size: 24),
        ],
      ),
    );
  }
}