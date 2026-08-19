import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_typography.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget chart;

  const ChartCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleSmall(isDark)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: AppTypography.bodyMedium(isDark)),
          ],
          const SizedBox(height: 16),
          Expanded(child: chart),
        ],
      ),
    );
  }
}
