import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/storage_config.dart';
import 'package:merkastu_v2/utils/error_utils.dart';

import '../config/dio_config.dart';
import '../constants/constants.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/store.dart';
import '../utils/api_call_status.dart';
import '../utils/error_data.dart';
import '../utils/order_calculation_helper.dart';
import '../utils/payment_methods.dart';

class OrderController extends GetxController with GetTickerProviderStateMixin {
  late TabController orderListTabController;
  late TabController orderDetailTabController;
  @override
  void onInit() {
    fetchActiveOrders();
    fetchHistoryOrders();
    orderListTabController = TabController(length: 2, vsync: this);
    orderDetailTabController = TabController(length: 2, vsync: this);
    super.onInit();
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

  var selectedOrder = Order().obs;
  var productsInOrder = <Product>[].obs;
  var storesInOrder = <Store>[].obs;

  var groupedOrderProducts = <String, List<Product>>{}.obs;

  var gettingOrderDetail = ApiCallStatus.holding.obs;
  var errorGettingOrderDetail = ErrorData(title: '', body: '', image: '').obs;

  void fetchOrderDetail() async {
    gettingOrderDetail.value = ApiCallStatus.loading;
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get(
        '/user/order/get-order/${selectedOrder.value.id}',
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

        productsInOrder.refresh();

        storesInOrder.value = (response.data['data']['order_detail']['stores']
                as List)
            .map((e) => Store.fromOrderDetailJson(e as Map<String, dynamic>))
            .toList();
        storesInOrder.refresh();
        groupedOrderProducts.value =
            OrdersHelper.groupOrderProductsByStoreId(productsInOrder);
        groupedOrderProducts.refresh();
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

  var verifyingPayment = false.obs;
  var transactionId = ''.obs;
  void verifyPayment() async {
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      verifyingPayment.value = true;
      response = await DioConfig.dio().post(
        '/user/payment/verify-order-payment',
        data: {
          "orderId": selectedOrder.value.id,
          "referenceId": transactionId.value
        },
        options: dio.Options(
          headers: {
            'Authorization': ConfigPreference.getUserToken(),
          },
          contentType: 'application/json',
        ),
      );
      Logger().d(response.data);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data['status']) {
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
        throw Exception(response.data['message']);
      }
      verifyingPayment.value = false;
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      verifyingPayment.value = false;
      Get.snackbar('Error', 'Failed to verify payment, please try again');
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

  @override
  void onClose() {
    orderListTabController.dispose();
    super.onClose();
  }
}

class OrdersHelper {
  static Map<DateTime, List<Order>> groupOrdersByDate(List<Order> orders) {
    Map<DateTime, List<Order>> groupedOrders = {};

    for (var order in orders) {
      // Convert UTC time to Ethiopian time (UTC+3)
      final ethiopianDateTime =
          order.createdAt?.toUtc().add(const Duration(hours: 3));

      // Create a DateTime key with only the year, month, and day part (strip the time)
      DateTime dateKey = DateTime(
        ethiopianDateTime!.year,
        ethiopianDateTime.month,
        ethiopianDateTime.day,
      );

      // Add the order to the corresponding date group
      if (!groupedOrders.containsKey(dateKey)) {
        groupedOrders[dateKey] = [];
      }
      groupedOrders[dateKey]!.add(order);
    }

    // Sort the grouped orders by date in descending order (most recent first)
    final sortedGroupedOrders = Map<DateTime, List<Order>>.fromEntries(
      groupedOrders.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );

    // Sort the orders within each group by createdAt in descending order
    sortedGroupedOrders.forEach((date, ordersList) {
      ordersList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    });

    return sortedGroupedOrders;
  }

  static Map<String, List<Product>> groupOrderProductsByStoreId(
      List<Product> products) {
    Map<String, List<Product>> groupedOrderProducts = {};
    for (var product in products) {
      if (!groupedOrderProducts.containsKey(product.storeId)) {
        groupedOrderProducts[product.storeId!] = [];
      }
      groupedOrderProducts[product.storeId]!.add(product);
    }
    return groupedOrderProducts;
  }
}
