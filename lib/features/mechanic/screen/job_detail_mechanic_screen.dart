import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/status_badge.dart';
import '../controller/job_detail_mechanic_controller.dart';
import '../widgets/part_used_item.dart';
import '../widgets/service_work_item.dart';
import 'add_part_used_sheet.dart';
import 'add_service_work_sheet.dart';

/// Mechanic "Job Detail" screen.
///
/// Usage once routing is set up:
///   JobDetailMechanicScreen(jobId: job['id'])
class JobDetailMechanicScreen extends StatelessWidget {
  const JobDetailMechanicScreen({super.key, required this.jobId});

  final int jobId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobDetailMechanicController(jobId: jobId)..load(),
      child: const _JobDetailMechanicView(),
    );
  }
}

class _JobDetailMechanicView extends StatelessWidget {
  const _JobDetailMechanicView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<JobDetailMechanicController>();
    final job = controller.job;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.limeAccent),
              )
            : controller.errorMessage != null && job == null
                ? Center(
                    child: Text(controller.errorMessage!,
                        style: AppTextStyles.bodySecondary),
                  )
                : RefreshIndicator(
                    onRefresh: () =>
                        context.read<JobDetailMechanicController>().load(),
                    color: AppColors.limeAccent,
                    backgroundColor: AppColors.surface,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Header ---
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                icon: const Icon(Icons.arrow_back,
                                    color: AppColors.textPrimary),
                              ),
                              Expanded(
                                child: Text(
                                  job?['job_number'] ?? '',
                                  style: AppTextStyles.heading3,
                                ),
                              ),
                              StatusBadge(status: job?['status'] ?? ''),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- Vehicle info card ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _InfoLine(
                                  label: 'VEHICLE NUMBER',
                                  value: job?['vehicle_number'] ?? '',
                                  valueColor: AppColors.limeAccent,
                                ),
                                const SizedBox(height: 10),
                                _InfoLine(
                                  label: 'MODEL',
                                  value: job?['vehicle_model'] ??
                                      job?['service_type'] ??
                                      '',
                                ),
                                const SizedBox(height: 10),
                                _InfoLine(
                                  label: 'CUSTOMER',
                                  value: job?['customer_name'] ?? '',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // --- Reported issue banner ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.amberAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color:
                                      AppColors.amberAccent.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded,
                                        color: AppColors.amberAccent,
                                        size: 16),
                                    const SizedBox(width: 6),
                                    Text('REPORTED ISSUE',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.amberAccent,
                                          letterSpacing: 0.5,
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '"${job?['complaint'] ?? ''}"',
                                  style: AppTextStyles.bodyRegular.copyWith(
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Service Work ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Service Work',
                                  style: AppTextStyles.heading3),
                              TextButton.icon(
                                onPressed: () async {
                                  final added = await showModalBottomSheet<bool>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => AddServiceWorkSheet(
                                      jobId: controller.jobId,
                                      jobNumber: job?['job_number'] ?? '',
                                    ),
                                  );
                                  if (added == true && context.mounted) {
                                    context
                                        .read<JobDetailMechanicController>()
                                        .load();
                                  }
                                },
                                icon: const Icon(Icons.add,
                                    size: 16, color: AppColors.limeAccent),
                                label: const Text('ADD WORK',
                                    style:
                                        TextStyle(color: AppColors.limeAccent)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          if (controller.workItems.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('No work items added yet',
                                  style: AppTextStyles.bodySecondary),
                            )
                          else
                            ...controller.workItems.map((w) {
                              return ServiceWorkItem(
                                workName: w['work_name'] ?? '',
                                description: w['description'] ?? '',
                                labourCharge: (w['labour_charge'] as num?)
                                        ?.toStringAsFixed(0) ??
                                    '0',
                                status: w['status'] ?? 'pending',
                                onStatusTap: () => context
                                    .read<JobDetailMechanicController>()
                                    .toggleWorkStatus(w['id'], w['status']),
                              );
                            }),
                          const SizedBox(height: 16),

                          // --- Parts Used ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Parts Used', style: AppTextStyles.heading3),
                              TextButton.icon(
                                onPressed: () async {
                                  final added = await showModalBottomSheet<bool>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => AddPartUsedSheet(
                                      jobId: controller.jobId,
                                    ),
                                  );
                                  if (added == true && context.mounted) {
                                    context
                                        .read<JobDetailMechanicController>()
                                        .load();
                                  }
                                },
                                icon: const Icon(Icons.add,
                                    size: 16, color: AppColors.limeAccent),
                                label: const Text('ADD PART',
                                    style:
                                        TextStyle(color: AppColors.limeAccent)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          if (controller.partsUsed.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('No parts used yet',
                                  style: AppTextStyles.bodySecondary),
                            )
                          else
                            ...controller.partsUsed.map((p) {
                              return PartUsedItem(
                                partName: p['part_name'] ?? '',
                                quantity: (p['quantity'] as num?)
                                        ?.toStringAsFixed(0) ??
                                    '0',
                                unit: p['part_number'] ?? '',
                                price: ((p['price'] as num?) != null &&
                                        (p['quantity'] as num?) != null)
                                    ? ((p['price'] as num) *
                                            (p['quantity'] as num))
                                        .toStringAsFixed(0)
                                    : '0',
                                onDelete: () => context
                                    .read<JobDetailMechanicController>()
                                    .deletePart(p['id']),
                              );
                            }),
                          const SizedBox(height: 16),

                          // --- Totals ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _TotalBlock(
                                label: 'TOTAL LABOR',
                                value: controller.totalLabour
                                    .toStringAsFixed(0),
                              ),
                              Container(
                                  width: 1, height: 30, color: AppColors.divider),
                              _TotalBlock(
                                label: 'TOTAL PARTS',
                                value:
                                    controller.totalParts.toStringAsFixed(0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // --- Send for QC ---
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: controller.allWorkCompleted &&
                                      !controller.isSubmittingQc
                                  ? () => context
                                      .read<JobDetailMechanicController>()
                                      .sendForQualityCheck()
                                  : null,
                              icon: const Icon(Icons.fact_check_outlined,
                                  color: Colors.black, size: 18),
                              label: controller.isSubmittingQc
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.black),
                                    )
                                  : const Text('Send for Quality Check'),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              controller.allWorkCompleted
                                  ? 'Ready to send for quality check'
                                  : 'Complete all service work to proceed',
                              style: AppTextStyles.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: const _MechanicBottomNav(),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyRegular.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TotalBlock extends StatelessWidget {
  const _TotalBlock({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text('₹$value',
            style: const TextStyle(
                color: AppColors.limeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ],
    );
  }
}

class _MechanicBottomNav extends StatelessWidget {
  const _MechanicBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => AppRouter.toMechanicHome(context, replace: true),
            child: const _NavItem(icon: Icons.build, label: 'My Jobs', isActive: true),
          ),
          const _NavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Parts',
              isActive: false),
          InkWell(
            onTap: () => AppRouter.toMechanicProfile(context, replace: true),
            child: const _NavItem(
                icon: Icons.person_outline, label: 'Profile', isActive: false),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });
  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.limeAccent : AppColors.textMuted;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}