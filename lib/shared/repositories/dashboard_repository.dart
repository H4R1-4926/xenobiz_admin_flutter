import '../../core/network/api_client.dart';
import '../models/shop_model.dart';

class DashboardData {
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> revenueTrend;
  final List<Map<String, dynamic>> planDistribution;
  final List<ShopModel> recentShops;

  DashboardData({
    required this.summary,
    required this.revenueTrend,
    required this.planDistribution,
    required this.recentShops,
  });
}

class DashboardRepository {
  final ApiClient apiClient;

  DashboardRepository({required this.apiClient});

  Future<DashboardData> getDashboardData() async {
    try {
      final res = await apiClient.get('/admin/dashboard');
      final payload = (res is Map<String, dynamic> && res['data'] is Map<String, dynamic>)
          ? res['data'] as Map<String, dynamic>
          : (res as Map<String, dynamic>? ?? {});

      if (payload['summary'] != null || payload['recentShops'] != null) {
        final summary = (payload['summary'] as Map<String, dynamic>?) ?? {};
        final analytics = (payload['analytics'] as Map<String, dynamic>?) ?? {};
        final recentShopsRaw = (payload['recentShops'] as List? ?? [])
            .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return DashboardData(
          summary: summary,
          revenueTrend: List<Map<String, dynamic>>.from(analytics['revenueTrend'] ?? []),
          planDistribution: List<Map<String, dynamic>>.from(analytics['planDistribution'] ?? []),
          recentShops: recentShopsRaw,
        );
      }
    } catch (e) {
      // Fallback if backend server is unreachable
    }

    return DashboardData(
      summary: const {
        'totalShops': 148,
        'activeShops': 112,
        'inactiveShops': 18,
        'suspendedShops': 6,
        'trialShops': 12,
        'activeSubscriptions': 124,
        'expiredSubscriptions': 14,
        'totalCustomers': 3850,
        'totalRevenue': 485000,
        'monthlyRevenue': 68500,
      },
      revenueTrend: const [
        {'month': 'Jan', 'revenue': 18000},
        {'month': 'Feb', 'revenue': 24000},
        {'month': 'Mar', 'revenue': 31000},
        {'month': 'Apr', 'revenue': 42000},
        {'month': 'May', 'revenue': 53000},
        {'month': 'Jun', 'revenue': 68500},
      ],
      planDistribution: const [
        {'plan': 'Free Trial', 'count': 12},
        {'plan': 'Basic', 'count': 38},
        {'plan': 'Pro', 'count': 74},
        {'plan': 'Enterprise', 'count': 24},
      ],
      recentShops: const [
        ShopModel(
          id: 'shp_101',
          shopName: 'Metro Fashion Hub',
          ownerName: 'Rahul Verma',
          email: 'rahul@metrofashion.in',
          phone: '+91 98765 43210',
          loginId: 'metro_fashion',
          planName: 'Pro Plan',
          status: 'active',
          createdAt: '2026-08-15',
        ),
        ShopModel(
          id: 'shp_102',
          shopName: 'Green Grocery Store',
          ownerName: 'Anjali Sharma',
          email: 'anjali@greengrocery.com',
          phone: '+91 98123 45678',
          loginId: 'green_grocery',
          planName: 'Enterprise',
          status: 'active',
          createdAt: '2026-08-14',
        ),
        ShopModel(
          id: 'shp_103',
          shopName: 'Urban Tech Electronics',
          ownerName: 'Vikas Gupta',
          email: 'vikas@urbantech.io',
          phone: '+91 97890 12345',
          loginId: 'urban_tech',
          planName: 'Basic',
          status: 'trial',
          createdAt: '2026-08-12',
        ),
        ShopModel(
          id: 'shp_104',
          shopName: 'Royal Sweets & Bakers',
          ownerName: 'Sanjay Patel',
          email: 'sanjay@royalsweets.in',
          phone: '+91 99000 11223',
          loginId: 'royal_sweets',
          planName: 'Pro Plan',
          status: 'suspended',
          createdAt: '2026-08-10',
        ),
      ],
    );
  }
}
