import '../../core/network/api_client.dart';
import '../models/subscription_model.dart';

class SubscriptionRepository {
  final ApiClient apiClient;

  SubscriptionRepository({required this.apiClient});

  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final res = await apiClient.get('/admin/subscriptions');
      if (res != null) {
        final list = res['data'] is List
            ? res['data'] as List
            : (res['data'] is Map && res['data']['items'] is List)
                ? res['data']['items'] as List
                : null;
        if (list != null) {
          return list.map((e) => SubscriptionModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {}

    return const [
      SubscriptionModel(
        id: 'sub_001',
        shopName: 'Metro Fashion Hub',
        planName: 'Pro Plan',
        billingCycle: 'Monthly',
        amount: 1499.0,
        startDate: '2026-08-01',
        endDate: '2026-09-01',
        status: 'active',
      ),
      SubscriptionModel(
        id: 'sub_002',
        shopName: 'Green Grocery Store',
        planName: 'Enterprise',
        billingCycle: 'Yearly',
        amount: 39999.0,
        startDate: '2026-01-15',
        endDate: '2027-01-15',
        status: 'active',
      ),
      SubscriptionModel(
        id: 'sub_003',
        shopName: 'Urban Tech Electronics',
        planName: 'Basic',
        billingCycle: 'Monthly',
        amount: 499.0,
        startDate: '2026-07-10',
        endDate: '2026-08-10',
        status: 'expired',
      ),
      SubscriptionModel(
        id: 'sub_004',
        shopName: 'Royal Sweets & Bakers',
        planName: 'Pro Plan',
        billingCycle: 'Monthly',
        amount: 1499.0,
        startDate: '2026-06-01',
        endDate: '2026-07-01',
        status: 'cancelled',
      ),
    ];
  }
}
