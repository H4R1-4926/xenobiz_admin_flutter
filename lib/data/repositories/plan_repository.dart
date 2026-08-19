import 'package:flutter/foundation.dart';
import '../datasources/plan_remote_datasource.dart';
import '../models/plan_model.dart';

class PlanRepository {
  final PlanRemoteDataSource remoteDataSource;

  PlanRepository(this.remoteDataSource);

  Future<List<PlanModel>> getPlans() async {
    try {
      final response = await remoteDataSource.getPlans();
      final rawList = response['data'] ?? response['plans'] ?? response['items'] ?? response['rows'];
      if (rawList is List) {
        return rawList.map((item) => PlanModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('PlanRepository getPlans API error: $e');
      rethrow;
    }
  }

  Future<PlanModel?> getPlanById(String id) async {
    try {
      final response = await remoteDataSource.getPlanById(id);
      final data = response['data'] ?? response['plan'] ?? response;
      if (data is Map<String, dynamic>) {
        return PlanModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('PlanRepository getPlanById API error: $e');
      rethrow;
    }
    return null;
  }

  Future<PlanModel?> createPlan(Map<String, dynamic> planData) async {
    try {
      final response = await remoteDataSource.createPlan(planData);
      final data = response['data'] ?? response['plan'] ?? response;
      if (data is Map<String, dynamic>) {
        return PlanModel.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  Future<PlanModel?> updatePlan(String id, Map<String, dynamic> planData) async {
    try {
      final response = await remoteDataSource.updatePlan(id, planData);
      final data = response['data'] ?? response['plan'] ?? response;
      if (data is Map<String, dynamic>) {
        return PlanModel.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  Future<bool> togglePlanStatus(String id) async {
    try {
      await remoteDataSource.togglePlanStatus(id);
      return true;
    } catch (_) {
      return false;
    }
  }
}

