import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

import '../constants/assets.dart';
import 'error_data.dart';

class ErrorUtil {
  /// Returns an [ErrorData] object based on the provided [error] string.
  ///
  /// The function checks the [error] string for specific error codes and error messages
  /// and returns the corresponding [ErrorData] object. If the [error] string does not
  /// match any of the specific error codes or error messages, it returns an [ErrorData]
  /// object with a generic "Unknown Error" title, body, image, and button text.
  ///
  /// Parameters:
  /// - [error] (String): The error string to be checked.
  ///
  /// Returns:
  /// - [ErrorData]: An object containing the error title, body, image, and button text.
  static Future<ErrorData> getErrorData(String error) async {
    print("Here in error Util $error");

    var connectivityResult = await (Connectivity().checkConnectivity());
    Logger().d(connectivityResult);
    Logger().d(connectivityResult[0] == ConnectivityResult.none);
    if (connectivityResult[0] == ConnectivityResult.none) {
      return ErrorData(
        title: "No Internet Connection",
        body:
            "It seems that your internet connection is turned off. Please turn it on and try again.",
        image: 'assets/images/errors/no_connection.svg',
        buttonText: "Retry",
      );
    }

    if (error.contains("no_internet") ||
        error.toString().contains('No Internet Found') ||
        error.contains('Failed host lookup') ||
        error.contains('No address associated with hostname') ||
        error.contains('Connection refused') ||
        error.contains('Connection reset by peer') ||
        error.contains('ClientException with SocketException') ||
        error.contains('Connection timed out') ||
        error.contains('connection timeout') ||
        error.contains('receive timeout') ||
        error.contains('Connection closed')) {
      return ErrorData(
        title: "",
        body: "Please check your internet connection and try again.",
        image: 'assets/images/errors/no_connection.svg',
        buttonText: "Refresh",
      );
    } else if (error.contains("500") ||
        error.toString().contains('Internal Server Error')) {
      return ErrorData(
        title: "Internal Server Error",
        body:
            "The server encountered an error and could not complete your request.",
        image: Assets.errorsInternalServer,
        buttonText: "Refresh",
      );
    } else if (error.contains("503")) {
      return ErrorData(
        title: "Service Unavailable",
        body: "The service is temporarily unavailable. Please try again later.",
        image: Assets.errorsServiceUnavailable,
        buttonText: "Refresh",
      );
    } else if (error.contains("404")) {
      return ErrorData(
        title: "Not Found",
        body: "The requested resource was not found on the server.",
        image: Assets.errorsNotFound,
        buttonText: "Refresh",
      );
    } else if (error.contains("504")) {
      return ErrorData(
        title: "Gateway Timeout",
        body:
            "The gateway did not receive a timely response from the upstream server.",
        image: Assets.errorsGatewayTimeout,
        buttonText: "Refresh",
      );
    } else if (error.contains("401")) {
      return ErrorData(
        title: "Unauthorized",
        body: "You are not authorized to access this resource.",
        image: Assets.errorsUnauthorized,
        buttonText: "Refresh",
      );
    } else if (error.contains("403")) {
      return ErrorData(
        title: "Forbidden",
        body: "You do not have permission to access this resource.",
        image: Assets.errorsForbidden,
        buttonText: "Go Back",
      );
    } else if (error.contains("429")) {
      return ErrorData(
        title: "Too Many Requests",
        body: "You have sent too many requests in a given amount of time.",
        image: Assets.errorsTooManyRequests,
        buttonText: "Retry",
      );
    } else if (error.startsWith('custom')) {
      return ErrorData(
        title: "Error",
        body: error.replaceFirst('custom', ''),
        image: Assets.errorsUnknown,
        buttonText: "Refresh",
      );
    } else {
      return ErrorData(
        title: "Unknown Error",
        body: 'An unexpected error occured, please try later',
        image: Assets.errorsUnknown,
        buttonText: "Refresh",
      );
    }
  }
}
