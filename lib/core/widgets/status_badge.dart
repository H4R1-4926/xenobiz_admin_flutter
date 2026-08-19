import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final String? type; // active, inactive, suspended, trial, pro, enterprise, expired, pending, failed, completed

  const StatusBadge({
    super.key,
    required this.label,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final statusType = (type ?? label).toLowerCase();

    Color bg = AppColors.infoBg;
    Color text = AppColors.infoText;

    if (statusType.contains('active') || statusType.contains('completed') || statusType.contains('enabled')) {
      bg = AppColors.successBg;
      text = AppColors.successText;
    } else if (statusType.contains('trial') || statusType.contains('pending') || statusType.contains('beta')) {
      bg = AppColors.warningBg;
      text = AppColors.warningText;
    } else if (statusType.contains('suspended') || statusType.contains('expired') || statusType.contains('failed') || statusType.contains('disabled')) {
      bg = AppColors.errorBg;
      text = AppColors.errorText;
    } else if (statusType.contains('pro')) {
      bg = AppColors.badgeProBg;
      text = AppColors.badgeProText;
    } else if (statusType.contains('enterprise')) {
      bg = AppColors.badgeEnterpriseBg;
      text = AppColors.badgeEnterpriseText;
    } else if (statusType.contains('inactive')) {
      bg = const Color(0xFFF1F5F9);
      text = const Color(0xFF64748B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderRadiusBadge,
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
