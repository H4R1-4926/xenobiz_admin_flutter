import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../constants/app_colors.dart';

class NavigationItem {
  final String title;
  final IconData icon;
  final String route;

  const NavigationItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class AdminSidebar extends StatelessWidget {
  final String currentRoute;
  final Function(String route)? onNavigate;

  const AdminSidebar({
    super.key,
    required this.currentRoute,
    this.onNavigate,
  });

  static const List<NavigationItem> navItems = [
    NavigationItem(title: 'Dashboard', icon: Icons.dashboard_rounded, route: '/dashboard'),
    NavigationItem(title: 'Shops', icon: Icons.storefront_rounded, route: '/shops'),
    NavigationItem(title: 'Customers', icon: Icons.group_rounded, route: '/customers'),
    NavigationItem(title: 'Subscriptions', icon: Icons.card_membership_rounded, route: '/subscriptions'),
    NavigationItem(title: 'Plans', icon: Icons.sell_rounded, route: '/plans'),
    NavigationItem(title: 'Payments', icon: Icons.payments_rounded, route: '/payments'),
    NavigationItem(title: 'App Config', icon: Icons.tune_rounded, route: '/configuration'),
    NavigationItem(title: 'Feature Flags', icon: Icons.flag_rounded, route: '/feature-flags'),
    NavigationItem(title: 'Admin Management', icon: Icons.admin_panel_settings_rounded, route: '/admins'),
    NavigationItem(title: 'Audit Logs', icon: Icons.history_rounded, route: '/audit-logs'),
    NavigationItem(title: 'Settings', icon: Icons.settings_rounded, route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isCollapsed = themeProvider.isSidebarCollapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed ? 76 : 260,
      decoration: BoxDecoration(
        color: isDark ? AppColors.sidebarBgDark : AppColors.sidebarBgLight,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo & Collapse toggle
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.store_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'XenoBiz Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Central Control Panel',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Nav list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isActive = currentRoute == item.route ||
                    (item.route != '/dashboard' && currentRoute.startsWith(item.route));

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Tooltip(
                    message: isCollapsed ? item.title : '',
                    child: InkWell(
                      onTap: () {
                        if (onNavigate != null) {
                          onNavigate!(item.route);
                        } else {
                          context.go(item.route);
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCollapsed ? 14 : 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : (isDark ? Colors.transparent : Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: isCollapsed
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: isActive
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                            if (!isCollapsed) ...[
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                    color: isActive
                                        ? Colors.white
                                        : (isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Collapse button footer
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () => themeProvider.toggleSidebar(),
              icon: Icon(
                isCollapsed
                    ? Icons.keyboard_double_arrow_right_rounded
                    : Icons.keyboard_double_arrow_left_rounded,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
