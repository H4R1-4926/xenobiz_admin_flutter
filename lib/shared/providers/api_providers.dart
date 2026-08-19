import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../repositories/admin_repository.dart';
import '../repositories/audit_log_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/config_repository.dart';
import '../repositories/customer_repository.dart';
import '../repositories/dashboard_repository.dart';
import '../repositories/feature_flag_repository.dart';
import '../repositories/payment_repository.dart';
import '../repositories/plan_repository.dart';
import '../repositories/shop_repository.dart';
import '../repositories/subscription_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(apiClient: ref.watch(apiClientProvider)),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepository(apiClient: ref.watch(apiClientProvider)),
);

final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => ShopRepository(apiClient: ref.watch(apiClientProvider)),
);

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => CustomerRepository(apiClient: ref.watch(apiClientProvider)),
);

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(apiClient: ref.watch(apiClientProvider)),
);

final planRepositoryProvider = Provider<PlanRepository>(
  (ref) => PlanRepository(apiClient: ref.watch(apiClientProvider)),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepository(apiClient: ref.watch(apiClientProvider)),
);

final configRepositoryProvider = Provider<ConfigRepository>(
  (ref) => ConfigRepository(apiClient: ref.watch(apiClientProvider)),
);

final featureFlagRepositoryProvider = Provider<FeatureFlagRepository>(
  (ref) => FeatureFlagRepository(apiClient: ref.watch(apiClientProvider)),
);

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepository(apiClient: ref.watch(apiClientProvider)),
);

final auditLogRepositoryProvider = Provider<AuditLogRepository>(
  (ref) => AuditLogRepository(apiClient: ref.watch(apiClientProvider)),
);
