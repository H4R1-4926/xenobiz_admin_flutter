import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class CompanyRemoteDataSource {
  final DioClient dioClient;

  CompanyRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getCompanies({
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
      ApiEndpoints.companies,
      queryParameters: queryParams,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> getCompanyById(String id) async {
    final response = await dioClient.get(ApiEndpoints.companyDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateCompany(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(
      ApiEndpoints.companyDetail(id),
      data: data,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
