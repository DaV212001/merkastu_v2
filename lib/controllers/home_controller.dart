import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/main_layout_controller.dart';
import 'package:merkastu_v2/controllers/order_controller.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/utils/error_utils.dart';
import 'package:merkastu_v2/widgets/animated_widgets/animated_undo_button.dart';

import '../config/dio_config.dart';
import '../config/storage_config.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/store.dart';
import '../utils/order_calculation_helper.dart';
import '../utils/payment_methods.dart';

class HomeController extends GetxController {
  var storeList = <Store>[].obs;
  var filteredStoreList = <Store>[].obs;
  var storeLoadingStatus = ApiCallStatus.holding.obs;
  var storeLoadingErrorData = ErrorData(title: '', body: '', image: '').obs;

  var insideAastu = false.obs;
  var all = true.obs;
  var selectedStore = Store().obs;
  var selectedIndex = 0.obs;

  var productList = <Product>[].obs;
  var filteredProductList = <Product>[].obs;
  var productLoadingStatus = ApiCallStatus.holding.obs;
  var productLoadingErrorData = ErrorData(title: '', body: '', image: '').obs;

  var productCategoryList = <ProductCategory>[].obs;
  var selectedCategory = ProductCategory(id: 'all').obs;

  var cart = <Product>[].obs;
  var itemsInCart = 0.obs;

  void filterStores() {
    filteredStoreList.value = List.from(storeList);
    if (all.value) {
      filteredStoreList.value = List.from(storeList);
    } else {
      filteredStoreList.value = filteredStoreList
          .where((element) => element.insideAastu == insideAastu.value)
          .toList();
    }
  }

  void searchForStores(String query) {
    if (query.isEmpty) {
      filteredStoreList.value = List.from(storeList);
      return;
    }
    filteredStoreList.value = List.from(storeList);
    filteredStoreList.value = filteredStoreList
        .where((element) =>
            element.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<String> savedStoresId = [];
  List<String> savedProductsId = [];

  void fetchStores() async {
    storeLoadingStatus.value = ApiCallStatus.loading;
    storeLoadingErrorData.value = ErrorData(title: '', body: '', image: '');
    selectedIndex.value = 0;
    dio.Response response;
    try {
      var path = UserController.isLoggedIn.value
          ? '/user/store?userId=${UserController.user.value.id}'
          : '/user/store';
      Logger().d(path);
      response = await DioConfig.dio().get(
        path,
      );
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        storeList = (response.data['data']['stores'] as List)
            .map((e) => Store.fromJson(e))
            .toList()
            .obs;
        savedStoresId = (response.data['data']['savedStores'] as List)
            .map((e) => e.toString())
            .toList();
        for (Store store in storeList) {
          if (savedStoresId.contains(store.id)) {
            store.favorited = true;
          }
        }
        filteredStoreList.value = List.from(storeList);

        storeLoadingStatus.value = ApiCallStatus.success;
      } else {
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      storeLoadingStatus.value = ApiCallStatus.error;
      storeLoadingErrorData.value = await ErrorUtil.getErrorData(e.toString());
    }
  }

  void favoriteStore(Store store) async {
    if (!ConfigPreference.isUserLoggedIn()) {
      Get.toNamed(Routes.loginPromptRoute);
      return;
    }
    store.favorited = true;
    filteredStoreList.refresh();
    dio.Response response;
    try {
      response = await DioConfig.dio().post('/user/store/save',
          data: {'store_id': store.id},
          options: dio.Options(
            headers: {
              'Authorization': ConfigPreference.getUserToken(),
            },
          ));
      Logger().d(response.data);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status'] == true) {
        store.favorited = true;
      } else {
        store.favorited = false;
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      store.favorited = false;
      Get.snackbar('Error', 'Couldn\'t favorite store');
    }
    filteredStoreList.refresh();
  }

  void unfavoriteStore(Store store) async {
    if (!ConfigPreference.isUserLoggedIn()) {
      Get.toNamed(Routes.loginPromptRoute);
      return;
    }
    store.favorited = false;
    filteredStoreList.refresh();
    dio.Response response;
    try {
      response = await DioConfig.dio().put('/user/store/unsave',
          data: {'store_id': store.id},
          options: dio.Options(
            headers: {
              'Authorization': ConfigPreference.getUserToken(),
            },
          ));
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        store.favorited = false;
      } else {
        store.favorited = true;
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      store.favorited = true;
      Get.snackbar('Error', 'Couldn\'t unfavorite store');
    }
    filteredStoreList.refresh();
  }

  void favoriteProduct(Product product) async {
    if (!ConfigPreference.isUserLoggedIn()) {
      Get.toNamed(Routes.loginPromptRoute);
      return;
    }
    product.favorited = true;
    filteredProductList.refresh();
    dio.Response response;
    try {
      response = await DioConfig.dio().post('/user/product/save',
          data: {'product_id': product.id},
          options: dio.Options(
            headers: {
              'Authorization': ConfigPreference.getUserToken(),
            },
          ));
      Logger().d(response.data);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status'] == true) {
        product.favorited = true;
      } else {
        product.favorited = false;
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      product.favorited = false;
      Get.snackbar('Error', 'Couldn\'t favorite product');
    }
    filteredProductList.refresh();
  }

  void unfavoriteProduct(Product product) async {
    if (!ConfigPreference.isUserLoggedIn()) {
      Get.toNamed(Routes.loginPromptRoute);
      return;
    }
    product.favorited = false;
    filteredProductList.refresh();
    dio.Response response;
    try {
      response = await DioConfig.dio().put('/user/product/unsave',
          data: {'product_id': product.id},
          options: dio.Options(
            headers: {
              'Authorization': ConfigPreference.getUserToken(),
            },
          ));
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        product.favorited = false;
      } else {
        product.favorited = true;
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      product.favorited = true;
      Get.snackbar('Error', 'Couldn\'t unfavorite product');
    }
    filteredProductList.refresh();
  }

  void searchForProducts(String query) {
    if (query.isEmpty) {
      filteredProductList.value = List.from(productList);
      return;
    }
    filteredProductList.value = List.from(productList);
    filteredProductList.value = filteredProductList
        .where((element) =>
            element.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void filterProducts() {
    filteredProductList.value = List.from(productList);
    if (selectedCategory.value.id == 'all') {
      filteredProductList.value = List.from(productList);
    } else {
      filteredProductList.value = filteredProductList
          .where((element) => element.categoryId == selectedCategory.value.id)
          .toList();
    }
  }

  void fetchProducts() async {
    productLoadingStatus.value = ApiCallStatus.loading;
    productLoadingErrorData.value = ErrorData(title: '', body: '', image: '');
    selectedCategory.value = ProductCategory(id: 'all');
    dio.Response response;
    Logger().d('/store/get-store/${selectedStore.value.id}');
    try {
      var path = UserController.isLoggedIn.value
          ? '/user/store/${selectedStore.value.id}?userId=${UserController.user.value.id}'
          : '/user/store/${selectedStore.value.id}';
      response = await DioConfig.dio().get(
        path,
      );
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        productList = (response.data['data']['store']['product'] as List)
            .map((e) => Product.fromJson(e))
            .toList()
            .obs;
        productCategoryList.value =
            (response.data['data']['store']['ProductCategories'] as List)
                .map((e) => ProductCategory.fromJson(e))
                .toList();
        savedProductsId = (response.data['data']['savedProducts'] as List)
            .map((e) => e.toString())
            .toList();
        for (Product product in productList) {
          if (savedProductsId.contains(product.id)) {
            product.favorited = true;
          }
        }
        productCategoryList.insert(0, ProductCategory(id: 'all'));
        filteredProductList.value = List.from(productList);
        productLoadingStatus.value = ApiCallStatus.success;
      } else {
        throw Exception(response.data);
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      productLoadingStatus.value = ApiCallStatus.error;
      productLoadingErrorData.value =
          await ErrorUtil.getErrorData(e.toString());
    }
  }

  var totalProductPrice = 0.00.obs;

  void addProductAmount(Product product) {
    product.amount = product.amount! + 1;
    cart.refresh();
  }

  void removeProductAmount(Product product) {
    if (product.amount! > 0) {
      product.amount = product.amount! - 1;
    }
    cart.refresh();
  }

  void addProductToCart(Product product) {
    cart.add(product);
    itemsInCart.value = cart.length;
    itemsInCart.refresh();
    cart.refresh();
    calculateTotalProductPrice();
  }

  void duplicateProductToCart(Product product) {
    cart.add(Product.copy(product));
    itemsInCart.value = cart.length;
    itemsInCart.refresh();
    cart.refresh();
    calculateTotalProductPrice();
    Logger().i(cart.length);
  }

  void removeProductFromCart(Product product,
      {bool fromCartList = false, fromBottomSheet = false}) {
    // Find the index of the product to be removed
    int removedProductIndex = cart.indexWhere((element) => element == product);
    // Remove the product from the cart
    if (removedProductIndex != -1) {
      // Ensure the product exists
      Product removedProduct = cart.removeAt(removedProductIndex);
      itemsInCart.value = cart.length;
      itemsInCart.refresh();
      cart.refresh();
      calculateTotalProductPrice();
      if (fromCartList) {
        // Show SnackBar with Undo button and countdown
        Get.snackbar(
          'Product Removed',
          '${product.name} has been removed from your cart.',
          duration: const Duration(seconds: 5), // Duration for Snackbar
          mainButton: AnimatedUndoButton(
              width: 80,
              height: 50,
              buttonText: 'Undo',
              progressColor: Colors.white,
              buttonColor: maincolor,
              onPressed: () {
                // Reinsert the product at the same index if Undo is pressed
                cart.insert(removedProductIndex, removedProduct);
                itemsInCart.value = cart.length;
                itemsInCart.refresh();
                cart.refresh();
                calculateTotalProductPrice();
                Get.back();
              },
              child: const Text('Undo')),
          snackPosition: SnackPosition.TOP,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
        );
      }
    }
  }

  var selectedPaymentPlan = PaymentMethod.none.obs;
  // This method will group products by storeId
  Map<String, List<Product>> groupCartItemsByStore() {
    Map<String, List<Product>> groupedCart = {};

    for (var product in cart) {
      // If the storeId key exists, append the product to that store's list
      if (groupedCart.containsKey(product.storeId)) {
        groupedCart[product.storeId]!.add(product);
      } else {
        // Otherwise, create a new list for that store
        groupedCart[product.storeId!] = [product];
      }
    }
    // Logger().d(groupedCart);
    return groupedCart;
  }

  String? storeNameById(String storeId) {
    return storeList.firstWhere((store) => store.id == storeId).name;
  }

  var block = (UserController.user.value.block ?? 0).toString().obs;
  var room = (UserController.user.value.room ?? 0).toString().obs;

  var transactionId = ''.obs;
  var orderId = ''.obs;

  var placingOrder = ApiCallStatus.holding.obs;
  void placeOrder({required TabController tabController}) async {
    UserController.getLoggedInUser();
    Map<String, dynamic> body = {
      "order": groupCartItemsByStore().entries.map((entry) {
        String storeId = entry.key;
        List<Product> products = entry.value;

        return {
          "storeId": storeId,
          "orderItems": products.map((product) {
            var addonList = product.addons
                    ?.where(
                        (addon) => addon.amount != null && addon.amount! > 0)
                    .map((addon) {
                  return {"id": addon.id, "amount": addon.amount};
                }).toList() ??
                [];
            return {
              "id": product.id,
              "amount": product.amount,
              // Filter addons that have an amount greater than 0
              if (addonList.isNotEmpty)
                "addons": product.addons
                    ?.where(
                        (addon) => addon.amount != null && addon.amount! > 0)
                    .map((addon) {
                  return {"id": addon.id, "amount": addon.amount};
                }).toList()
            };
          }).toList(),
        };
      }).toList(),
      if (block.value != UserController.user.value.block.toString())
        "deliveryBlock": block.value,
      if (room.value != UserController.user.value.room.toString())
        "deliveryRoom": room.value,
      "paymentMethod": selectedPaymentPlan.value.name,
    };

    // Logging the generated body
    Logger().i(body);
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    print(ConfigPreference.getUserToken());
    try {
      placingOrder.value = ApiCallStatus.loading;
      response = await DioConfig.dio().post(
        '/user/order/create',
        data: body,
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
        if (Get.isRegistered<OrderController>()) {
          var orderControl = Get.find<OrderController>(tag: 'order');
          orderControl.fetchActiveOrders();
        } else {
          var orderControl = Get.put(OrderController(), tag: 'order');
          orderControl.fetchActiveOrders();
        }
        Get.snackbar('Success', 'Order successfully placed!',
            backgroundColor: maincolor, colorText: Colors.white);
        orderId.value = response.data['data']['orderId'].toString();
        if (selectedPaymentPlan.value == PaymentMethod.wallet) {
          Get.offNamedUntil(Routes.initialRoute, (r) => true);
          cart.clear();
          itemsInCart.value = 0;
          itemsInCart.refresh();
          cart.refresh();
          orderId.value = '';
          transactionId.value = '';
          selectedPaymentPlan.value = PaymentMethod.none;
          UserController.getWalletBallance();
          var mainControl = Get.find<MainLayoutController>(tag: 'main');
          mainControl.controller.jumpToTab(3);
          placingOrder.value = ApiCallStatus.holding;
          return;
        }

        if (selectedPaymentPlan.value != PaymentMethod.wallet) {
          tabController.animateTo(1);
        }
      } else {
        throw Exception(response.data['message']);
      }
      placingOrder.value = ApiCallStatus.success;
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      placingOrder.value = ApiCallStatus.error;
      Get.snackbar('Error', 'Failed to place order, please try again');
    }
  }

  var verifyingPayment = false.obs;

  void verifyPayment() async {
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      verifyingPayment.value = true;
      response = await DioConfig.dio().post(
        '/user/payment/verify-order-payment',
        data: {"orderId": orderId.value, "referenceId": transactionId.value},
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
        cart.clear();
        itemsInCart.value = 0;
        itemsInCart.refresh();
        cart.refresh();
        orderId.value = '';
        transactionId.value = '';
        selectedPaymentPlan.value = PaymentMethod.none;

        Get.snackbar('Success', 'Payment successfully verified',
            backgroundColor: maincolor, colorText: Colors.white);
        if (Get.isRegistered<OrderController>()) {
          var orderControl = Get.find<OrderController>(tag: 'order');
          orderControl.fetchActiveOrders();
        } else {
          var orderControl = Get.put(OrderController(), tag: 'order');
          orderControl.fetchActiveOrders();
        }
        Get.offNamedUntil(Routes.initialRoute, (r) => true);
        var mainControl = Get.find<MainLayoutController>(tag: 'main');
        mainControl.controller.jumpToTab(3);
      } else {
        throw Exception(response.data['message']);
      }
      placingOrder.value = ApiCallStatus.holding;
      verifyingPayment.value = false;
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      verifyingPayment.value = false;
      Get.snackbar('Error', 'Failed to verify payment, please try again');
    }
  }

  // Expose the helper methods via the same method names
  String calculateSpecificProductPrice(Product product) {
    return CalculationHelper.calculateSpecificProductPrice(product);
  }

  String calculateStoreDeliveryFee(String storeId) {
    return CalculationHelper.calculateStoreDeliveryFee(
        storeId, cart, storeList);
  }

  int calculateTotalQuantityOfProductsFromSpecificStore(String storeId) {
    return CalculationHelper.calculateTotalQuantityOfProductsFromSpecificStore(
        storeId, cart);
  }

  void calculateTotalProductPrice() {
    totalProductPrice.value =
        CalculationHelper.calculateTotalProductPrice(cart);
    totalProductPrice.refresh();
  }

  @override
  void onInit() {
    fetchStores();
    super.onInit();
    ever(cart, (_) => calculateTotalProductPrice());
  }
}

Map<String, dynamic> sampleResponse = {
  "message": "Order created successfully",
  "order": {
    "id": "374fb967-bcff-49e2-9c8c-1fef406b3190",
    "user_id": "0950f698-1192-46e8-bb93-75aec440ff0b",
    "total_orders": 1,
    "order_price": 164,
    "delivery_fee": 20,
    "total_price": 208,
    "payment_status": "UNPAID",
    "order_status": "INACTIVE",
    "paymnet_method": "TELEBIRR",
    "created_at": "2024-10-09T10:02:00.253Z",
    "paid_at": null,
    "delivered_at": null,
    "accepted_at": null,
    "canceled_at": null
  }
};
