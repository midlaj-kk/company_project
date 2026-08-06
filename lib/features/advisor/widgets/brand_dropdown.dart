import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Pill-shaped dropdown used for the Brand field in the Add
/// Vehicle form. Extend the [brands] list with more manufacturers
/// as needed.
class BrandDropdown extends StatelessWidget {
  const BrandDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  static const brands = [
    'Maruti Suzuki',
    'Hyundai',
    'Tata',
    'Mahindra',
    'Honda',
    'Toyota',
    'Kia',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Porsche',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: const Text('Select',
              style: TextStyle(color: AppColors.textMuted)),
          dropdownColor: AppColors.surface,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.textMuted),
          style: const TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          items: brands
              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}