import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class SubscriptionRemoteDataSource {
  final DioClient dioClient;

  SubscriptionRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getSubscriptions({
    String? status,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (status != null && status.isNotEmpty && status != 'all') queryParams['status'] = status;

    final response = await dioClient.get(
      ApiEndpoints.subscriptions,
      queryParameters: queryParams,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> getSubscriptionById(String id) async {
    final response = await dioClient.get(ApiEndpoints.subscriptionDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
