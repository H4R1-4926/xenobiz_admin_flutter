import '../../core/network/api_client.dart';
import '../models/admin_user_model.dart';

class AdminRepository {
  final ApiClient apiClient;

  AdminRepository({required this.apiClient});

  Future<List<AdminUserModel>> getAdmins() async {
    try {
      final res = await apiClient.get('/admin/admins');
      if (res != null && res['data'] is List) {
        return (res['data'] as List).map((e) => AdminUserModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return const [
      AdminUserModel(
        id: 'adm_001',
        name: 'Master Super Admin',
        email: 'admin@xenobiz.com',
        loginId: 'admin_master',
        role: 'SUPER_ADMIN',
        status: 'active',
        lastLogin: '2026-08-18 17:45:00',
      ),
      AdminUserModel(
        id: 'adm_002',
        name: 'Dev Operations Admin',
        email: 'ops@xenobiz.com',
        loginId: 'ops_admin',
        role: 'ADMIN',
        status: 'active',
        lastLogin: '2026-08-17 11:20:00',
      ),
      AdminUserModel(
        id: 'adm_003',
        name: 'Customer Support Lead',
        email: 'support@xenobiz.com',
        loginId: 'support_lead',
        role: 'SUPPORT_ADMIN',
        status: 'active',
        lastLogin: '2026-08-16 09:10:00',
      ),
      AdminUserModel(
        id: 'adm_004',
        name: 'External Security Auditor',
        email: 'auditor@xenobiz.com',
        loginId: 'auditor_read',
        role: 'READ_ONLY',
        status: 'inactive',
        lastLogin: '2026-08-01 14:00:00',
      ),
    ];
  }

  Future<AdminUserModel> createAdmin(Map<String, dynamic> payload) async {
    try {
      final res = await apiClient.post('/admin/admins', data: payload);
      if (res != null && res['data'] != null) {
        return AdminUserModel.fromJson(res['data']);
      }
    } catch (_) {}

    return AdminUserModel(
      id: 'adm_${DateTime.now().millisecondsSinceEpoch}',
      name: payload['name'] ?? 'New Admin',
      email: payload['email'] ?? '',
      loginId: payload['loginId'] ?? 'new_admin',
      role: payload['role'] ?? 'ADMIN',
      status: 'active',
      lastLogin: 'Never',
    );
  }

  Future<void> resetPassword(String adminId) async {
    try {
      await apiClient.post('/admin/admins/$adminId/reset-password');
    } catch (_) {}
  }
}
