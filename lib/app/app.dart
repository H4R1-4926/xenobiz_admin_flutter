import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import '../features/admins/bloc/admins_bloc.dart';
import '../features/audit_logs/bloc/audit_logs_bloc.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/configuration/bloc/config_bloc.dart';
import '../features/customers/bloc/customer_bloc.dart';
import '../features/dashboard/bloc/dashboard_bloc.dart';
import '../features/feature_flags/bloc/feature_flags_bloc.dart';
import '../features/payments/bloc/payment_bloc.dart';
import '../features/plans/bloc/plan_bloc.dart';
import '../features/shops/bloc/shop_bloc.dart';
import '../features/subscriptions/bloc/subscription_bloc.dart';
import '../shared/providers/api_providers.dart';
import '../shared/providers/theme_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class XenobizAdminApp extends ConsumerWidget {
  const XenobizAdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final dashboardRepo = ref.watch(dashboardRepositoryProvider);
    final shopRepo = ref.watch(shopRepositoryProvider);
    final customerRepo = ref.watch(customerRepositoryProvider);
    final subscriptionRepo = ref.watch(subscriptionRepositoryProvider);
    final planRepo = ref.watch(planRepositoryProvider);
    final paymentRepo = ref.watch(paymentRepositoryProvider);
    final configRepo = ref.watch(configRepositoryProvider);
    final featureFlagRepo = ref.watch(featureFlagRepositoryProvider);
    final adminRepo = ref.watch(adminRepositoryProvider);
    final auditLogRepo = ref.watch(auditLogRepositoryProvider);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: authRepo)),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository: dashboardRepo)),
        BlocProvider(create: (_) => ShopBloc(shopRepository: shopRepo)),
        BlocProvider(create: (_) => CustomerBloc(customerRepository: customerRepo)),
        BlocProvider(create: (_) => SubscriptionBloc(subscriptionRepository: subscriptionRepo)),
        BlocProvider(create: (_) => PlanBloc(planRepository: planRepo)),
        BlocProvider(create: (_) => PaymentBloc(paymentRepository: paymentRepo)),
        BlocProvider(create: (_) => ConfigBloc(configRepository: configRepo)),
        BlocProvider(create: (_) => FeatureFlagsBloc(featureFlagRepository: featureFlagRepo)),
        BlocProvider(create: (_) => AdminsBloc(adminRepository: adminRepo)),
        BlocProvider(create: (_) => AuditLogsBloc(auditLogRepository: auditLogRepo)),
      ],
      child: p.Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'XenoBiz Admin Central',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
