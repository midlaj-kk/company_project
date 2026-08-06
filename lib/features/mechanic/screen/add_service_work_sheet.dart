import 'package:auto_care_app/features/mechanic/controller/add_service_work_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/app_button.dart';

/// Bottom sheet form for adding a Service Work item to a job.
///
/// Usage:
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     backgroundColor: Colors.transparent,
///     builder: (_) => AddServiceWorkSheet(jobId: jobId, jobNumber: jobNumber),
///   );
/// On success, pop the sheet with `true` so the caller can refresh
/// the job's work list.
class AddServiceWorkSheet extends StatelessWidget {
  const AddServiceWorkSheet({
    super.key,
    required this.jobId,
    required this.jobNumber,
  });

  final int jobId;
  final String jobNumber;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddServiceWorkController(jobId: jobId),
      child: _AddServiceWorkView(jobNumber: jobNumber),
    );
  }
}

class _AddServiceWorkView extends StatelessWidget {
  const _AddServiceWorkView({required this.jobNumber});
  final String jobNumber;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddServiceWorkController>();

    if (controller.addedSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).pop(true);
      });
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Sheet handle ---
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // --- Mini header ---
              Center(
                child: Column(
                  children: [
                    Text(
                      'AUTOCARE PRO',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.limeAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('Job ID: $jobNumber', style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text('Add Work Item', style: AppTextStyles.heading2),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Enter details for the additional service performed.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),
              ),
              const SizedBox(height: 24),

              _FieldLabel('Work Name'),
              TextField(
                controller: controller.workNameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'e.g. Oil Filter Replacement',
                  suffixIcon:
                      Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 18),
                ),
              ),
              const SizedBox(height: 16),

              _FieldLabel('Description'),
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Provide details about the work performed...',
                ),
              ),
              const SizedBox(height: 16),

              _FieldLabel('Labour Charge'),
              TextField(
                controller: controller.labourChargeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  prefixIcon:
                      Icon(Icons.currency_rupee, color: AppColors.limeAccent, size: 18),
                  suffixIcon:
                      Icon(Icons.calculate_outlined, color: AppColors.textMuted, size: 18),
                ),
              ),

              if (controller.errorMessage != null) ...[
                const SizedBox(height: 14),
                Text(
                  controller.errorMessage!,
                  style: const TextStyle(color: AppColors.statusError, fontSize: 13),
                ),
              ],

              const SizedBox(height: 24),
              AppButton(
                label: 'Add Work',
                icon: Icons.add_circle_outline,
                isLoading: controller.isSubmitting,
                onPressed: () =>
                    context.read<AddServiceWorkController>().submit(),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('CANCEL',
                      style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.limeAccent,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}