import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio;
  static const String baseUrl = 'http://localhost:3000/api/v1';

  ApiClient({Dio? customDio})
      : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('xenobiz_admin_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle session expiry
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    final response = await dio.post(path, data: data);
    return response.data;
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    final response = await dio.put(path, data: data);
    return response.data;
  }

  Future<dynamic> delete(String path) async {
    final response = await dio.delete(path);
    return response.data;
  }
}
