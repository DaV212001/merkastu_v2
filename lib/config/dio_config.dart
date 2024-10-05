import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/constants/constants.dart';

class DioConfig {
  static Dio dio() {
    return Dio(
      BaseOptions(
        baseUrl: kApiBaseUrl,
        validateStatus: (status) => true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );
  }

  static String convertDioError(DioException e) {
    String errorMessage = 'Unknown error occurred';
    switch (e.type) {
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage =
            'HTTP error ${e.response!.statusCode}: ${e.response!.statusMessage}';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Other Dio error occurred';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate, try switching devices';
      case DioExceptionType.connectionError:
        errorMessage = 'Connection error, check your internet';
    }
    return errorMessage;
  }
}

class DioService {
  static Future<Response> dioPost({
    required String path,
    Options? options,
    Object? data,
  }) async {
    var response;
    try {
      response = await DioConfig.dio().post(path, options: options, data: data);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
    }
    return response;
  }

  static Future<Response> dioGet({
    required String path,
    Options? options,
    Object? data,
  }) async {
    var response;
    try {
      response = await DioConfig.dio().get(path, options: options, data: data);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
    }
    return response;
  }
}
