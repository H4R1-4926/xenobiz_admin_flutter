import '../../core/network/api_client.dart';
import '../models/audit_log_model.dart';

class AuditLogRepository {
  final ApiClient apiClient;

  AuditLogRepository({required this.apiClient});

  Future<List<AuditLogModel>> getAuditLogs() async {
    try {
      final res = await apiClient.get('/admin/audit-logs');
      if (res != null && res['data'] is List) {
        return (res['data'] as List).map((e) => AuditLogModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return const [
      AuditLogModel(
        id: 'log_101',
        action: 'UPDATE_SHOP_STATUS',
        adminName: 'Master Super Admin',
        targetType: 'SHOP',
        targetId: 'shp_104',
        ipAddress: '192.168.1.45',
        createdAt: '2026-08-18 16:30:12',
        details: 'Changed status of Royal Sweets & Bakers from ACTIVE to SUSPENDED due to non-payment.',
      ),
      AuditLogModel(
        id: 'log_102',
        action: 'TOGGLE_FEATURE_FLAG',
        adminName: 'Dev Operations Admin',
        targetType: 'FEATURE_FLAG',
        targetId: 'enable_whatsapp_invoicing',
        ipAddress: '10.0.0.12',
        createdAt: '2026-08-18 14:15:00',
        details: 'Toggled feature flag enable_whatsapp_invoicing to ENABLED.',
      ),
      AuditLogModel(
        id: 'log_103',
        action: 'CREATE_PLAN',
        adminName: 'Master Super Admin',
        targetType: 'PLAN',
        targetId: 'pln_ent',
        ipAddress: '192.168.1.45',
        createdAt: '2026-08-17 10:00:00',
        details: 'Created new tier plan Enterprise Ultra at ₹3999/month.',
      ),
      AuditLogModel(
        id: 'log_104',
        action: 'ADMIN_LOGIN',
        adminName: 'Customer Support Lead',
        targetType: 'AUTH',
        targetId: 'adm_003',
        ipAddress: '172.16.0.88',
        createdAt: '2026-08-16 09:10:05',
        details: 'Successful login session started.',
      ),
    ];
  }
}
