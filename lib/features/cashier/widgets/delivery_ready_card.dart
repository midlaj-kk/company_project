import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Card for one vehicle ready for delivery, with a hero photo,
/// customer contact info, and a Mark as Delivered button.
class DeliveryReadyCard extends StatelessWidget {
  const DeliveryReadyCard({
    super.key,
    required this.jobNumber,
    required this.vehicleModel,
    required this.customerName,
    required this.customerPhone,
    this.footnote,
    this.onMarkDelivered,
  });

  final String jobNumber;
  final String vehicleModel;
  final String customerName;
  final String customerPhone;
  final String? footnote;
  final VoidCallback? onMarkDelivered;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  vehicleModel,
                  style: AppTextStyles.bodyRegular
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(jobNumber, style: AppTextStyles.caption),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CUSTOMER',
                        style: AppTextStyles.caption
                            .copyWith(letterSpacing: 0.4)),
                    Text(customerName,
                        style: AppTextStyles.bodyRegular
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('CONTACT',
                      style:
                          AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
                  Row(
                    children: [
                      Text(customerPhone,
                          style: const TextStyle(
                              color: AppColors.limeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                      const SizedBox(width: 4),
                      const Icon(Icons.call,
                          color: AppColors.limeAccent, size: 14),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 130,
              width: double.infinity,
              color: AppColors.inputFill,
              child: const Icon(Icons.directions_car,
                  size: 48, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 12),
          if (footnote != null) ...[
            Text(footnote!,
                style: AppTextStyles.caption
                    .copyWith(fontStyle: FontStyle.italic)),
            const SizedBox(height: 10),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onMarkDelivered,
              icon: const Icon(Icons.check_circle_outline,
                  color: Colors.black, size: 18),
              label: const Text('Mark as Delivered'),
            ),
          ),
        ],
      ),
    );
  }
}