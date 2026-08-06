import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/quality_check_controller.dart';
import '../widgets/checklist_row.dart';

/// Admin "Quality Check" form for a single service job.
///
/// Usage once routing is set up:
///   QualityCheckScreen(serviceJobId: job['id'])
class QualityCheckScreen extends StatelessWidget {
  const QualityCheckScreen({super.key, required this.serviceJobId});

  final int serviceJobId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QualityCheckController(serviceJobId: serviceJobId)..load(),
      child: const _QualityCheckView(),
    );
  }
}

class _QualityCheckView extends StatelessWidget {
  const _QualityCheckView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<QualityCheckController>();
    final job = controller.job;

    if (controller.submittedSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quality check submitted')),
        );
        Navigator.of(context).maybePop();
      });
    }

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
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Admin - Quality Check',
                                            style: AppTextStyles.heading3),
                                        Text(
                                          job?['job_number'] ?? '',
                                          style: AppTextStyles.caption
                                              .copyWith(
                                                  color: AppColors.limeAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.inputFill,
                                    child: Icon(Icons.person,
                                        size: 16, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // --- Vehicle summary card ---
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.limeAccent
                                            .withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                          Icons.directions_car_filled,
                                          color: AppColors.limeAccent),
                                    ),
                                    const SizedBox(height: 14),
                                    _InfoLine(
                                      label: 'VEHICLE NUMBER',
                                      value: job?['vehicle_number'] ?? '',
                                      valueColor: AppColors.limeAccent,
                                    ),
                                    const SizedBox(height: 10),
                                    _InfoLine(
                                      label: 'BRAND/MODEL',
                                      value: job?['vehicle_model'] ??
                                          job?['service_type'] ??
                                          '',
                                    ),
                                    const SizedBox(height: 10),
                                    _InfoLine(
                                      label: 'CUSTOMER',
                                      value: job?['customer_name'] ?? '',
                                    ),
                                    const SizedBox(height: 10),
                                    _InfoLine(
                                      label: 'MECHANIC',
                                      value: job?['mechanic_name'] ?? '',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              Text(
                                'INSPECTION CHECKLIST',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.limeAccent,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 10),

                              ChecklistRow(
                                label: 'Brake Check',
                                selectedValue: controller.checklist['brake_check'],
                                onChanged: (v) => context
                                    .read<QualityCheckController>()
                                    .setChecklistValue('brake_check', v),
                              ),
                              ChecklistRow(
                                label: 'Engine Check',
                                selectedValue: controller.checklist['engine_check'],
                                onChanged: (v) => context
                                    .read<QualityCheckController>()
                                    .setChecklistValue('engine_check', v),
                              ),
                              ChecklistRow(
                                label: 'Oil Leakage Check',
                                selectedValue:
                                    controller.checklist['oil_leakage_check'],
                                options: const ['no_issue', 'issue_found', 'na'],
                                displayLabels: const [
                                  'NO ISSUE',
                                  'ISSUE',
                                  'N/A'
                                ],
                                onChanged: (v) => context
                                    .read<QualityCheckController>()
                                    .setChecklistValue(
                                        'oil_leakage_check', v),
                              ),
                              ChecklistRow(
                                label: 'AC Check',
                                selectedValue: controller.checklist['ac_check'],
                                onChanged: (v) => context
                                    .read<QualityCheckController>()
                                    .setChecklistValue('ac_check', v),
                              ),
                              ChecklistRow(
                                label: 'Tyre Check',
                                selectedValue: controller.checklist['tyre_check'],
                                onChanged: (v) => context
                                    .read<QualityCheckController>()
                                    .setChecklistValue('tyre_check', v),
                              ),
                              ChecklistRow(
                                label: 'Test Drive',
                                selectedValue: controller.checklist['test_drive'],
                                onChanged: (v) => context
                                    .read<QualityCheckController>()
                                    .setChecklistValue('test_drive', v),
                              ),

                              if (controller.errorMessage != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  controller.errorMessage!,
                                  style: const TextStyle(
                                      color: AppColors.statusError,
                                      fontSize: 13),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // --- Bottom action buttons ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: controller.isSubmitting
                                    ? null
                                    : () => context
                                        .read<QualityCheckController>()
                                        .submit('approved'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.statusSuccess,
                                  minimumSize: const Size.fromHeight(52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.check_circle_outline,
                                    color: Colors.black),
                                label: const Text('Approve',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: controller.isSubmitting
                                    ? null
                                    : () => context
                                        .read<QualityCheckController>()
                                        .submit('rework_required'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: AppColors.statusError),
                                  minimumSize: const Size.fromHeight(52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.replay,
                                    color: AppColors.statusError, size: 18),
                                label: const Text('Send for Rework',
                                    style: TextStyle(
                                        color: AppColors.statusError,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

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