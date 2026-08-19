import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../constants/app_colors.dart';
import '../responsive/responsive_breakpoints.dart';
import 'admin_sidebar.dart';
import 'admin_topbar.dart';
import 'breadcrumb_widget.dart';

class AdminShell extends StatefulWidget {
  final String pageTitle;
  final String currentRoute;
  final List<BreadcrumbItem>? breadcrumbs;
  final Widget child;

  const AdminShell({
    super.key,
    required this.pageTitle,
    required this.currentRoute,
    this.breadcrumbs,
    required this.child,
  });

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _getBottomNavIndex(String route) {
    if (route.startsWith('/shops')) return 1;
    if (route.startsWith('/customers')) return 2;
    if (route.startsWith('/subscriptions')) return 3;
    if (route.startsWith('/settings')) return 4;
    return 0; // Default dashboard
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    final isMobileOrTablet = ResponsiveBreakpoints.isMobileOrTablet(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      drawer: isMobileOrTablet
          ? Drawer(
              child: AdminSidebar(
                currentRoute: widget.currentRoute,
                onNavigate: (route) {
                  Navigator.of(context).pop();
                  context.go(route);
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Desktop & Laptop persistent sidebar
          if (!isMobileOrTablet)
            AdminSidebar(
              currentRoute: widget.currentRoute,
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                AdminTopbar(
                  pageTitle: widget.pageTitle,
                  breadcrumbs: widget.breadcrumbs,
                  onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _getBottomNavIndex(widget.currentRoute),
              selectedItemColor: AppColors.primary,
              unselectedItemColor: isDark ? Colors.grey : Colors.black54,
              backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go('/dashboard');
                    break;
                  case 1:
                    context.go('/shops');
                    break;
                  case 2:
                    context.go('/customers');
                    break;
                  case 3:
                    context.go('/subscriptions');
                    break;
                  case 4:
                    context.go('/settings');
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.storefront_rounded),
                  label: 'Shops',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group_rounded),
                  label: 'Customers',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_rounded),
                  label: 'Subs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
