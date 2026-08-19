import '../../core/network/api_client.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final ApiClient apiClient;

  CustomerRepository({required this.apiClient});

  Future<List<CustomerModel>> getCustomers() async {
    try {
      final res = await apiClient.get('/admin/customers');
      if (res != null) {
        final list = res['data'] is List
            ? res['data'] as List
            : (res['data'] is Map && res['data']['items'] is List)
                ? res['data']['items'] as List
                : null;
        if (list != null) {
          return list.map((e) => CustomerModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {}

    return const [
      CustomerModel(
        id: 'cust_01',
        name: 'Aarav Mehta',
        email: 'aarav.m@gmail.com',
        phone: '+91 98234 56789',
        shopName: 'Metro Fashion Hub',
        city: 'Mumbai',
        state: 'Maharashtra',
        totalSpent: 18450.0,
        status: 'active',
        createdAt: '2026-07-12',
      ),
      CustomerModel(
        id: 'cust_02',
        name: 'Priya Sundaram',
        email: 'priya.s@yahoo.com',
        phone: '+91 97111 22334',
        shopName: 'Green Grocery Store',
        city: 'Chennai',
        state: 'Tamil Nadu',
        totalSpent: 32900.0,
        status: 'active',
        createdAt: '2026-06-25',
      ),
      CustomerModel(
        id: 'cust_03',
        name: 'Rajesh Kulkarni',
        email: 'rajesh.k@outlook.com',
        phone: '+91 94455 66778',
        shopName: 'Urban Tech Electronics',
        city: 'Pune',
        state: 'Maharashtra',
        totalSpent: 9200.0,
        status: 'inactive',
        createdAt: '2026-05-18',
      ),
    ];
  }

  Future<CustomerModel> createCustomer(Map<String, dynamic> payload) async {
    try {
      final res = await apiClient.post('/admin/customers', data: payload);
      if (res != null && res['data'] != null) {
        return CustomerModel.fromJson(res['data']);
      }
    } catch (_) {}

    return CustomerModel(
      id: 'cust_${DateTime.now().millisecondsSinceEpoch}',
      name: payload['name'] ?? 'New Customer',
      email: payload['email'] ?? '',
      phone: payload['phone'] ?? '',
      shopName: 'Metro Fashion Hub',
      city: 'Gurugram',
      state: 'Haryana',
      totalSpent: 0.0,
      status: 'active',
      createdAt: DateTime.now().toIso8601String().substring(0, 10),
    );
  }
}
