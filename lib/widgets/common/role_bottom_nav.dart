import 'package:flutter/material.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

/// Reusable pill-style bottom navigation used by every role home screen
/// and the role sub-screens. Replaces the old per-screen duplicated nav
/// bars, which rendered dead tabs (search, settings, calendar, parts)
/// with no destination behind them.
///
/// Only tabs with a real screen are shown:
///   admin   -> Home, Staff, Reports
///   advisor -> Home, Customers
///   mechanic-> My Jobs, Profile
///   cashier -> Home, Payments, Delivery
class RoleBottomNav extends StatelessWidget {
  const RoleBottomNav({
    super.key,
    required this.role,
    this.activeIndex = 0,
  });

  /// 'admin' | 'advisor' | 'mechanic' | 'cashier'
  final String role;

  /// Index of the tab that represents the current screen.
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final items = _itemsForRole(context);

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
          for (var i = 0; i < items.length; i++)
            _RoleNavItem(
              icon: items[i].icon,
              label: items[i].label,
              isActive: i == activeIndex,
              onTap: items[i].onTap,
            ),
        ],
      ),
    );
  }

  List<_RoleNavItemData> _itemsForRole(BuildContext context) {
    switch (role) {
      case 'advisor':
        return [
          _RoleNavItemData(
            icon: Icons.grid_view_rounded,
            onTap: () => AppRouter.resetToAdvisorHome(context),
          ),
          _RoleNavItemData(
            icon: Icons.people_outline,
            onTap: () => AppRouter.toCustomerList(context),
          ),
        ];
      case 'mechanic':
        return [
          _RoleNavItemData(
            icon: Icons.build_rounded,
            label: 'My Jobs',
            onTap: () => AppRouter.resetToMechanicHome(context),
          ),
          _RoleNavItemData(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () => AppRouter.resetToMechanicProfile(context),
          ),
        ];
      case 'cashier':
        return [
          _RoleNavItemData(
            icon: Icons.grid_view_rounded,
            onTap: () => AppRouter.resetToCashierHome(context),
          ),
          _RoleNavItemData(
            icon: Icons.receipt_outlined,
            onTap: () => AppRouter.toPendingPayments(context),
          ),
          _RoleNavItemData(
            icon: Icons.directions_car_outlined,
            onTap: () => AppRouter.toDeliveryReady(context),
          ),
        ];
      case 'admin':
      default:
        return [
          _RoleNavItemData(
            icon: Icons.grid_view_rounded,
            onTap: () => AppRouter.resetToAdminHome(context),
          ),
          _RoleNavItemData(
            icon: Icons.people_outline,
            onTap: () => AppRouter.toStaffManagement(context),
          ),
          _RoleNavItemData(
            icon: Icons.bar_chart_outlined,
            onTap: () => AppRouter.toReports(context),
          ),
        ];
    }
  }
}

class _RoleNavItemData {
  const _RoleNavItemData({required this.icon, required this.onTap, this.label});

  final IconData icon;
  final String? label;
  final VoidCallback onTap;
}

class _RoleNavItem extends StatelessWidget {
  const _RoleNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.label,
  });

  final IconData icon;
  final String? label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.limeAccent : AppColors.textMuted;

    final content = label == null
        ? Icon(icon, color: color, size: 24)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label!,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: content,
      ),
    );
  }
}
