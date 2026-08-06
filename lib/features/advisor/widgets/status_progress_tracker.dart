import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Horizontal step tracker showing where a job is in its lifecycle:
/// Waiting → In Progress → QC Pending → Ready for Delivery.
/// Completed steps show a checkmark, the current step is lime and
/// pulsing-styled, future steps are dim gray dots.
class StatusProgressTracker extends StatelessWidget {
  const StatusProgressTracker({super.key, required this.currentStatus});

  final String currentStatus;

  static const _stages = [
    ('waiting', 'Waiting'),
    ('in_progress', 'In Progress'),
    ('qc_pending', 'QC Pending'),
    ('ready_for_delivery', 'Ready for Del.'),
  ];

  int get _currentIndex {
    // Collapse related backend statuses onto the 4 visual stages.
    switch (currentStatus) {
      case 'waiting':
        return 0;
      case 'in_progress':
      case 'waiting_for_parts':
      case 'rework_required':
        return 1;
      case 'qc_pending':
        return 2;
      case 'ready_for_bill':
      case 'ready_for_delivery':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _currentIndex;

    return Row(
      children: List.generate(_stages.length, (i) {
        final (_, label) = _stages[i];
        final isDone = i < activeIndex;
        final isActive = i == activeIndex;
        final isLast = i == _stages.length - 1;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: i == 0
                        ? const SizedBox()
                        : Container(
                            height: 2,
                            color: isDone || isActive
                                ? AppColors.limeAccent
                                : AppColors.inputFill,
                          ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? AppColors.limeAccent
                          : isActive
                              ? AppColors.background
                              : AppColors.inputFill,
                      border: isActive
                          ? Border.all(color: AppColors.limeAccent, width: 2)
                          : null,
                    ),
                    child: isDone
                        ? const Icon(Icons.check,
                            size: 14, color: Colors.black)
                        : isActive
                            ? Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.limeAccent,
                                  ),
                                ),
                              )
                            : null,
                  ),
                  Expanded(
                    child: isLast
                        ? const SizedBox()
                        : Container(
                            height: 2,
                            color: isDone
                                ? AppColors.limeAccent
                                : AppColors.inputFill,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: isActive
                      ? AppColors.limeAccent
                      : isDone
                          ? AppColors.textSecondary
                          : AppColors.textMuted,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}