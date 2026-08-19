import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class CustomerRemoteDataSource {
  final DioClient dioClient;

  CustomerRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getCustomers({
    String? search,
    String? status,
    String? shopId,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (status != null && status.isNotEmpty && status != 'all') queryParams['status'] = status;
    if (shopId != null && shopId.isNotEmpty) queryParams['shopId'] = shopId;

    final response = await dioClient.get(
      ApiEndpoints.customers,
      queryParameters: queryParams,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> getCustomerById(String id) async {
    final response = await dioClient.get(ApiEndpoints.customerDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> data) async {
    final response = await dioClient.post(ApiEndpoints.customers, data: data);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateCustomer(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(ApiEndpoints.customerDetail(id), data: data);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> deleteCustomer(String id) async {
    final response = await dioClient.delete(ApiEndpoints.customerDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
