import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class PurchaseRemoteDataSource {
  final DioClient dioClient;

  PurchaseRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getPurchases({
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
      ApiEndpoints.purchases,
      queryParameters: queryParams,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> getPurchaseById(String id) async {
    final response = await dioClient.get(ApiEndpoints.purchaseDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
