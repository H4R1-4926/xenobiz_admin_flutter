import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../constants/app_typography.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.titleMedium(isDark)),
            const SizedBox(height: 8),
            Text(message, style: AppTypography.bodyMedium(isDark), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
