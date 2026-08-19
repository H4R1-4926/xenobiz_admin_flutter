import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/config/app_config.dart';
import '../errors/api_exception.dart';

class ApiInterceptor extends Interceptor {
  String? _authToken;
  String? _selectedBusinessId;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  void setSelectedBusinessId(String? businessId) {
    _selectedBusinessId = businessId;
  }

  String? get authToken => _authToken;
  String? get selectedBusinessId => _selectedBusinessId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // If in-memory token is null, try reading from SharedPreferences
    if (_authToken == null || _authToken!.isEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        _authToken = prefs.getString(AppConfig.tokenKey);
        _selectedBusinessId ??= prefs.getString(AppConfig.businessIdKey);
      } catch (_) {}
    }

    if (_authToken != null && _authToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_authToken';
    }

    if (_selectedBusinessId != null && _selectedBusinessId!.isNotEmpty) {
      options.headers['x-business-id'] = _selectedBusinessId;
    }

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    if (kDebugMode) {
      debugPrint('--> ${options.method.toUpperCase()} ${options.uri}');
      if (options.data != null) {
        debugPrint('Headers: ${options.headers}');
        debugPrint('Body: ${options.data}');
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('Message: ${err.message}');
    }

    final apiException = ApiException.fromDioError(err);
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
      ),
    );
  }
}
