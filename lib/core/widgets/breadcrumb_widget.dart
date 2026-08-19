import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../constants/app_colors.dart';

class BreadcrumbItem {
  final String label;
  final String? route;

  const BreadcrumbItem({
    required this.label,
    this.route,
  });
}

class BreadcrumbWidget extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    if (items.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
              ),
            );
          }

          final itemIndex = index ~/ 2;
          final item = items[itemIndex];
          final isLast = itemIndex == items.length - 1;

          if (isLast) {
            return Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            );
          }

          return InkWell(
            onTap: item.route != null ? () => context.go(item.route!) : null,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
