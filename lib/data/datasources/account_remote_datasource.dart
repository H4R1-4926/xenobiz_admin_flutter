import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AccountRemoteDataSource {
  final DioClient dioClient;

  AccountRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getAccounts({
    String? search,
    String? status,
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
      ApiEndpoints.accounts,
      queryParameters: queryParams,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> getAccountById(String id) async {
    final response = await dioClient.get(ApiEndpoints.accountDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateAccountStatus(String id, String status) async {
    final response = await dioClient.put(
      ApiEndpoints.accountStatus(id),
      data: {'status': status},
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> createShop(Map<String, dynamic> shopData) async {
    final response = await dioClient.post(
      ApiEndpoints.shops,
      data: shopData,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateShop(String id, Map<String, dynamic> shopData) async {
    final response = await dioClient.put(
      ApiEndpoints.shopDetail(id),
      data: shopData,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> deleteShop(String id) async {
    final response = await dioClient.delete(ApiEndpoints.shopDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
