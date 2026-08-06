import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Horizontal scrollable list of mechanic avatar cards for the
/// "Assign Mechanic" step in Create Service Job. Includes a
/// trailing "Skip — assign later" chip.
class MechanicPicker extends StatelessWidget {
  const MechanicPicker({
    super.key,
    required this.mechanics,
    required this.selectedMechanicId,
    required this.onSelected,
  });

  /// Each item: {"id": int, "name": String, "specialization": String}
  final List<dynamic> mechanics;
  final int? selectedMechanicId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mechanics.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == mechanics.length) {
            return _SkipChip(
              isSelected: selectedMechanicId == null,
              onTap: () => onSelected(null),
            );
          }

          final mechanic = mechanics[index];
          final id = mechanic['id'] as int;
          final isSelected = selectedMechanicId == id;

          return GestureDetector(
            onTap: () => onSelected(id),
            child: Container(
              width: 92,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.limeAccent.withOpacity(0.12)
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.limeAccent
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.person,
                        size: 18,
                        color: isSelected
                            ? AppColors.limeAccent
                            : AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mechanic['name'] ?? '',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    mechanic['specialization'] ?? '',
                    style: AppTextStyles.caption.copyWith(fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SkipChip extends StatelessWidget {
  const _SkipChip({required this.isSelected, required this.onTap});
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.limeAccent.withOpacity(0.12)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.limeAccent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule,
                size: 20,
                color: isSelected
                    ? AppColors.limeAccent
                    : AppColors.textMuted),
            const SizedBox(height: 6),
            Text(
              'Skip —\nassign later',
              style: AppTextStyles.caption.copyWith(fontSize: 9),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}