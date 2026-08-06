import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/animated_checkmark.dart';
import '../../../widgets/common/status_badge.dart';
import '../controller/create_service_job_controller.dart';

/// Full-screen confirmation shown right after a Service Job is
/// successfully created. Reads its data from the same
/// CreateServiceJobController used on the previous screen.
class JobCreationConfirmationScreen extends StatelessWidget {
  const JobCreationConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateServiceJobController>();
    final job = controller.createdJob;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- Top bar ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.person,
                        size: 18, color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const AnimatedCheckmark(),
                    const SizedBox(height: 20),
                    Text('Job Created', style: AppTextStyles.heading1),
                    const SizedBox(height: 8),
                    Text(
                      'Service Job ${job?['job_number'] ?? ''} has been '
                      'registered successfully.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 28),

                    // --- Vehicle details card ---
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('VEHICLE DETAILS',
                                  style: AppTextStyles.caption
                                      .copyWith(letterSpacing: 0.6)),
                              StatusBadge(status: job?['status'] ?? 'active'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.limeAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.directions_car,
                                    color: AppColors.limeAccent, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job?['vehicle_number'] ?? '',
                                      style: AppTextStyles.bodyRegular
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(job?['service_type'] ?? '',
                                        style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.divider, height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ESTIMATED COMPLETION',
                                      style: AppTextStyles.caption
                                          .copyWith(letterSpacing: 0.5)),
                                  const SizedBox(height: 2),
                                  Text('Today, 5:30 PM',
                                      style: AppTextStyles.bodyRegular
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Icon(Icons.chevron_right,
                                  color: AppColors.textMuted),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => AppRouter.toJobDetailAdvisor(
                          context,
                          jobId: job?['id'],
                        ),
                        child: const Text('View Job Details'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context
                              .read<CreateServiceJobController>()
                              .resetForNewJob();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.divider),
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Create Another Job',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AdvisorBottomNav(),
    );
  }
}

class _AdvisorBottomNav extends StatelessWidget {
  const _AdvisorBottomNav();

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
          Icon(Icons.grid_view_rounded, color: AppColors.textMuted, size: 24),
          Icon(Icons.build, color: AppColors.limeAccent, size: 24),
          Icon(Icons.directions_car_outlined,
              color: AppColors.textMuted, size: 24),
          Icon(Icons.calendar_today_outlined,
              color: AppColors.textMuted, size: 24),
          Icon(Icons.settings_outlined, color: AppColors.textMuted, size: 24),
        ],
      ),
    );
  }
}