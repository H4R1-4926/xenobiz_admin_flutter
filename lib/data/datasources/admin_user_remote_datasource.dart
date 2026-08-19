import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AdminUserRemoteDataSource {
  final DioClient dioClient;

  AdminUserRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getAdmins() async {
    final response = await dioClient.get(ApiEndpoints.admins);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> createAdmin(Map<String, dynamic> data) async {
    final response = await dioClient.post(ApiEndpoints.admins, data: data);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateAdmin(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put(ApiEndpoints.adminDetail(id), data: data);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updateAdminStatus(String id, String status) async {
    final response = await dioClient.put(ApiEndpoints.adminStatus(id), data: {'status': status});
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> resetAdminPassword(String id, String newPassword) async {
    final response = await dioClient.post(ApiEndpoints.adminResetPassword(id), data: {'password': newPassword});
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> deleteAdmin(String id) async {
    final response = await dioClient.delete(ApiEndpoints.adminDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
