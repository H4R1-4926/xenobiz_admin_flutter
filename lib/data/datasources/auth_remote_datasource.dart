import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> login(String emailOrUsername, String password) async {
    final response = await dioClient.post(
      ApiEndpoints.login,
      data: {
        'emailOrUsername': emailOrUsername,
        'password': password,
      },
    );
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await dioClient.get(ApiEndpoints.me);
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await dioClient.post(ApiEndpoints.logout);
    return response as Map<String, dynamic>;
  }
}
