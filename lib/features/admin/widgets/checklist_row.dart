import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One row of the QC checklist: a label plus a 3-way selector
/// (Passed / Failed / N-A). Works for both the standard
/// passed/failed/na options and oil-leakage's no_issue/issue_found/na
/// by passing custom [options] and [displayLabels].
class ChecklistRow extends StatelessWidget {
  const ChecklistRow({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
    this.options = const ['passed', 'failed', 'na'],
    this.displayLabels = const ['PASSED', 'FAILED', 'N/A'],
  });

  final String label;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final List<String> options;
  final List<String> displayLabels;

  Color _colorFor(String option) {
    if (option == 'passed' || option == 'no_issue') {
      return AppColors.statusSuccess;
    }
    if (option == 'failed' || option == 'issue_found') {
      return AppColors.statusError;
    }
    return AppColors.statusNeutral;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyRegular.copyWith(fontWeight: FontWeight.w600),
          ),
          Row(
            children: List.generate(options.length, (i) {
              final option = options[i];
              final isSelected = selectedValue == option;
              final color = _colorFor(option);

              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      displayLabels[i],
                      style: TextStyle(
                        color: isSelected ? Colors.black : AppColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}