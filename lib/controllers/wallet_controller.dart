import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/utils/payment_methods.dart';

import '../config/dio_config.dart';
import '../config/storage_config.dart';
import '../models/wallet_transaction.dart';
import '../models/withdrawal_request.dart';
import '../utils/api_call_status.dart';
import '../utils/error_data.dart';
import '../utils/error_utils.dart';

class WalletController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var walletHistory = <WalletTransaction>[].obs;
  var gettingWalletHistory = ApiCallStatus.holding.obs;
  var errorGettingWalletHistory = ErrorData(title: '', body: '', image: '').obs;
  var depositHistory = <WalletTransaction>[].obs;
  var withdrawalHistory = <WalletTransaction>[].obs;

  var withdrawalRequests = <WithdrawalRequest>[].obs;
  var gettingWithdrawalRequests = ApiCallStatus.holding.obs;
  var errorGettingWithdrawalRequests =
      ErrorData(title: '', body: '', image: '').obs;

  void fetchWithdrawalRequests() async {
    gettingWithdrawalRequests.value = ApiCallStatus.loading;
    errorGettingWithdrawalRequests.value =
        ErrorData(title: '', body: '', image: '');
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get('/user/wallet/withdraw-requests',
          options: dio.Options(
              headers: {'Authorization': ConfigPreference.getUserToken()}));
      if (response.statusCode == 200 && response.data['status'] == true) {
        withdrawalRequests.value = (response.data['data'] as List)
            .map((e) => WithdrawalRequest.fromJson(e))
            .toList();
        gettingWithdrawalRequests.value = ApiCallStatus.success;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      errorGettingWithdrawalRequests.value =
          await ErrorUtil.getErrorData(e.toString());
      gettingWithdrawalRequests.value = ApiCallStatus.error;
    }
  }

  void fetchWalletHistory() async {
    gettingWalletHistory.value = ApiCallStatus.loading;
    errorGettingWalletHistory.value = ErrorData(title: '', body: '', image: '');
    fetchWithdrawalRequests();
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get('/user/wallet/get-history',
          options: dio.Options(
              headers: {'Authorization': ConfigPreference.getUserToken()}));
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        walletHistory.value = (response.data['data']['history'] as List)
            .map((e) => WalletTransaction.fromJson(e))
            .toList();
        depositHistory.value = walletHistory
            .where((walletHistory) =>
                walletHistory.transactionType == TransactionType.deposit)
            .toList();
        withdrawalHistory.value = walletHistory
            .where((walletHistory) =>
                walletHistory.transactionType == TransactionType.withdrawal)
            .toList();
        gettingWalletHistory.value = ApiCallStatus.success;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      gettingWalletHistory.value = ApiCallStatus.error;
      errorGettingWalletHistory.value =
          await ErrorUtil.getErrorData(e.toString());
    }
  }

  var requestingWithdrawal = false.obs;
  var amountToWithdraw = ''.obs;
  var withdrawalPaymentMethod = PaymentMethod.none.obs;
  var withdrawalAccountNumber = ''.obs;

  var errorRequestingWithdrawal = ErrorData(title: '', body: '', image: '').obs;
  void requestWithdrawal() async {
    requestingWithdrawal.value = true;
    errorRequestingWithdrawal.value = ErrorData(title: '', body: '', image: '');
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      var body = {
        'amount': num.parse(amountToWithdraw.value).toInt(),
        'paymentMethod': withdrawalPaymentMethod.value.name.toUpperCase(),
        'paymentAccount': withdrawalAccountNumber.value
      };
      Logger().d(body);
      response = await DioConfig.dio().post(
        '/user/wallet/withraw',
        options: dio.Options(
          headers: {
            'Authorization': ConfigPreference.getUserToken(),
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode(
          body,
        ),
      );

      Logger().d(response.data);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status'] == true) {
        requestingWithdrawal.value = false;
        withdrawalAccountNumber.value = '';
        amountToWithdraw.value = '';
        withdrawalPaymentMethod.value = PaymentMethod.none;
        Get.back();
        Get.snackbar(
          'Withdrawal Request',
          'Withdrawal request sent successfully',
        );
        fetchWalletHistory();
      } else {
        throw 'custom' + response.data['message'];
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      requestingWithdrawal.value = false;
      errorRequestingWithdrawal.value =
          await ErrorUtil.getErrorData(e.toString());
      String errorString = (await ErrorUtil.getErrorData(e.toString())).body;
      if (errorString.startsWith('custom')) {
        errorString = errorString.replaceFirst('custom', '');
      }
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.none) {
        errorString = 'No internet connection';
      }
      if (e is FormatException) {
        errorString =
            'Unexpected error occured while requesting withdrawal, please try again';
      }
      Get.snackbar('Error', e.toString());
    }
  }

  late TabController tabController;
  @override
  void onInit() {
    fetchWalletHistory();
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }
}
