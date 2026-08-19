import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class DashboardRemoteDataSource {
  final DioClient dioClient;

  DashboardRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getDashboardSummary() async {
    final response = await dioClient.get(ApiEndpoints.dashboardSummary);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> getHealth() async {
    final response = await dioClient.get(ApiEndpoints.health);
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
