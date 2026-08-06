import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Horizontal scrollable row of role filter pills, used at the top
/// of Staff Management to filter the list by role.
class RoleFilterTabs extends StatelessWidget {
  const RoleFilterTabs({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  final String selectedRole; // "all" | "admin" | "service_advisor" | ...
  final ValueChanged<String> onRoleSelected;

  static const _tabs = [
    ('all', 'All'),
    ('admin', 'Admin'),
    ('service_advisor', 'Advisor'),
    ('mechanic', 'Mechanic'),
    ('cashier', 'Cashier'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (value, label) = _tabs[index];
          final isSelected = value == selectedRole;

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onRoleSelected(value),
            backgroundColor: AppColors.cardBackground,
            selectedColor: AppColors.limeAccent,
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          );
        },
      ),
    );
  }
}