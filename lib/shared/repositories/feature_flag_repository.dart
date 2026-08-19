import '../../core/network/api_client.dart';
import '../models/feature_flag_model.dart';

class FeatureFlagRepository {
  final ApiClient apiClient;

  FeatureFlagRepository({required this.apiClient});

  Future<List<FeatureFlagModel>> getFeatureFlags() async {
    try {
      final res = await apiClient.get('/admin/feature-flags');
      if (res != null && res['data'] is List) {
        return (res['data'] as List).map((e) => FeatureFlagModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return const [
      FeatureFlagModel(
        key: 'enable_new_pos_checkout',
        name: 'New POS Checkout UI',
        description: 'Enable ultra-fast barcode scanner checkout experience for shop cashiers.',
        environment: 'production',
        isEnabled: true,
      ),
      FeatureFlagModel(
        key: 'enable_whatsapp_invoicing',
        name: 'WhatsApp PDF Invoicing',
        description: 'Send automated PDF invoices directly to customer WhatsApp numbers.',
        environment: 'production',
        isEnabled: true,
      ),
      FeatureFlagModel(
        key: 'enable_ai_demand_forecasting',
        name: 'AI Demand Forecasting',
        description: 'Predict store inventory requirements using machine learning trends.',
        environment: 'beta',
        isEnabled: false,
      ),
      FeatureFlagModel(
        key: 'enable_multi_currency_billing',
        name: 'Multi-Currency Payments',
        description: 'Allow cross-border shop billing in USD, EUR, and AED.',
        environment: 'staging',
        isEnabled: false,
      ),
    ];
  }

  Future<void> toggleFlag(String key) async {
    try {
      await apiClient.put('/admin/feature-flags/$key/toggle');
    } catch (_) {}
  }
}
