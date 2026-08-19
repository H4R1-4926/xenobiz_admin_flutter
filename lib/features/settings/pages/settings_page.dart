import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BreadcrumbWidget(
              items: [
                BreadcrumbItem(label: 'Home', route: '/dashboard'),
                BreadcrumbItem(label: 'Settings', route: '/settings'),
                BreadcrumbItem(label: 'System Status'),
              ],
            ),
            const SizedBox(height: 16),

            // Admin Profile Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: AppRadius.borderRadiusMd,
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary,
                    child: Text('A', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Master Super Admin', style: AppTypography.titleLarge(isDark)),
                      const SizedBox(height: 4),
                      Text('admin@xenobiz.com', style: AppTypography.bodyMedium(isDark)),
                      const SizedBox(height: 8),
                      const StatusBadge(label: 'SUPER_ADMIN', type: 'pro'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // API Connection & System Status Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: AppRadius.borderRadiusMd,
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Xenobiz Backend API Status', style: AppTypography.titleSmall(isDark)),
                  const SizedBox(height: 16),
                  _rowItem('API Base Endpoint:', 'http://localhost:3000/api/v1', isDark, isMono: true),
                  _rowItem('API Health:', 'HEALTHY (HTTP 200 OK)', isDark, isGreen: true),
                  _rowItem('Node.js Express Server:', 'ONLINE', isDark, isGreen: true),
                  _rowItem('Database Engine:', 'SQLite / PostgreSQL (Active)', isDark),
                  _rowItem('Flutter Web Renderer:', 'HTML / CanvasKit Adaptive', isDark),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _rowItem(String label, String value, bool isDark, {bool isMono = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelMuted(isDark)),
          Text(
            value,
            style: isMono
                ? AppTypography.mono(isDark)
                : TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isGreen ? AppColors.success : (isDark ? Colors.white : Colors.black),
                  ),
          ),
        ],
      ),
    );
  }
}
