import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Row of 4 selectable payment method icon-buttons.
class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onSelected,
  });

  final String selectedMethod; // cash | upi | card | bank_transfer
  final ValueChanged<String> onSelected;

  static const _methods = [
    ('cash', 'Cash', Icons.payments_outlined),
    ('upi', 'UPI', Icons.qr_code_2),
    ('card', 'Card', Icons.credit_card_outlined),
    ('bank_transfer', 'Bank', Icons.account_balance_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _methods.map((entry) {
        final (value, label, icon) = entry;
        final isSelected = value == selectedMethod;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onSelected(value),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.limeAccent.withOpacity(0.12)
                      : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.limeAccent : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(icon,
                        color: isSelected
                            ? AppColors.limeAccent
                            : AppColors.textMuted,
                        size: 22),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected
                            ? AppColors.limeAccent
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}