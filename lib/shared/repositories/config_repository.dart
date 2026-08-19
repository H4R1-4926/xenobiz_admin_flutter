import '../../core/network/api_client.dart';
import '../models/app_config_model.dart';

class ConfigRepository {
  final ApiClient apiClient;

  ConfigRepository({required this.apiClient});

  Future<AppConfigModel> getConfig() async {
    try {
      final res = await apiClient.get('/admin/config');
      if (res != null && res['data'] != null) {
        return AppConfigModel.fromJson(res['data']);
      }
    } catch (_) {}

    return const AppConfigModel(
      appName: 'XenoBiz Business Manager',
      minAppVersion: '1.2.0',
      supportEmail: 'support@xenobiz.com',
      maintenanceMode: false,
      registrationEnabled: true,
      defaultTrialDays: 14,
    );
  }

  Future<void> updateCategory(String category, Map<String, dynamic> payload) async {
    try {
      await apiClient.put('/admin/config/$category', data: payload);
    } catch (_) {}
  }
}
