import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class PlanRemoteDataSource {
  final DioClient dioClient;

  PlanRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> getPlans() async {
    final response = await dioClient.get(ApiEndpoints.plans);
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> getPlanById(String id) async {
    final response = await dioClient.get(ApiEndpoints.planDetail(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> createPlan(Map<String, dynamic> planData) async {
    final response = await dioClient.post(
      ApiEndpoints.plans,
      data: planData,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> updatePlan(String id, Map<String, dynamic> planData) async {
    final response = await dioClient.put(
      ApiEndpoints.planDetail(id),
      data: planData,
    );
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> togglePlanStatus(String id) async {
    final response = await dioClient.post(ApiEndpoints.planToggle(id));
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
