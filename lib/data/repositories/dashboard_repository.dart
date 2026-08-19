import 'package:flutter/foundation.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepository(this.remoteDataSource);

  Future<DashboardSummaryModel> getDashboardSummary() async {
    try {
      final response = await remoteDataSource.getDashboardSummary();
      final Map<String, dynamic> data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;
      return DashboardSummaryModel.fromJson(data);
    } catch (e) {
      debugPrint('DashboardRepository getDashboardSummary API error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkHealth() async {
    try {
      return await remoteDataSource.getHealth();
    } catch (e) {
      return {'status': 'down', 'message': e.toString()};
    }
  }
}

