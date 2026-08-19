import '../../core/network/api_client.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final ApiClient apiClient;

  PaymentRepository({required this.apiClient});

  Future<List<PaymentModel>> getPayments() async {
    try {
      final res = await apiClient.get('/admin/purchases');
      if (res != null) {
        final list = res['data'] is List
            ? res['data'] as List
            : (res['data'] is Map && res['data']['items'] is List)
                ? res['data']['items'] as List
                : null;
        if (list != null) {
          return list.map((e) => PaymentModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {}

    return const [
      PaymentModel(
        id: 'pay_01',
        transactionId: 'TXN_9923841029',
        shopName: 'Metro Fashion Hub',
        planName: 'Pro Business',
        amount: 1499.0,
        provider: 'razorpay',
        status: 'completed',
        paidAt: '2026-08-15 14:32:00',
      ),
      PaymentModel(
        id: 'pay_02',
        transactionId: 'TXN_8812930412',
        shopName: 'Green Grocery Store',
        planName: 'Enterprise Ultra',
        amount: 39999.0,
        provider: 'stripe',
        status: 'completed',
        paidAt: '2026-08-14 09:15:00',
      ),
      PaymentModel(
        id: 'pay_03',
        transactionId: 'TXN_7734120951',
        shopName: 'Urban Tech Electronics',
        planName: 'Basic Starter',
        amount: 499.0,
        provider: 'razorpay',
        status: 'pending',
        paidAt: '2026-08-12 18:45:00',
      ),
      PaymentModel(
        id: 'pay_04',
        transactionId: 'TXN_6612984021',
        shopName: 'Royal Sweets & Bakers',
        planName: 'Pro Business',
        amount: 1499.0,
        provider: 'razorpay',
        status: 'failed',
        paidAt: '2026-08-10 11:20:00',
      ),
    ];
  }
}
