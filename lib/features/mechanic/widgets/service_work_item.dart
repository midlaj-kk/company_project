import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One row in the "Service Work" list on Job Detail (Mechanic view).
/// Tapping the leading icon cycles/toggles work status; the
/// trailing badge shows the current status.
class ServiceWorkItem extends StatelessWidget {
  const ServiceWorkItem({
    super.key,
    required this.workName,
    required this.description,
    required this.labourCharge,
    required this.status,
    this.onStatusTap,
  });

  final String workName;
  final String description;
  final String labourCharge;
  final String status; // pending | in_progress | completed
  final VoidCallback? onStatusTap;

  ({IconData icon, Color color, String label}) get _statusStyle {
    switch (status) {
      case 'completed':
        return (
          icon: Icons.check_circle,
          color: AppColors.statusSuccess,
          label: 'COMPLETED'
        );
      case 'in_progress':
        return (
          icon: Icons.autorenew,
          color: AppColors.amberAccent,
          label: 'IN PROGRESS'
        );
      default:
        return (
          icon: Icons.radio_button_unchecked,
          color: AppColors.textMuted,
          label: 'PENDING'
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: style.color, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onStatusTap,
            child: Icon(style.icon, color: style.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workName,
                  style: AppTextStyles.bodyRegular
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(description, style: AppTextStyles.caption, maxLines: 2),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹$labourCharge',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: style.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  style.label,
                  style: TextStyle(
                    color: style.color,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}