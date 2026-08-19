import 'package:flutter/foundation.dart';
import '../datasources/audit_log_remote_datasource.dart';
import '../models/audit_log_model.dart';

class AuditLogRepository {
  final AuditLogRemoteDataSource remoteDataSource;

  AuditLogRepository(this.remoteDataSource);

  Future<List<AuditLogModel>> getAuditLogs({
    String? search,
    String? action,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final response = await remoteDataSource.getAuditLogs(
        search: search,
        action: action,
        page: page,
        limit: limit,
      );

      final rawList = response['data'] ?? response['items'] ?? response;
      if (rawList is List) {
        return rawList.map((item) => AuditLogModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('AuditLogRepository getAuditLogs error: $e');
    }
    return [];
  }
}
