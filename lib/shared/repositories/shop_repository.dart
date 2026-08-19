import '../../core/network/api_client.dart';
import '../models/shop_model.dart';

class ShopRepository {
  final ApiClient apiClient;

  ShopRepository({required this.apiClient});

  Future<List<ShopModel>> getShops() async {
    try {
      final res = await apiClient.get('/admin/shops');
      if (res != null && res['data'] is List) {
        return (res['data'] as List).map((e) => ShopModel.fromJson(e)).toList();
      }
    } catch (_) {
      // Fallback to mock
    }

    return const [
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
        address: 'MG Road Sector 14',
        city: 'Gurugram',
        state: 'Haryana',
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
        address: 'Bandra West Main Market',
        city: 'Mumbai',
        state: 'Maharashtra',
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
        address: 'Indiranagar 100ft Road',
        city: 'Bengaluru',
        state: 'Karnataka',
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
        address: 'CG Road Commercial Hub',
        city: 'Ahmedabad',
        state: 'Gujarat',
      ),
      ShopModel(
        id: 'shp_105',
        shopName: 'Apex Fitness Gear',
        ownerName: 'Karan Malhotra',
        email: 'karan@apexfitness.com',
        phone: '+91 95555 66778',
        loginId: 'apex_fitness',
        planName: 'Enterprise',
        status: 'active',
        createdAt: '2026-08-05',
        address: 'Connaught Place Block B',
        city: 'New Delhi',
        state: 'Delhi',
      ),
    ];
  }

  Future<ShopModel> createShop(Map<String, dynamic> payload) async {
    try {
      final res = await apiClient.post('/admin/shops', data: payload);
      if (res != null && res['data'] != null) {
        return ShopModel.fromJson(res['data']);
      }
    } catch (_) {}

    return ShopModel(
      id: 'shp_${DateTime.now().millisecondsSinceEpoch}',
      shopName: payload['name'] ?? 'New Shop',
      ownerName: payload['fullName'] ?? 'Owner',
      email: payload['email'] ?? '',
      phone: payload['phone'] ?? '',
      loginId: payload['loginId'] ?? 'shop_user',
      planName: 'Pro Plan',
      status: 'active',
      createdAt: DateTime.now().toIso8601String().substring(0, 10),
    );
  }

  Future<void> updateShopStatus(String shopId, String status) async {
    try {
      await apiClient.put('/admin/shops/$shopId/status', data: {'status': status});
    } catch (_) {}
  }
}
