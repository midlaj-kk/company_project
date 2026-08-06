import 'package:auto_care_app/widgets/common/role_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/status_badge.dart';
import '../controller/job_detail_advisor_controller.dart';
import '../widgets/status_progress_tracker.dart';

/// Advisor "Job Detail" screen.
///
/// Usage once routing is set up:
///   JobDetailAdvisorScreen(jobId: job['id'])
class JobDetailAdvisorScreen extends StatelessWidget {
  const JobDetailAdvisorScreen({super.key, required this.jobId});

  final int jobId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobDetailAdvisorController(jobId: jobId)..load(),
      child: const _JobDetailView(),
    );
  }
}

class _JobDetailView extends StatelessWidget {
  const _JobDetailView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<JobDetailAdvisorController>();
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
                    onRefresh: () => context.read<JobDetailAdvisorController>().load(),
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
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                icon: const Icon(Icons.arrow_back,
                                    color: AppColors.textPrimary),
                              ),
                              Expanded(
                                child: Text('Advisor - Job Detail',
                                    style: AppTextStyles.heading3),
                              ),
                              StatusBadge(status: job?['status'] ?? ''),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- Vehicle number card ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('VEHICLE NUMBER',
                                          style: AppTextStyles.caption
                                              .copyWith(letterSpacing: 0.5)),
                                      const SizedBox(height: 4),
                                      Text(
                                        job?['vehicle_number'] ?? '',
                                        style: AppTextStyles.heading3,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                          job?['vehicle_model'] ??
                                              job?['service_type'] ??
                                              '',
                                          style: AppTextStyles.bodySecondary),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFill,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.directions_car,
                                      color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // --- Customer card ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('CUSTOMER',
                                          style: AppTextStyles.caption
                                              .copyWith(letterSpacing: 0.5)),
                                      const SizedBox(height: 4),
                                      Text(job?['customer_name'] ?? '',
                                          style: AppTextStyles.heading3),
                                      const SizedBox(height: 2),
                                      Text(job?['customer_phone'] ?? '',
                                          style: AppTextStyles.bodySecondary),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: AppColors.limeAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.call,
                                      color: Colors.black, size: 20),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Status progress tracker ---
                          StatusProgressTracker(
                              currentStatus: job?['status'] ?? 'waiting'),
                          const SizedBox(height: 24),

                          // --- Assigned mechanic ---
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.inputFill,
                                  child: Icon(Icons.person,
                                      color: AppColors.textMuted),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job?['mechanic_name'] ?? 'Unassigned',
                                        style: AppTextStyles.bodyRegular
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          job?['mechanic_specialization'] ??
                                              '',
                                          style: AppTextStyles.caption),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      _showMechanicPicker(context, controller),
                                  child: const Text('Change Mechanic',
                                      style: TextStyle(
                                          color: AppColors.limeAccent)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- Tabs ---
                          Row(
                            children: [
                              _TabButton(
                                label: 'Complaint',
                                isSelected:
                                    controller.selectedTab == 'complaint',
                                onTap: () => context
                                    .read<JobDetailAdvisorController>()
                                    .setTab('complaint'),
                              ),
                              const SizedBox(width: 20),
                              _TabButton(
                                label: 'Work Done',
                                isSelected:
                                    controller.selectedTab == 'work_done',
                                onTap: () => context
                                    .read<JobDetailAdvisorController>()
                                    .setTab('work_done'),
                              ),
                              const SizedBox(width: 20),
                              _TabButton(
                                label: 'Parts Used',
                                isSelected:
                                    controller.selectedTab == 'parts_used',
                                onTap: () => context
                                    .read<JobDetailAdvisorController>()
                                    .setTab('parts_used'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- Tab content ---
                          if (controller.selectedTab == 'complaint')
                            _ComplaintTab(job: job)
                          else if (controller.selectedTab == 'work_done')
                            _PlaceholderTab(
                                message:
                                    'Service work items will appear here.')
                          else
                            _PlaceholderTab(
                                message: 'Parts used will appear here.'),

                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showStatusPicker(context),
                              icon: const Icon(Icons.refresh,
                                  color: Colors.black, size: 18),
                              label: const Text('Update Status'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: const RoleBottomNav(role: 'advisor', activeIndex: 1),
    );
  }

  void _showMechanicPicker(
    BuildContext context,
    JobDetailAdvisorController controller,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('SELECT MECHANIC',
                  style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
            ),
            if (controller.mechanics.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('No mechanics available',
                    style: AppTextStyles.bodySecondary),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.mechanics.length,
                  itemBuilder: (_, index) {
                    final mechanic = controller.mechanics[index];
                    return ListTile(
                      title: Text(
                        mechanic['name'] ?? '',
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        mechanic['specialization'] ?? '',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        controller.changeMechanic(mechanic['id']);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker(BuildContext context) {
    const statuses = [
      ('waiting', 'Waiting'),
      ('in_progress', 'In Progress'),
      ('qc_pending', 'QC Pending'),
      ('ready_for_bill', 'Ready for Bill'),
      ('ready_for_delivery', 'Ready for Delivery'),
      ('delivered', 'Delivered'),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('UPDATE STATUS',
                  style: AppTextStyles.caption.copyWith(letterSpacing: 1)),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: statuses.length,
                itemBuilder: (_, index) {
                  final (value, label) = statuses[index];
                  return ListTile(
                    title: Text(
                      label,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      context.read<JobDetailAdvisorController>().updateStatus(value);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ComplaintTab extends StatelessWidget {
  const _ComplaintTab({required this.job});
  final Map<String, dynamic>? job;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PRIMARY CONCERN',
                  style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
              const SizedBox(height: 6),
              Text(job?['complaint'] ?? '',
                  style: AppTextStyles.bodyRegular),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatBox(
                label: 'SERVICE TYPE',
                value: job?['service_type'] ?? '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatBox(
                label: 'ODOMETER',
                value: '${job?['odometer_reading'] ?? 0} km',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.limeAccent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  job?['remarks'] ??
                      'No additional notes recorded for this job.',
                  style: AppTextStyles.caption.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: AppColors.limeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Text(message, style: AppTextStyles.bodySecondary),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.limeAccent : AppColors.textMuted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          if (isSelected)
            Container(width: 24, height: 2, color: AppColors.limeAccent),
        ],
      ),
    );
  }
}
