class AppConfig {
  static const String appName = 'Xenobiz Admin Dashboard';

  /// Centralized API Base URL supporting compile-time `--dart-define=API_BASE_URL=...`
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  static const int connectTimeoutMs = 8000;
  static const int receiveTimeoutMs = 8000;

  static const String tokenKey = 'xenobiz_auth_token';
  static const String businessIdKey = 'xenobiz_selected_business_id';
  static const String userKey = 'xenobiz_user_info';
}
