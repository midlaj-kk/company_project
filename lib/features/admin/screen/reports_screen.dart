import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/reports_controller.dart';
import '../widgets/report_card.dart';

/// Admin "Reports" dashboard screen.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsController()..loadReports(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReportsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.limeAccent),
              )
            : RefreshIndicator(
                onRefresh: () => context.read<ReportsController>().loadReports(),
                color: AppColors.limeAccent,
                backgroundColor: AppColors.surface,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header ---
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.textPrimary),
                          ),
                          Expanded(
                            child: Text('Admin - Reports',
                                style: AppTextStyles.heading3),
                          ),
                          const Icon(Icons.calendar_today_outlined,
                              color: AppColors.textPrimary, size: 20),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // --- Date range chip ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('This Month',
                                style: AppTextStyles.bodySecondary),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down,
                                color: AppColors.textMuted, size: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'BUSINESS HEALTH',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.limeAccent,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Operational Overview',
                          style: AppTextStyles.heading1.copyWith(fontSize: 26)),
                      const SizedBox(height: 20),

                      if (controller.errorMessage != null) ...[
                        Text(controller.errorMessage!,
                            style: const TextStyle(
                                color: AppColors.statusError, fontSize: 13)),
                        const SizedBox(height: 12),
                      ],

                      ReportCard(
                        icon: Icons.show_chart,
                        iconColor: AppColors.statusSuccess,
                        title: 'Revenue Report',
                        value: '₹${controller.revenueThisMonth.toStringAsFixed(0)}',
                        subtitle: 'this month',
                      ),
                      ReportCard(
                        icon: Icons.verified_outlined,
                        iconColor: AppColors.statusSuccess,
                        title: 'Completed Services',
                        value: '${controller.completedServices} jobs',
                        subtitle: 'this month',
                      ),
                      ReportCard(
                        icon: Icons.people_outline,
                        iconColor: AppColors.limeAccent,
                        title: 'Mechanic Productivity',
                        value: controller.topMechanicName.isEmpty
                            ? 'No data'
                            : controller.topMechanicName,
                        subtitle: controller.topMechanicName.isEmpty
                            ? ''
                            : '${controller.topMechanicJobs} jobs completed',
                      ),
                      ReportCard(
                        icon: Icons.inventory_2_outlined,
                        iconColor: AppColors.limeAccent,
                        title: 'Spare Parts Usage',
                        value: controller.mostUsedPartName.isEmpty
                            ? 'No data'
                            : 'Most used: ${controller.mostUsedPartName}',
                        subtitle: 'this month',
                      ),
                      ReportCard(
                        icon: Icons.receipt_long_outlined,
                        iconColor: AppColors.amberAccent,
                        title: 'Pending Payments',
                        value:
                            '₹${controller.pendingPaymentsTotal.toStringAsFixed(0)}',
                        subtitle: 'action needed',
                        valueColor: AppColors.amberAccent,
                        onTap: () => AppRouter.toPendingPayments(context),
                      ),
                      ReportCard(
                        icon: Icons.warning_amber_rounded,
                        iconColor: AppColors.statusError,
                        title: 'Low Stock Report',
                        value: '${controller.lowStockCount} items critical',
                        subtitle: 'restock recommended',
                        valueColor: AppColors.statusError,
                        onTap: () => AppRouter.toInventory(context),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}