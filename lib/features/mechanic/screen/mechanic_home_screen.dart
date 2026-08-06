import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/mechanic_home_controller.dart';
import '../widgets/mechanic_job_card.dart';

/// Mechanic home screen — matches the Stitch "Mechanic Home
/// Dashboard" design.
class MechanicHomeScreen extends StatelessWidget {
  const MechanicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MechanicHomeController()..loadJobs(),
      child: const _MechanicHomeView(),
    );
  }
}

class _MechanicHomeView extends StatelessWidget {
  const _MechanicHomeView();

  static const _tabs = [
    ('all', 'All'),
    ('waiting', 'Waiting'),
    ('in_progress', 'In Progress'),
    ('rework', 'Rework'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MechanicHomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<MechanicHomeController>().loadJobs(),
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
                          Text('Mechanic - Home', style: AppTextStyles.heading3),
                          Text('ENGINE & TRANSMISSION',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.limeAccent,
                                letterSpacing: 0.6,
                              )),
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
                        label: 'ASSIGNED TO ME',
                        value: controller.assignedCount
                            .toString()
                            .padLeft(2, '0'),
                        icon: Icons.build_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'COMPLETED TODAY',
                        value: controller.completedTodayCount
                            .toString()
                            .padLeft(2, '0'),
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

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
                            .read<MechanicHomeController>()
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
                const SizedBox(height: 20),

                Text('ACTIVE JOBS',
                    style: AppTextStyles.caption.copyWith(letterSpacing: 0.8)),
                const SizedBox(height: 10),

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
                    return MechanicJobCard(
                      jobNumber: job['job_number'] ?? '',
                      vehicleInfo: job['vehicle_number'] ?? '',
                      vehicleModel: job['service_type'] ?? '',
                      complaint: job['complaint'] ?? '',
                      status: job['status'] ?? 'waiting',
                      timeAgo: _timeAgo(job['created_at']),
                      onTap: () => AppRouter.toJobDetailMechanic(
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
      bottomNavigationBar: const _MechanicBottomNav(),
    );
  }

  String _timeAgo(String? isoDate) {
    if (isoDate == null) return '';
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ${diff.inMinutes % 60}m ago';
    return '${diff.inDays}d ago';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
                const SizedBox(height: 6),
                Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 26)),
              ],
            ),
          ),
          Icon(icon, color: AppColors.limeAccent, size: 22),
        ],
      ),
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