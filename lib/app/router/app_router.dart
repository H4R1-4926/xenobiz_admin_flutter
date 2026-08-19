import 'package:go_router/go_router.dart';
import '../../core/widgets/admin_shell.dart';
import '../../core/widgets/breadcrumb_widget.dart';
import '../../features/admins/pages/admin_management_page.dart';
import '../../features/audit_logs/pages/audit_log_details_page.dart';
import '../../features/audit_logs/pages/audit_logs_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/configuration/pages/app_configuration_page.dart';
import '../../features/customers/pages/customer_details_page.dart';
import '../../features/customers/pages/customers_page.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/feature_flags/pages/feature_flags_page.dart';
import '../../features/payments/pages/payment_details_page.dart';
import '../../features/payments/pages/payments_page.dart';
import '../../features/plans/pages/plans_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/shops/pages/shop_details_page.dart';
import '../../features/shops/pages/shops_list_page.dart';
import '../../features/subscriptions/pages/subscriptions_page.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final location = state.matchedLocation;
        String pageTitle = 'Dashboard Overview';
        List<BreadcrumbItem> breadcrumbs = [
          const BreadcrumbItem(label: 'Home', route: '/dashboard'),
          const BreadcrumbItem(label: 'Dashboard', route: '/dashboard'),
        ];

        if (location.startsWith('/shops')) {
          pageTitle = 'Shop & Account Management';
          if (location.contains('/shops/')) {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Shops', route: '/shops'),
              BreadcrumbItem(label: 'Shop Details'),
            ];
          } else {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Shops', route: '/shops'),
              BreadcrumbItem(label: 'Store Directory', route: '/shops'),
            ];
          }
        } else if (location.startsWith('/customers')) {
          pageTitle = 'Customer Intelligence Directory';
          if (location.contains('/customers/')) {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Shops', route: '/shops'),
              BreadcrumbItem(label: 'Customers', route: '/customers'),
              BreadcrumbItem(label: 'Customer Details'),
            ];
          } else {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Shops', route: '/shops'),
              BreadcrumbItem(label: 'Customer Details', route: '/customers'),
            ];
          }
        } else if (location.startsWith('/subscriptions')) {
          pageTitle = 'Subscription Contracts & Billing';
          breadcrumbs = const [
            BreadcrumbItem(label: 'Home', route: '/dashboard'),
            BreadcrumbItem(label: 'Shops', route: '/shops'),
            BreadcrumbItem(label: 'Subscriptions', route: '/subscriptions'),
          ];
        } else if (location.startsWith('/plans')) {
          pageTitle = 'Subscription Pricing Plans';
          breadcrumbs = const [
            BreadcrumbItem(label: 'Home', route: '/dashboard'),
            BreadcrumbItem(label: 'Plans', route: '/plans'),
            BreadcrumbItem(label: 'Pricing Tiers', route: '/plans'),
          ];
        } else if (location.startsWith('/payments')) {
          pageTitle = 'Payments & Revenue Transactions';
          if (location.contains('/payments/')) {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Payments', route: '/payments'),
              BreadcrumbItem(label: 'Transaction Details'),
            ];
          } else {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Payments', route: '/payments'),
              BreadcrumbItem(label: 'Transactions', route: '/payments'),
            ];
          }
        } else if (location.startsWith('/configuration')) {
          pageTitle = 'Global App Configuration';
          breadcrumbs = const [
            BreadcrumbItem(label: 'Home', route: '/dashboard'),
            BreadcrumbItem(label: 'Configuration', route: '/configuration'),
            BreadcrumbItem(label: 'App Settings', route: '/configuration'),
          ];
        } else if (location.startsWith('/feature-flags')) {
          pageTitle = 'Feature Toggles & Rollout';
          breadcrumbs = const [
            BreadcrumbItem(label: 'Home', route: '/dashboard'),
            BreadcrumbItem(label: 'Feature Flags', route: '/feature-flags'),
            BreadcrumbItem(label: 'Toggles', route: '/feature-flags'),
          ];
        } else if (location.startsWith('/admins')) {
          pageTitle = 'Admin Users & Access Governance';
          breadcrumbs = const [
            BreadcrumbItem(label: 'Home', route: '/dashboard'),
            BreadcrumbItem(label: 'Admins', route: '/admins'),
            BreadcrumbItem(label: 'Access Governance', route: '/admins'),
          ];
        } else if (location.startsWith('/audit-logs')) {
          pageTitle = 'Security & Action Audit Logs';
          if (location.contains('/audit-logs/')) {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Audit Logs', route: '/audit-logs'),
              BreadcrumbItem(label: 'Event Details'),
            ];
          } else {
            breadcrumbs = const [
              BreadcrumbItem(label: 'Home', route: '/dashboard'),
              BreadcrumbItem(label: 'Audit Logs', route: '/audit-logs'),
              BreadcrumbItem(label: 'Security Logs', route: '/audit-logs'),
            ];
          }
        } else if (location.startsWith('/settings')) {
          pageTitle = 'Admin Account & System Health';
          breadcrumbs = const [
            BreadcrumbItem(label: 'Home', route: '/dashboard'),
            BreadcrumbItem(label: 'Settings', route: '/settings'),
            BreadcrumbItem(label: 'System Status', route: '/settings'),
          ];
        }

        return AdminShell(
          pageTitle: pageTitle,
          currentRoute: location,
          breadcrumbs: breadcrumbs,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/shops',
          builder: (context, state) => const ShopsListPage(),
        ),
        GoRoute(
          path: '/shops/:id',
          builder: (context, state) => ShopDetailsPage(
            shopId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '/customers',
          builder: (context, state) => const CustomersPage(),
        ),
        GoRoute(
          path: '/customers/:id',
          builder: (context, state) => CustomerDetailsPage(
            customerId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '/subscriptions',
          builder: (context, state) => const SubscriptionsPage(),
        ),
        GoRoute(
          path: '/plans',
          builder: (context, state) => const PlansPage(),
        ),
        GoRoute(
          path: '/payments',
          builder: (context, state) => const PaymentsPage(),
        ),
        GoRoute(
          path: '/payments/:id',
          builder: (context, state) => PaymentDetailsPage(
            paymentId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '/configuration',
          builder: (context, state) => const AppConfigurationPage(),
        ),
        GoRoute(
          path: '/feature-flags',
          builder: (context, state) => const FeatureFlagsPage(),
        ),
        GoRoute(
          path: '/admins',
          builder: (context, state) => const AdminManagementPage(),
        ),
        GoRoute(
          path: '/audit-logs',
          builder: (context, state) => const AuditLogsPage(),
        ),
        GoRoute(
          path: '/audit-logs/:id',
          builder: (context, state) => AuditLogDetailsPage(
            logId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
