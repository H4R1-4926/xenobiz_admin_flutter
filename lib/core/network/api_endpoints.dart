class ApiEndpoints {
  // Health
  static const String health = '/health';

  // Auth
  static const String login = '/auth/login';
  static const String adminLogin = '/admin/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Dashboard Summary & Analytics
  static const String dashboardSummary = '/admin/dashboard/summary';

  // Shops & Accounts
  static const String shops = '/admin/shops';
  static const String accounts = '/admin/accounts';
  static String shopDetail(String id) => '/admin/shops/$id';
  static String accountDetail(String id) => '/admin/shops/$id';
  static String shopStatus(String id) => '/admin/shops/$id/status';
  static String accountStatus(String id) => '/admin/shops/$id/status';

  // Companies / Businesses
  static const String companies = '/admin/businesses';
  static String companyDetail(String id) => '/admin/businesses/$id';

  // Customers
  static const String customers = '/admin/customers';
  static String customerDetail(String id) => '/admin/customers/$id';

  // Subscriptions
  static const String subscriptions = '/admin/subscriptions';
  static String subscriptionDetail(String id) => '/admin/subscriptions/$id';

  // Plans
  static const String plans = '/admin/plans';
  static String planDetail(String id) => '/admin/plans/$id';
  static String planToggle(String id) => '/admin/plans/$id/toggle';

  // Payments & Subscription Purchases
  static const String payments = '/admin/purchases';
  static const String purchases = '/admin/purchases';
  static String paymentDetail(String id) => '/admin/purchases/$id';
  static String purchaseDetail(String id) => '/admin/purchases/$id';

  // App Configuration
  static const String appConfig = '/admin/config';
  static String appConfigCategory(String category) => '/admin/config/$category';

  // Feature Flags
  static const String featureFlags = '/admin/feature-flags';
  static String featureFlagToggle(String key) => '/admin/feature-flags/$key/toggle';
  static String featureFlagDetail(String key) => '/admin/feature-flags/$key';

  // Admin Management
  static const String admins = '/admin/admins';
  static String adminDetail(String id) => '/admin/admins/$id';
  static String adminStatus(String id) => '/admin/admins/$id/status';
  static String adminResetPassword(String id) => '/admin/admins/$id/reset-password';

  // Audit Logs
  static const String auditLogs = '/admin/audit-logs';
}
