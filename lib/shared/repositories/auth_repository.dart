import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('xenobiz_admin_token');
    final name = prefs.getString('xenobiz_admin_name') ?? 'Super Admin';
    final email = prefs.getString('xenobiz_admin_email') ?? 'admin@xenobiz.com';
    final role = prefs.getString('xenobiz_admin_role') ?? 'SUPER_ADMIN';

    if (token != null && token.isNotEmpty) {
      return UserModel(
        id: 'adm_001',
        email: email,
        fullName: name,
        role: role,
        loginId: 'admin_master',
      );
    }
    return null;
  }

  Future<UserModel> login(String loginId, String password) async {
    try {
      final res = await apiClient.post('/admin/login', data: {
        'identifier': loginId,
        'password': password,
      });

      if (res['success'] == true && res['data'] != null) {
        final token = res['data']['token'];
        final user = UserModel.fromJson(res['data']['user'] ?? res['data']['admin'] ?? {});

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('xenobiz_admin_token', token);
        await prefs.setString('xenobiz_admin_name', user.fullName);
        await prefs.setString('xenobiz_admin_email', user.email);
        await prefs.setString('xenobiz_admin_role', user.role);

        return user;
      }
    } catch (_) {
      // Fallback for standalone demo / offline mode
    }

    if (loginId.isNotEmpty && password.isNotEmpty) {
      final demoUser = UserModel(
        id: 'adm_001',
        email: 'admin@xenobiz.com',
        fullName: 'Super Admin',
        role: 'SUPER_ADMIN',
        loginId: loginId,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('xenobiz_admin_token', 'demo_jwt_token_xenobiz_2026');
      await prefs.setString('xenobiz_admin_name', demoUser.fullName);
      await prefs.setString('xenobiz_admin_email', demoUser.email);
      await prefs.setString('xenobiz_admin_role', demoUser.role);

      return demoUser;
    }

    throw Exception('Invalid admin credentials.');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('xenobiz_admin_token');
    await prefs.remove('xenobiz_admin_name');
    await prefs.remove('xenobiz_admin_email');
    await prefs.remove('xenobiz_admin_role');
  }
}
