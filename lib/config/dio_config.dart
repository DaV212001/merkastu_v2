import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/utils/payment_methods.dart';
import 'package:path_provider/path_provider.dart';

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

  static Future<void> dioPostFormData({
    required String path,
    required FormData formData,
    Options? options,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    Response response = Response(requestOptions: RequestOptions());
    try {
      response =
          await DioConfig.dio().post(path, data: formData, options: options);
      Logger().d(response.data);
      if (onSuccess != null) onSuccess(response);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
      print(response?.data ?? 'No response');
      print(e.toString());
      print(stack);
      if (onFailure != null) onFailure(e, response);
    }
  }

  static Future<void> dioGet({
    required String path,
    Options? options,
    Object? data,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    var response;
    try {
      response = await DioConfig.dio().get(path, options: options, data: data);
      print(response.data);
      Logger().d(response.data);
      if (onSuccess != null) onSuccess(response);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
      print(response.data);
      print(e.toString());
      print(stack);
      if (onFailure != null) onFailure(e, response);
    }
  }

  static Future<void> dioDownload({
    required String path,
    Options? options,
    Object? data,
    Function(Response, String, File)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    // AndroidCarrierData? carrierInfo = await CarrierInfo.getAndroidInfo();
    // if (carrierInfo != null && carrierInfo.telephonyInfo.isNotEmpty) {
    //   String carrierName = carrierInfo.telephonyInfo.first.carrierName;
    //   Logger().d(carrierName);
    // } else {
    //   Logger().d('No carrier info');
    // }

    var response;
    try {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory?.path}/receipt.pdf';
      final pdfFile = File(filePath);
      var dioCertBypass = Dio();

      (dioCertBypass.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      response = await dioCertBypass.download(path, filePath,
          options: options, data: data);
      print(response.data);
      Logger().d(response.data);
      if (onSuccess != null) onSuccess(response, filePath, pdfFile);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
      print(response.data);
      print(e.toString());
      print(stack);
      if (onFailure != null) onFailure(e, response);
    }
  }

  static Future<void> _uploadFile({
    required File file,
    required String filePath,
    required String path,
    required String orderId,
    required String paymentMethod,
    Options? options,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    final formData = FormData.fromMap({
      "receipt": await MultipartFile.fromFile(filePath,
          filename: file.uri.pathSegments.last),
      "orderId": orderId,
      "paymentMethod": paymentMethod,
    });

    await dioPostFormData(
      path: path,
      formData: formData,
      options: options,
      onSuccess: (res) async {
        onSuccess?.call(res);
        if ((res.statusCode == 200 || res.statusCode == 201) &&
            res.data['status'] &&
            await file.exists()) {
          await file.delete();
          Logger().d('$paymentMethod file deleted successfully');
        }
      },
      onFailure: onFailure,
    );
  }

  static Future<void> handleCbePayment({
    required String transactionId,
    required String orderId,
    required String path,
    Options? options,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    final cbeUrl = '$transactionId';
    await dioDownload(
      path: cbeUrl,
      onSuccess: (response, filePath, file) async {
        await _uploadFile(
          file: file,
          filePath: filePath,
          path: path,
          orderId: orderId,
          paymentMethod: "CBE",
          options: options,
          onSuccess: onSuccess,
          onFailure: onFailure,
        );
      },
      onFailure: onFailure,
    );
  }

  static Future<void> handleTeleBirrPayment({
    required String transactionId,
    required String orderId,
    required String path,
    Options? options,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    // await Permission.phone.request();
    // List<SimInfo>? _simInfo;
    // final _simCardInfoPlugin = SimCardInfo();
    // _simInfo = await _simCardInfoPlugin.getSimInfo() ?? [];
    // if (_simInfo != null && _simInfo.isNotEmpty) {
    //   String carrierName = _simInfo[0].carrierName;
    //   Logger().d(carrierName);
    // } else {
    //   Logger().d('No carrier info');
    // }

    final teleBirrUrl = '$transactionId';
    await dioGet(
      path: teleBirrUrl,
      onSuccess: (res) async {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/receipt.html';
        final file = await File(filePath).writeAsString(res.data.toString());

        await _uploadFile(
          file: file,
          filePath: filePath,
          path: path,
          orderId: orderId,
          paymentMethod: "TELEBIRR",
          options: options,
          onSuccess: onSuccess,
          onFailure: onFailure,
        );
      },
      onFailure: onFailure,
    );
  }

  static Future<void> dioTwoProngedRequest({
    required String path,
    required PaymentMethod paymentMethod,
    required String transactionId,
    required String orderId,
    Options? options,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    if (paymentMethod == PaymentMethod.cbe) {
      await handleCbePayment(
        transactionId: transactionId,
        orderId: orderId,
        path: path,
        options: options,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    } else if (paymentMethod == PaymentMethod.teleBirr) {
      await handleTeleBirrPayment(
        transactionId: transactionId,
        orderId: orderId,
        path: path,
        options: options,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    } else if (paymentMethod == PaymentMethod.wallet) {
      final formData = FormData.fromMap({
        // "receipt": await MultipartFile.fromFile(filePath,
        //     filename: file.uri.pathSegments.last),
        "orderId": orderId,
        "paymentMethod": paymentMethod.name,
      });
      Logger().d(formData.fields);
      await dioPostFormData(
        path: path,
        formData: formData,
        options: options,
        onSuccess: (res) async {
          var response = res;
          if (onSuccess != null)
            onSuccess(response != null
                ? response
                : Response(requestOptions: RequestOptions()));
          if ((res.statusCode == 200 || res.statusCode == 201) &&
              res.data['status']) {
            // await file.delete();
            Logger().d('$paymentMethod file deleted successfully');
          }
        },
        onFailure: onFailure,
      );
    }
  }
}
