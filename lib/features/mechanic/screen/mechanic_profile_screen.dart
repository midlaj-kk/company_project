import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/mechanic_profile_controller.dart';

/// Mechanic "Profile" screen.
class MechanicProfileScreen extends StatelessWidget {
  const MechanicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MechanicProfileController()..load(),
      child: const _MechanicProfileView(),
    );
  }
}

class _MechanicProfileView extends StatelessWidget {
  const _MechanicProfileView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MechanicProfileController>();
    final profile = controller.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.limeAccent),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MECHANIC - PROFILE',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.limeAccent,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.cardBackground,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.settings_outlined,
                              color: AppColors.textPrimary, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- Avatar + name ---
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.limeAccent, width: 2),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: AppColors.inputFill,
                                  child: Icon(Icons.person,
                                      size: 40, color: AppColors.textMuted),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: AppColors.statusSuccess,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.background, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            profile?['name'] ?? '',
                            style: AppTextStyles.heading2,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.limeAccent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              (profile?['specialization'] ?? 'MECHANIC')
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.limeAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // --- Stat cards ---
                    _StatRow(
                      icon: Icons.emoji_events_outlined,
                      label: 'JOBS COMPLETED THIS MONTH',
                      value: controller.jobsCompletedThisMonth.toString(),
                    ),
                    const SizedBox(height: 12),
                    _StatRow(
                      icon: Icons.access_time,
                      label: 'AVG. COMPLETION TIME',
                      value: controller.avgCompletionTime,
                    ),
                    const SizedBox(height: 24),

                    // --- Settings list ---
                    _SettingsTile(
                      icon: Icons.lock_reset_outlined,
                      label: 'Change Password',
                      onTap: () {
                        // TODO: navigate to change password screen
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notification Settings',
                      onTap: () {
                        // TODO: navigate to notification settings
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () {
                        // TODO: navigate to help & support
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.logout,
                      label: 'Logout',
                      isDestructive: true,
                      onTap: () async {
                        await context.read<MechanicProfileController>().logout();
                        if (context.mounted) AppRouter.toLogin(context);
                      },
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const _MechanicBottomNav(),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.limeAccent, size: 16),
              const SizedBox(width: 8),
              Text(label,
                  style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.heading2),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.statusError : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (isDestructive
                        ? AppColors.statusError
                        : AppColors.limeAccent)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: AppTextStyles.bodyRegular.copyWith(color: color)),
            ),
            Icon(
              isDestructive ? Icons.arrow_forward : Icons.chevron_right,
              color: color,
              size: 18,
            ),
          ],
        ),
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
            child: const _NavItem(icon: Icons.build, label: 'My Jobs', isActive: false),
          ),
          const _NavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Parts',
              isActive: false),
          InkWell(
            onTap: () => AppRouter.toMechanicProfile(context, replace: true),
            child: const _NavItem(
                icon: Icons.person_outline, label: 'Profile', isActive: true),
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