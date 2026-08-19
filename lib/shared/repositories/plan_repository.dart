import '../../core/network/api_client.dart';
import '../models/plan_model.dart';

class PlanRepository {
  final ApiClient apiClient;

  PlanRepository({required this.apiClient});

  Future<List<PlanModel>> getPlans() async {
    try {
      final res = await apiClient.get('/admin/plans');
      if (res != null && res['data'] is List) {
        return (res['data'] as List).map((e) => PlanModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return const [
      PlanModel(
        id: 'pln_free',
        name: 'Free Trial',
        description: 'Ideal for testing features and setting up initial store inventory.',
        price: 0.0,
        billingCycle: '14 Days',
        subscriberCount: 12,
        isActive: true,
        features: ['Up to 50 Products', 'Single User', 'Basic Analytics'],
      ),
      PlanModel(
        id: 'pln_basic',
        name: 'Basic Starter',
        description: 'For small retail shops & local businesses getting started.',
        price: 499.0,
        billingCycle: 'Monthly',
        subscriberCount: 38,
        isActive: true,
        features: ['Up to 500 Products', '2 User Logins', 'Email Support', 'Basic Reports'],
      ),
      PlanModel(
        id: 'pln_pro',
        name: 'Pro Business',
        description: 'For growing retail chains with full inventory & POS integration.',
        price: 1499.0,
        billingCycle: 'Monthly',
        subscriberCount: 74,
        isActive: true,
        features: ['Unlimited Products', '5 User Logins', 'Priority 24/7 Support', 'Advanced Analytics', 'Export Reports'],
      ),
      PlanModel(
        id: 'pln_ent',
        name: 'Enterprise Ultra',
        description: 'Custom multi-store solution with dedicated account manager.',
        price: 3999.0,
        billingCycle: 'Monthly',
        subscriberCount: 24,
        isActive: true,
        features: ['Unlimited Outlets', 'Unlimited Staff', 'Dedicated Account Manager', 'Custom API Access', 'SLA Guarantee'],
      ),
    ];
  }

  Future<PlanModel> createPlan(Map<String, dynamic> payload) async {
    try {
      final res = await apiClient.post('/admin/plans', data: payload);
      if (res != null && res['data'] != null) {
        return PlanModel.fromJson(res['data']);
      }
    } catch (_) {}

    return PlanModel(
      id: 'pln_${DateTime.now().millisecondsSinceEpoch}',
      name: payload['name'] ?? 'Custom Plan',
      description: payload['description'] ?? '',
      price: (payload['price'] ?? 999).toDouble(),
      billingCycle: payload['billingCycle'] ?? 'Monthly',
      subscriberCount: 0,
      isActive: true,
      features: const ['Custom Feature Access', 'Priority Support'],
    );
  }

  Future<void> togglePlanStatus(String planId) async {
    try {
      await apiClient.post('/admin/plans/$planId/toggle');
    } catch (_) {}
  }
}
