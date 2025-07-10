import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/socket_controller.dart';
import 'package:merkastu_v2/controllers/wallet_controller.dart';
import 'package:merkastu_v2/screens/settings/wallet/withdrawal_request_screen.dart';

import '../config/dio_config.dart';
import '../config/storage_config.dart';
import '../constants/constants.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/store.dart';
import '../utils/api_call_status.dart';
import '../utils/error_data.dart';
import '../utils/error_utils.dart';
import '../utils/order_calculation_helper.dart';
import '../utils/order_status.dart';
import '../utils/payment_methods.dart';
import 'order_controller.dart';

class OrderDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController orderDetailTabController;
  final socketController = Get.find<SocketController>(tag: 'socket');
  var orderPassed = Order().obs;
  @override
  void onInit() {
    orderDetailTabController = TabController(length: 2, vsync: this);
    socketController.setEventHandler(orderSocketEventHandler);
    socketController.setCancelOrderErrorHandler(orderCancellationError);
    socketController.setAcceptOrderErrorHandler(orderReceiptError);
    customInit();
    super.onInit();
  }

  void customInit() {
    if (Get.arguments != null && Get.arguments is Order) {
      orderPassed.value = Get.arguments;
      if (!orderPassed.value.isEqual(selectedOrder.value)) {
        fetchOrderDetail(); // Fetch full details of the passed order
      }
    } else {
      // Handle the error case (e.g., navigate back)
      Logger().e('No order passed to OrderDetailController');
      Get.back();
      Get.snackbar('Error', 'No order selected',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void orderSocketEventHandler(socketMessage) {
    // var orderListController = Get.find<OrderController>(tag: 'order');
    String acceptedOrderId = socketMessage['orderId'];
    if (acceptedOrderId == selectedOrder.value.id) {
      selectedOrder.value.orderStatus = OrderStatus.accepted;
      if (socketMessage.containsKey('deliverPersonDetail')) {
        selectedOrder.value.deliveryPerson =
            DeliveryPerson.fromJson(socketMessage['deliverPersonDetail']);
        selectedOrder.refresh();
      } else {
        Get.snackbar('Update',
            'This order has just been accepted by a delivery personnel');
        fetchOrderDetail();
      }
    }
  }

  void orderReceipt() {
    var payload = {
      'orderId': selectedOrder.value.id,
      'userId': UserController.user.value.id,
    };

    Logger().d(payload);
    socketController.socket.value.emit("userRecievedOrder", payload);

    selectedOrder.value.orderStatus = OrderStatus.delivered;
    OrderController.instance.fetchActiveOrders();
    OrderController.instance.fetchHistoryOrders();
    selectedOrder.refresh();
  }

  void orderReceiptError(data) {
    var orderId = data['orderId'];
    if (orderId == selectedOrder.value.id) {
      selectedOrder.value.orderStatus = OrderStatus.accepted;
      selectedOrder.refresh();
    }
  }

  var tempOrderStatus = OrderStatus.accepted.obs;

  var toWallet = true.obs;

  void orderCancel() {
    var payload = {
      'orderId': selectedOrder.value.id,
      'userId': UserController.user.value.id,
    };
    Logger().d(payload);
    socketController.socket.value.emit("userCanceledOrder", payload);
    tempOrderStatus.value = selectedOrder.value.orderStatus!;
    if (!toWallet.value) {
      var control = Get.put(WalletController(), tag: 'wallet');
      control.amountToWithdraw.value =
          selectedOrder.value.totalPrice.toString();
      Get.to(() => WithdrawalRequestScreen(
            fromCancel: true,
          ));
    }
    selectedOrder.value.orderStatus = OrderStatus.canceled;
    UserController.getWalletBalance();
    OrderController.instance.fetchActiveOrders();
    OrderController.instance.fetchHistoryOrders();
    selectedOrder.refresh();
  }

  void orderCancellationError(data) {
    Logger().d(data);
    if (data['orderId'] == selectedOrder.value.id) {
      selectedOrder.value.orderStatus = tempOrderStatus.value;
      Get.snackbar('Error', 'Couldn\'t cancel your order');
      selectedOrder.refresh();
    }
  }

  var selectedOrder = Order().obs;
  var productsInOrder = <Product>[].obs;
  var storesInOrder = <Store>[].obs;

  var groupedOrderProducts = <String, List<Product>>{}.obs;

  var gettingOrderDetail = ApiCallStatus.holding.obs;
  var errorGettingOrderDetail = ErrorData(title: '', body: '', image: '').obs;

  var accountNumberCBE = ''.obs;
  var accountNameCBE = ''.obs;

  var accountNameTel = ''.obs;
  var accountNumberTel = ''.obs;

  void fetchOrderDetail() async {
    gettingOrderDetail.value = ApiCallStatus.loading;
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get(
        '/user/order/get-order/${orderPassed.value.id}',
        options: dio.Options(
          headers: {
            'Authorization': ConfigPreference.getUserToken(),
          },
        ),
      );
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        productsInOrder.value =
            (response.data['data']['order_detail']['stores'] as List)
                .expand((store) => (store['order_items'] as List).map((item) =>
                    Product.fromOrderDetailJson(
                        item as Map<String, dynamic>, store['store_id'])))
                .toList();
        List<dynamic> bankAccounts = response.data['data']['order_detail']
                    ['stores'][0]
                .containsKey('bank_accounts')
            ? response.data['data']['order_detail']['stores'][0]
                ['bank_accounts']
            : {};
        accountNumberCBE.value = bankAccounts.firstWhereOrNull(
                (e) => e['bank_name'] == 'CBE')?['account_number'] ??
            '';
        accountNameCBE.value = bankAccounts.firstWhereOrNull(
                (e) => e['bank_name'] == 'CBE')?['account_name'] ??
            '';
        accountNumberTel.value = bankAccounts.firstWhereOrNull(
                (e) => e['bank_name'] == 'TELEBIRR')?['account_number'] ??
            '';
        accountNameTel.value = bankAccounts.firstWhereOrNull(
                (e) => e['bank_name'] == 'TELEBIRR')?['account_name'] ??
            '';

        productsInOrder.refresh();

        storesInOrder.value = (response.data['data']['order_detail']['stores']
                as List)
            .map((e) => Store.fromOrderDetailJson(e as Map<String, dynamic>))
            .toList();
        storesInOrder.refresh();
        groupedOrderProducts.value =
            OrdersHelper.groupOrderProductsByStoreId(productsInOrder);
        groupedOrderProducts.refresh();
        selectedOrder.value =
            Order.fromJson(response.data['data']['order_detail']);
        selectedOrder.refresh();
      } else {
        throw Exception(response.data);
      }
      gettingOrderDetail.value = ApiCallStatus.success;
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      errorGettingOrderDetail.value =
          await ErrorUtil.getErrorData(e.toString());
      gettingOrderDetail.value = ApiCallStatus.error;
    }
  }

  var selectedPaymentMethod = <String, PaymentMethod>{}.obs;

  var verifyingPayment = false.obs;
  var transactionId = ''.obs;
  // void verifyPayment() async {
  //   dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
  //   try {
  //     verifyingPayment.value = true;
  //     var body = {
  //       "orderId": selectedOrder.value.id,
  //       if (selectedPaymentMethod[selectedOrder.value.id] !=
  //           PaymentMethod.wallet)
  //         "referenceId": transactionId.value,
  //       if (selectedPaymentMethod[selectedOrder.value.id] !=
  //               PaymentMethod.none &&
  //           selectedPaymentMethod[selectedOrder.value.id] != null)
  //         "paymentMethod": selectedPaymentMethod[selectedOrder.value.id]?.name
  //     };
  //     Logger().i(body);
  //     response = await DioConfig.dio().post(
  //       '/user/payment/verify-order-payment',
  //       data: body,
  //       options: dio.Options(
  //         headers: {
  //           'Authorization': ConfigPreference.getUserToken(),
  //         },
  //         contentType: 'application/json',
  //       ),
  //     );
  //     Logger().d(response.data);
  //     if ((response.statusCode == 201 || response.statusCode == 200) &&
  //         response.data['status']) {
  //       transactionId.value = '';
  //       selectedOrder.value.payment = PaymentMethod.none;
  //       if (Get.isRegistered<OrderController>()) {
  //         var orderControl = Get.find<OrderController>(tag: 'order');
  //         orderControl.fetchActiveOrders();
  //       } else {
  //         var orderControl = Get.put(OrderController(), tag: 'order');
  //         orderControl.fetchActiveOrders();
  //       }
  //       Get.back();
  //       Get.snackbar('Success', 'Payment successfully verified',
  //           backgroundColor: maincolor, colorText: Colors.white);
  //     } else {
  //       throw Exception(response.data['message']);
  //     }
  //     verifyingPayment.value = false;
  //   } catch (e, stack) {
  //     Logger().t(e, stackTrace: stack);
  //     verifyingPayment.value = false;
  //     Get.snackbar('Error', 'Failed to verify payment, please try again');
  //   }
  // }
  void verifyPayment() async {
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    verifyingPayment.value = true;
    await DioService.dioTwoProngedRequest(
        path: '/user/payment/verify-order-payment',
        paymentMethod: selectedPaymentMethod[selectedOrder.value.id] !=
                    PaymentMethod.none &&
                selectedPaymentMethod[selectedOrder.value.id] != null
            ? selectedPaymentMethod[selectedOrder.value.id]!
            : selectedOrder.value.payment!,
        orderId: selectedOrder.value.id!,
        transactionId: transactionId.value,
        options: dio.Options(
          headers: {
            'Authorization': ConfigPreference.getUserToken(),
          },
          contentType: 'multipart/form-data',
        ),
        onSuccess: (res) async {
          Logger().d(res.data);
          if ((res.statusCode == 201 || res.statusCode == 200) &&
              res.data['status']) {
            transactionId.value = '';
            selectedOrder.value.payment = PaymentMethod.none;
            if (Get.isRegistered<OrderController>()) {
              var orderControl = Get.find<OrderController>(tag: 'order');
              orderControl.fetchActiveOrders();
            } else {
              var orderControl = Get.put(OrderController(), tag: 'order');
              orderControl.fetchActiveOrders();
            }
            Get.back();
            Get.snackbar('Success', 'Payment successfully verified',
                backgroundColor: maincolor, colorText: Colors.white);
          } else {
            verifyingPayment.value = false;
            if (res.data['message'] != null) {
              Get.snackbar('Error', res.data['message']);
            }
            throw Exception(res.data['message']);
          }
          verifyingPayment.value = false;
        },
        onFailure: (e, res) {
          verifyingPayment.value = false;
          Get.snackbar('Error', 'Failed to verify payment, please try again');
        });
    // response = await DioConfig.dio().post(
    //   '/user/payment/verify-order-payment',
    //   data: {"orderId": orderId.value, "referenceId": transactionId.value},
    //   options: dio.Options(
    //     headers: {
    //       'Authorization': ConfigPreference.getUserToken(),
    //     },
    //     contentType: 'application/json',
    //   ),
    // );
  }

  String calculateStoreDeliveryFee(String storeId) {
    return CalculationHelper.calculateStoreDeliveryFee(
        storeId, productsInOrder, storesInOrder);
  }

  int calculateTotalQuantityOfProductsFromSpecificStore(String storeId) {
    return CalculationHelper.calculateTotalQuantityOfProductsFromSpecificStore(
        storeId, productsInOrder);
  }

  var totalProductPrice = 0.0.obs;
  void calculateTotalProductPrice() {
    totalProductPrice.value =
        CalculationHelper.calculateTotalProductPrice(productsInOrder);
    totalProductPrice.refresh();
  }

  String? storeNameById(String storeId) {
    return storesInOrder.firstWhere((store) => store.id == storeId).name;
  }
}
