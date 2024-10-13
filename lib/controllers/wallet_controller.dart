import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/storage_config.dart';
import 'package:merkastu_v2/models/wallet_transaction.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/utils/error_utils.dart';

import '../config/dio_config.dart';

class WalletController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var walletHistory = <WalletTransaction>[].obs;
  var gettingWalletHistory = ApiCallStatus.holding.obs;
  var errorGettingWalletHistory = ErrorData(title: '', body: '', image: '').obs;
  var depositHistory = <WalletTransaction>[].obs;
  var withdrawalHistory = <WalletTransaction>[].obs;

  void fetchWalletHistory() async {
    gettingWalletHistory.value = ApiCallStatus.loading;
    errorGettingWalletHistory.value = ErrorData(title: '', body: '', image: '');
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get('/user/wallet/get-history',
          options: dio.Options(
              headers: {'Authorization': ConfigPreference.getUserToken()}));
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

  late TabController tabController;
  @override
  void onInit() {
    fetchWalletHistory();
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}
