import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/storage_config.dart';
import 'package:merkastu_v2/controllers/socket_controller.dart';
import 'package:merkastu_v2/utils/error_utils.dart';

import '../config/dio_config.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../utils/api_call_status.dart';
import '../utils/error_data.dart';
import '../utils/order_calculation_helper.dart';
import '../utils/order_status.dart';

class OrderController extends GetxController with GetTickerProviderStateMixin {
  late TabController orderListTabController;
  final socketController = Get.find<SocketController>(tag: 'socket');

  static OrderController get instance =>
      Get.find<OrderController>(tag: 'order');

  @override
  void onInit() {
    fetchActiveOrders();
    fetchHistoryOrders();
    orderListTabController = TabController(length: 2, vsync: this);
    socketController.setEventHandler(orderSocketEventHandler);
    super.onInit();
  }

  void orderSocketEventHandler(socketMessage) {
    String acceptedOrderId = socketMessage['orderId'];
    Map<String, dynamic> acceptorDeliveryPerson = {};
    if (socketMessage.containsKey('deliveryPerson')) {
      acceptorDeliveryPerson = socketMessage['deliveryPerson'];
    }
    for (Order order in activeOrdersList) {
      if (order.id == acceptedOrderId) {
        order.orderStatus = OrderStatus.accepted;
        if (socketMessage.containsKey('deliveryPerson')) {
          order.deliveryPerson =
              DeliveryPerson.fromJson(acceptorDeliveryPerson);
        }
      }
    }
    activeOrdersList.refresh();
    filteredActiveOrdersList.value = List.from(activeOrdersList);
    filteredActiveOrdersList.refresh();
    groupedActiveOrders.refresh();
  }

  var activeOrdersList = <Order>[].obs;
  var filteredActiveOrdersList = <Order>[].obs;

  var fetchingActiveOrders = ApiCallStatus.holding.obs;
  var errorFetchingActiveOrders = ErrorData(title: '', body: '', image: '').obs;

  fetchActiveOrders() async {
    fetchingActiveOrders.value = ApiCallStatus.loading;
    errorFetchingActiveOrders.value = ErrorData(title: '', body: '', image: '');
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get(
        '/user/order/get-orders',
        options: dio.Options(
          headers: {
            'Authorization': ConfigPreference.getUserToken(),
          },
        ),
      );
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        List<Order> orders = (response.data['data']['orders'] as List<dynamic>)
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
        activeOrdersList.value = orders;
        activeOrdersList.refresh();
        filteredActiveOrdersList.value = List.from(activeOrdersList);
        filteredActiveOrdersList.refresh();
        groupOrdersByDateTime();
        fetchingActiveOrders.value = ApiCallStatus.success;
      } else {
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      errorFetchingActiveOrders.value =
          await ErrorUtil.getErrorData(e.toString());
      fetchingActiveOrders.value = ApiCallStatus.error;
    }
  }

  var groupedActiveOrders = <DateTime, List<Order>>{}.obs;

  groupOrdersByDateTime() {
    groupedActiveOrders.value =
        OrdersHelper.groupOrdersByDate(filteredActiveOrdersList);
    Logger().i(groupedActiveOrders);
    groupedActiveOrders.refresh();
  }

  var historyOrdersList = <Order>[].obs;
  var filteredHistoryOrdersList = <Order>[].obs;

  var fetchingHistoryOrders = ApiCallStatus.holding.obs;
  var errorFetchingHistoryOrders =
      ErrorData(title: '', body: '', image: '').obs;

  fetchHistoryOrders() async {
    fetchingHistoryOrders.value = ApiCallStatus.loading;
    errorFetchingHistoryOrders.value =
        ErrorData(title: '', body: '', image: '');
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get(
        '/user/order/get-order-historys',
        options: dio.Options(
          headers: {
            'Authorization': ConfigPreference.getUserToken(),
          },
        ),
      );
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        List<Order> orders = (response.data['data']['orders'] as List<dynamic>)
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
        historyOrdersList.value = orders;
        historyOrdersList.refresh();
        filteredHistoryOrdersList.value = List.from(historyOrdersList);
        filteredHistoryOrdersList.refresh();
        groupHistoryOrdersByDateTime();
        fetchingHistoryOrders.value = ApiCallStatus.success;
      } else {
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      errorFetchingHistoryOrders.value =
          await ErrorUtil.getErrorData(e.toString());
      fetchingHistoryOrders.value = ApiCallStatus.error;
    }
  }

  var groupedHistoryOrders = <DateTime, List<Order>>{}.obs;

  groupHistoryOrdersByDateTime() {
    groupedHistoryOrders.value =
        OrdersHelper.groupOrdersByDate(filteredHistoryOrdersList);
    groupedHistoryOrders.refresh();
  }

  String calculateSpecificProductPrice(Product product) {
    return CalculationHelper.calculateSpecificProductPrice(product);
  }

  @override
  void onClose() {
    orderListTabController.dispose();
    super.onClose();
  }
}
