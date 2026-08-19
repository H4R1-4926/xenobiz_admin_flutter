import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.data,
  });

  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timed out. Please check backend server status.',
          statusCode: 408,
          code: 'TIMEOUT',
        );

      case DioExceptionType.badResponse:
        final response = dioError.response;
        final statusCode = response?.statusCode;
        final responseData = response?.data;

        String message = 'An unexpected server error occurred.';
        String? code;

        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? responseData['error'] ?? message;
          code = responseData['code'];
        }

        switch (statusCode) {
          case 400:
            return ApiException(
              message: message,
              statusCode: 400,
              code: code ?? 'BAD_REQUEST',
              data: responseData,
            );
          case 401:
            return ApiException(
              message: message.isNotEmpty ? message : 'Unauthorized access. Please login again.',
              statusCode: 401,
              code: code ?? 'UNAUTHORIZED',
            );
          case 403:
            return ApiException(
              message: message.isNotEmpty ? message : 'Access forbidden. You do not have permission.',
              statusCode: 403,
              code: code ?? 'FORBIDDEN',
            );
          case 404:
            return ApiException(
              message: message.isNotEmpty ? message : 'Requested resource not found.',
              statusCode: 404,
              code: code ?? 'NOT_FOUND',
            );
          case 409:
            return ApiException(
              message: message,
              statusCode: 409,
              code: code ?? 'CONFLICT',
            );
          case 422:
            return ApiException(
              message: message,
              statusCode: 422,
              code: code ?? 'VALIDATION_ERROR',
            );
          case 500:
          default:
            return ApiException(
              message: 'Server error ($statusCode): $message',
              statusCode: statusCode ?? 500,
              code: code ?? 'SERVER_ERROR',
            );
        }

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
          code: 'CANCELLED',
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Unable to connect to Xenobiz Backend API. Please check your internet/local server.',
          statusCode: 503,
          code: 'NO_CONNECTION',
        );

      default:
        return ApiException(
          message: dioError.message ?? 'An unknown network error occurred.',
          code: 'UNKNOWN',
        );
    }
  }

  @override
  String toString() => message;
}
