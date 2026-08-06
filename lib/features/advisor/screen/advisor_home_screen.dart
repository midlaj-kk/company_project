import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/advisor_home_controller.dart';
import '../widgets/advisor_job_card.dart';
import '../widgets/mini_stat_pill.dart';

/// Service Advisor home screen — matches the Stitch "Service Advisor
/// Home" design.
class AdvisorHomeScreen extends StatelessWidget {
  const AdvisorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdvisorHomeController()..loadJobs(),
      child: const _AdvisorHomeView(),
    );
  }
}

class _AdvisorHomeView extends StatelessWidget {
  const _AdvisorHomeView();

  static const _tabs = [
    ('all', 'All'),
    ('waiting', 'Waiting'),
    ('in_progress', 'In Progress'),
    ('qc_pending', 'QC Pending'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AdvisorHomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<AdvisorHomeController>().loadJobs(),
          color: AppColors.limeAccent,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
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
                      child: Icon(Icons.person, color: AppColors.textMuted),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Advisor - Home', style: AppTextStyles.heading3),
                          Text('FRONT DESK',
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

                // --- New Service Job CTA ---
                InkWell(
                  onTap: () => AppRouter.toCustomerList(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.limeAccent,
                          AppColors.limeAccent.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.black, size: 22),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'New Service Job',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Register a customer & create a job',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.65),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Stat pills ---
                Row(
                  children: [
                    Expanded(
                      child: MiniStatPill(
                        label: 'Waiting',
                        value: controller.waitingCount.toString(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MiniStatPill(
                        label: 'In Progress',
                        value: controller.inProgressCount.toString(),
                        isHighlighted: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MiniStatPill(
                        label: 'QC Pending',
                        value: controller.qcPendingCount.toString(),
                        valueColor: AppColors.amberAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Today's Jobs header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today's Jobs", style: AppTextStyles.heading3),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All',
                          style: TextStyle(color: AppColors.limeAccent)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // --- Filter tabs ---
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final (value, label) = _tabs[index];
                      final isSelected = value == controller.selectedFilter;
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) => context
                            .read<AdvisorHomeController>()
                            .setFilter(value),
                        backgroundColor: AppColors.cardBackground,
                        selectedColor: AppColors.limeAccent,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                        showCheckmark: false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // --- Job list ---
                if (controller.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.limeAccent),
                    ),
                  )
                else if (controller.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(controller.errorMessage!,
                        style: AppTextStyles.bodySecondary),
                  )
                else if (controller.jobs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text('No jobs found',
                          style: AppTextStyles.bodySecondary),
                    ),
                  )
                else
                  ...controller.jobs.map((job) {
                    return AdvisorJobCard(
                      jobNumber: job['job_number'] ?? '',
                      vehicleInfo: job['vehicle_number'] ?? '',
                      customerName: job['customer_name'] ?? '',
                      status: job['status'] ?? 'waiting',
                      mechanicName: job['mechanic_name'],
                      onTap: () => AppRouter.toJobDetailAdvisor(
                        context,
                        jobId: job['id'],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const _AdvisorBottomNav(),
    );
  }
}

/// Bottom navigation bar for the Advisor role.
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
          InkWell(
            onTap: () => AppRouter.toAdvisorHome(context, replace: true),
            child: const Icon(Icons.grid_view_rounded,
                color: AppColors.limeAccent, size: 24),
          ),
          InkWell(
            onTap: () => AppRouter.toCustomerList(context),
            child: const Icon(Icons.people_outline,
                color: AppColors.textMuted, size: 24),
          ),
          const Icon(Icons.directions_car_outlined,
              color: AppColors.textMuted, size: 24),
          const Icon(Icons.build_outlined, color: AppColors.textMuted, size: 24),
          const Icon(Icons.settings_outlined, color: AppColors.textMuted, size: 24),
        ],
      ),
    );
  }
}