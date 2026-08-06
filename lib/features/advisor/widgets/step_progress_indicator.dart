import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Multi-segment progress bar with labels, used at the top of the
/// Add Customer + Vehicle form to show which step is active.
class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    this.labels = const ['1. CUSTOMER', '2. VEHICLE', '3. SERVICE'],
  });

  /// 1-based index of the active step.
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(totalSteps, (i) {
            final stepNumber = i + 1;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
                child: _segment(isActive: stepNumber <= currentStep),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (i) {
            final stepNumber = i + 1;
            final isActive = stepNumber == currentStep;
            final isDone = stepNumber < currentStep;
            return Text(
              labels[i],
              style: AppTextStyles.caption.copyWith(
                color: isActive
                    ? AppColors.limeAccent
                    : isDone
                        ? AppColors.textSecondary
                        : AppColors.textMuted,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _segment({required bool isActive}) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? AppColors.limeAccent : AppColors.inputFill,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}