import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Segmented row of role pills for selecting a staff member's
/// system role in the Add/Edit Staff form.
class RoleSelector extends StatelessWidget {
  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  final String selectedRole;
  final ValueChanged<String> onChanged;

  static const _roles = [
    ('admin', 'Admin'),
    ('service_advisor', 'Advisor'),
    ('mechanic', 'Mechanic'),
    ('cashier', 'Cashier'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _roles.map((entry) {
        final (value, label) = entry;
        final isSelected = value == selectedRole;

        return GestureDetector(
          onTap: () => onChanged(value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.limeAccent : AppColors.inputFill,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}