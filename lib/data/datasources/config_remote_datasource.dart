import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class ConfigRemoteDataSource {
  final DioClient dioClient;

  ConfigRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getAppConfigs() async {
    final response = await dioClient.get(ApiEndpoints.appConfig);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateConfigCategory(String category, Map<String, dynamic> settings) async {
    final response = await dioClient.put(
      ApiEndpoints.appConfigCategory(category),
      data: settings,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
