import 'package:auto_care_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Small rounded status pill, color-coded by meaning.
/// Used everywhere a job/bill/payment status is shown.
///
/// Recognizes backend status strings like:
/// "active"/"in_progress", "qc_pending", "ready_for_bill",
/// "ready_for_delivery", "delivered", "paid", "pending",
/// "rework_required", "cancelled", "waiting"
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  ({Color color, String label}) get _style {
    switch (status.toLowerCase()) {
      case 'active':
      case 'in_progress':
        return (color: AppColors.limeAccent, label: 'ACTIVE');
      case 'qc_pending':
      case 'qc':
        return (color: AppColors.amberAccent, label: 'QC');
      case 'ready_for_bill':
      case 'ready_for_delivery':
      case 'ready':
        return (color: AppColors.statusSuccess, label: 'READY');
      case 'delivered':
      case 'paid':
      case 'completed':
        return (color: AppColors.statusSuccess, label: 'DONE');
      case 'rework_required':
        return (color: AppColors.statusError, label: 'REWORK');
      case 'cancelled':
        return (color: AppColors.statusError, label: 'CANCELLED');
      case 'partial':
        return (color: AppColors.amberAccent, label: 'PARTIAL');
      case 'pending':
        return (color: AppColors.statusNeutral, label: 'PENDING');
      case 'waiting':
        return (color: AppColors.amberAccent, label: 'PENDING');
      default:
        return (color: AppColors.statusNeutral, label: status.toUpperCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          color: style.color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}