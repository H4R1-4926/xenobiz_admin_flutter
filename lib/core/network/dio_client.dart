import 'package:dio/dio.dart';
import '../../app/config/app_config.dart';
import '../errors/api_exception.dart';
import 'api_interceptor.dart';

class DioClient {
  late final Dio _dio;
  late final ApiInterceptor _apiInterceptor;

  DioClient() {
    _apiInterceptor = ApiInterceptor();
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(milliseconds: AppConfig.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeoutMs),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(_apiInterceptor);
  }

  ApiInterceptor get interceptor => _apiInterceptor;

  void setAuthToken(String? token) {
    _apiInterceptor.setAuthToken(token);
  }

  void setSelectedBusinessId(String? businessId) {
    _apiInterceptor.setSelectedBusinessId(businessId);
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw e.error is ApiException ? (e.error as ApiException) : ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw e.error is ApiException ? (e.error as ApiException) : ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw e.error is ApiException ? (e.error as ApiException) : ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw e.error is ApiException ? (e.error as ApiException) : ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  dynamic _handleResponse(Response response) {
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('success') && responseData['success'] == false) {
        throw ApiException(
          message: responseData['message'] ?? 'Request failed.',
          statusCode: response.statusCode,
          data: responseData,
        );
      }
      return responseData;
    }
    return responseData;
  }
}
