import 'package:get/get.dart';

import '../config/dio_config.dart';
import '../utils/api_call_status.dart';
import '../utils/error_data.dart';
import '../utils/error_utils.dart';

enum AppInfoAppType { DELIVERYPERSONAPP, USERAPP }

enum AppInfoType {
  ABOUT,
  PRIVACY_POLICY,
  TERM_AND_CONDITIONS,
  REFUND_POLICY,
  CANCELATION_POLICY,
  SHIPPING_POLICY,
}

class AppInfoController extends GetxController {
  AppInfoAppType appInfoAppType = AppInfoAppType.USERAPP;
  var appInfoAbout = ''.obs;

  var appInfoPrivacyPolicy = ''.obs;

  var appInfoTermsAndConditions = ''.obs;

  var appInfoRefundPolicy = ''.obs;

  var appInfoCancellationPolicy = ''.obs;

  var appInfoShippingPolicy = ''.obs;

  var gettingAbout = ApiCallStatus.holding.obs;

  var gettingPrivacyPolicy = ApiCallStatus.holding.obs;

  var gettingTermsAndConditions = ApiCallStatus.holding.obs;

  var gettingRefundPolicy = ApiCallStatus.holding.obs;

  var gettingCancellationPolicy = ApiCallStatus.holding.obs;

  var gettingShippingPolicy = ApiCallStatus.holding.obs;

  var errorGettingAbout = ErrorData(title: '', body: '', image: '');

  var errorGettingPrivacyPolicy = ErrorData(title: '', body: '', image: '');

  var errorGettingTermsAndConditions =
      ErrorData(title: '', body: '', image: '');

  var errorGettingRefundPolicy = ErrorData(title: '', body: '', image: '');

  var errorGettingCancellationPolicy =
      ErrorData(title: '', body: '', image: '');

  var errorGettingShippingPolicy = ErrorData(title: '', body: '', image: '');

  void fetchAbout() async {
    gettingAbout.value = ApiCallStatus.loading;
    errorGettingAbout = ErrorData(title: '', body: '', image: '');
    await DioService.dioGet(
      path:
          '/app-info?appType=${appInfoAppType.name}&infoType=${AppInfoType.ABOUT.name}',
      onSuccess: (res) {
        if ((res.statusCode == 200 || res.statusCode == 201) &&
            res.data['status']) {
          appInfoAbout.value = res.data['data']['content'];
        }
        gettingAbout.value = ApiCallStatus.success;
      },
      onFailure: (e, res) async {
        errorGettingAbout =
            await ErrorUtil.getErrorData(res.statusCode.toString());
        gettingAbout.value = ApiCallStatus.error;
      },
    );
  }

  void fetchPrivacyPolicy() async {
    gettingPrivacyPolicy.value = ApiCallStatus.loading;
    errorGettingPrivacyPolicy = ErrorData(title: '', body: '', image: '');
    await DioService.dioGet(
      path:
          '/app-info?appType=${appInfoAppType.name}&infoType=${AppInfoType.PRIVACY_POLICY.name}',
      onSuccess: (res) {
        if ((res.statusCode == 200 || res.statusCode == 201) &&
            res.data['status']) {
          appInfoPrivacyPolicy.value = res.data['data']['content'];
        }
        gettingPrivacyPolicy.value = ApiCallStatus.success;
      },
      onFailure: (e, res) async {
        errorGettingPrivacyPolicy =
            await ErrorUtil.getErrorData(res.statusCode.toString());
        gettingPrivacyPolicy.value = ApiCallStatus.error;
      },
    );
  }

  void fetchTermsAndConditions() async {
    gettingTermsAndConditions.value = ApiCallStatus.loading;
    errorGettingTermsAndConditions = ErrorData(title: '', body: '', image: '');
    await DioService.dioGet(
      path:
          '/app-info?appType=${appInfoAppType.name}&infoType=${AppInfoType.TERM_AND_CONDITIONS.name}',
      onSuccess: (res) {
        if ((res.statusCode == 200 || res.statusCode == 201) &&
            res.data['status']) {
          appInfoTermsAndConditions.value = res.data['data']['content'];
        }
        gettingTermsAndConditions.value = ApiCallStatus.success;
      },
      onFailure: (e, res) async {
        errorGettingTermsAndConditions =
            await ErrorUtil.getErrorData(res.statusCode.toString());
        gettingTermsAndConditions.value = ApiCallStatus.error;
      },
    );
  }

  void fetchRefundPolicy() async {
    gettingRefundPolicy.value = ApiCallStatus.loading;
    errorGettingRefundPolicy = ErrorData(title: '', body: '', image: '');
    await DioService.dioGet(
      path:
          '/app-info?appType=${appInfoAppType.name}&infoType=${AppInfoType.REFUND_POLICY.name}',
      onSuccess: (res) {
        if ((res.statusCode == 200 || res.statusCode == 201) &&
            res.data['status']) {
          appInfoRefundPolicy.value = res.data['data']['content'];
        }
        gettingRefundPolicy.value = ApiCallStatus.success;
      },
      onFailure: (e, res) async {
        errorGettingRefundPolicy =
            await ErrorUtil.getErrorData(res.statusCode.toString());
        gettingRefundPolicy.value = ApiCallStatus.error;
      },
    );
  }

  void fetchCancellationPolicy() async {
    gettingCancellationPolicy.value = ApiCallStatus.loading;
    errorGettingCancellationPolicy = ErrorData(title: '', body: '', image: '');
    await DioService.dioGet(
      path:
          '/app-info?appType=${appInfoAppType.name}&infoType=${AppInfoType.CANCELATION_POLICY.name}',
      onSuccess: (res) {
        if ((res.statusCode == 200 || res.statusCode == 201) &&
            res.data['status']) {
          appInfoCancellationPolicy.value = res.data['data']['content'];
        }
        gettingCancellationPolicy.value = ApiCallStatus.success;
      },
      onFailure: (e, res) async {
        errorGettingCancellationPolicy =
            await ErrorUtil.getErrorData(res.statusCode.toString());
        gettingCancellationPolicy.value = ApiCallStatus.error;
      },
    );
  }

  void fetchShippingPolicy() async {
    gettingShippingPolicy.value = ApiCallStatus.loading;
    errorGettingShippingPolicy = ErrorData(title: '', body: '', image: '');
    await DioService.dioGet(
      path:
          '/app-info?appType=${appInfoAppType.name}&infoType=${AppInfoType.SHIPPING_POLICY.name}',
      onSuccess: (res) {
        if ((res.statusCode == 200 || res.statusCode == 201) &&
            res.data['status']) {
          appInfoShippingPolicy.value = res.data['data']['content'];
        }
        gettingShippingPolicy.value = ApiCallStatus.success;
      },
      onFailure: (e, res) async {
        errorGettingShippingPolicy =
            await ErrorUtil.getErrorData(res.statusCode.toString());
        gettingShippingPolicy.value = ApiCallStatus.error;
      },
    );
  }
}
