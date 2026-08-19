import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../responsive/responsive_breakpoints.dart';
import 'breadcrumb_widget.dart';

class AdminTopbar extends StatelessWidget {
  final String pageTitle;
  final List<BreadcrumbItem>? breadcrumbs;
  final VoidCallback? onOpenDrawer;

  const AdminTopbar({
    super.key,
    required this.pageTitle,
    this.breadcrumbs,
    this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isMobileOrTablet = ResponsiveBreakpoints.isMobileOrTablet(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isMobileOrTablet) ...[
            IconButton(
              onPressed: onOpenDrawer,
              icon: const Icon(Icons.menu_rounded),
            ),
            const SizedBox(width: 8),
          ],

          // Page Title / Breadcrumbs
          Expanded(
            child: (breadcrumbs != null && breadcrumbs!.isNotEmpty)
                ? BreadcrumbWidget(items: breadcrumbs!)
                : Text(
                    pageTitle,
                    style: AppTypography.titleMedium(isDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),

          // Theme Switcher Toggle
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : AppColors.textSecondaryLight,
            ),
          ),

          const SizedBox(width: 8),

          // Admin User Profile & Logout
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            onSelected: (value) {
              if (value == 'logout') {
                context.go('/login');
              } else if (value == 'settings') {
                context.go('/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Super Admin', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('admin@xenobiz.com', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Account Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (!ResponsiveBreakpoints.isMobile(context)) ...[
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Master Admin',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const Text(
                        'SUPER_ADMIN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_drop_down_rounded),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
