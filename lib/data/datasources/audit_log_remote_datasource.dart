import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AuditLogRemoteDataSource {
  final DioClient dioClient;

  AuditLogRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getAuditLogs({
    String? search,
    String? action,
    int page = 1,
    int limit = 100,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (action != null && action.isNotEmpty && action != 'all') queryParams['action'] = action;

    final response = await dioClient.get(
      ApiEndpoints.auditLogs,
      queryParameters: queryParams,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
