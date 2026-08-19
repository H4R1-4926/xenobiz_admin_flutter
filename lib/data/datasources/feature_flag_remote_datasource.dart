import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class FeatureFlagRemoteDataSource {
  final DioClient dioClient;

  FeatureFlagRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getFeatureFlags() async {
    final response = await dioClient.get(ApiEndpoints.featureFlags);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> toggleFeatureFlag(String key) async {
    final response = await dioClient.put(ApiEndpoints.featureFlagToggle(key));
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateFeatureFlag(String key, Map<String, dynamic> data) async {
    final response = await dioClient.put(ApiEndpoints.featureFlagDetail(key), data: data);
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
