import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/favorites_controller.dart';
import 'package:merkastu_v2/controllers/main_layout_controller.dart';
import 'package:merkastu_v2/controllers/order_controller.dart';
import 'package:merkastu_v2/models/order.dart';
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
        if (Get.isRegistered<FavoritesController>(tag: 'favorites')) {
          Get.find<FavoritesController>(tag: 'favorites')
              .fetchFavoritedStores();
        }
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
        if (Get.isRegistered<FavoritesController>(tag: 'favorites')) {
          Get.find<FavoritesController>(tag: 'favorites')
              .fetchFavoritedStores();
        }
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
    if (Get.isRegistered<CartController>(tag: 'cart')) {
      Get.find<CartController>(tag: 'cart').cart.refresh();
    }
    dio.Response response;
    try {
      response = await DioConfig.dio().post('/user/store/product/save',
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
        if (Get.isRegistered<FavoritesController>(tag: 'favorites')) {
          Get.find<FavoritesController>(tag: 'favorites')
              .fetchFavoritedProducts();
        }
        if (Get.isRegistered<CartController>(tag: 'cart')) {
          Get.find<CartController>(tag: 'cart').cart.refresh();
        }
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
    if (Get.isRegistered<CartController>(tag: 'cart')) {
      Get.find<CartController>(tag: 'cart').cart.refresh();
    }
  }

  void unfavoriteProduct(Product product) async {
    if (!ConfigPreference.isUserLoggedIn()) {
      Get.toNamed(Routes.loginPromptRoute);
      return;
    }
    product.favorited = false;
    filteredProductList.refresh();
    if (Get.isRegistered<CartController>(tag: 'cart')) {
      Get.find<CartController>(tag: 'cart').cart.refresh();
    }
    dio.Response response;
    try {
      response = await DioConfig.dio().put('/user/store/product/unsave',
          data: {'product_id': product.id},
          options: dio.Options(
            headers: {
              'Authorization': ConfigPreference.getUserToken(),
            },
          ));
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        product.favorited = false;
        if (Get.isRegistered<FavoritesController>(tag: 'favorites')) {
          Get.find<FavoritesController>(tag: 'favorites')
              .fetchFavoritedProducts();
        }
        if (Get.isRegistered<CartController>(tag: 'cart')) {
          Get.find<CartController>(tag: 'cart').cart.refresh();
        }
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
    if (Get.isRegistered<CartController>(tag: 'cart')) {
      Get.find<CartController>(tag: 'cart').cart.refresh();
    }
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

  @override
  void onInit() {
    fetchStores();
    super.onInit();
  }
}

class CartController extends GetxController {
  @override
  void onInit() {
    ever(cart, (_) {
      calculateTotalProductPrice();
      updateNonDeliveryOnlyFlag();
    });
    super.onInit();
  }

  var orderType = OrderType.delivery.obs;
  var cart = <Product>[].obs;
  var numberOfItemsInCart = 0.obs;

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

  bool isOrderFromNonDeliveryOnly(Order order) {
    bool nonDeliveryOnly = true;
    for (StoreSmall store in (order.stores ?? [])) {
      String storeId = store.id ?? '';
      Store? storeFromHome = Get.find<HomeController>(tag: 'home')
          .storeList
          .firstWhereOrNull((store) => store.id == storeId);
      if (storeFromHome?.deliveryOnly == true) {
        nonDeliveryOnly = false;
        break;
      }
    }
    return nonDeliveryOnly;
  }

  bool canAddProductToCart(Product product, {bool dontShowSnack = false}) {
    if (cart.isEmpty) {
      return true; // No restrictions if the cart is empty
    }

    // Get the deliveryOnly status of the first product's store
    Store? firstStore = Get.find<HomeController>(tag: 'home')
        .storeList
        .firstWhereOrNull((store) => store.id == cart.first.storeId);

    Store? newProductStore = Get.find<HomeController>(tag: 'home')
        .storeList
        .firstWhereOrNull((store) => store.id == product.storeId);

    if (firstStore == null || newProductStore == null) {
      return false; // If store information is missing, prevent addition
    }

    if (firstStore.deliveryOnly != newProductStore.deliveryOnly) {
      Get.snackbar(
        'Error',
        'You cannot mix products from stores supporting different delivery options',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Prevent adding the product
    }

    if (firstStore.deliveryOnly == false &&
        (firstStore.id != newProductStore.id)) {
      Get.snackbar(
        'Error',
        'Can\'t add a product from a different store in one cart if your current store has multiple delivery options.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Prevent adding the product
    }

    return true; // Product can be added
  }

  void addProductToCart(Product product) {
    if (!canAddProductToCart(product)) return;
    cart.add(product);
    numberOfItemsInCart.value = cart.length;
    numberOfItemsInCart.refresh();
    cart.refresh();
    calculateTotalProductPrice();
  }

  void duplicateProductToCart(Product product) {
    cart.add(Product.copy(product));
    numberOfItemsInCart.value = cart.length;
    numberOfItemsInCart.refresh();
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
      numberOfItemsInCart.value = cart.length;
      numberOfItemsInCart.refresh();
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
                numberOfItemsInCart.value = cart.length;
                numberOfItemsInCart.refresh();
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

  // Reactive flag to indicate if the cart contains any non-delivery-only product
  var hasNonDeliveryOnlyProduct = false.obs;

  /// Updates the flag indicating whether the cart contains any product
  /// from a store that is not marked as deliveryOnly.
  void updateNonDeliveryOnlyFlag() {
    if (cart.isEmpty) {
      hasNonDeliveryOnlyProduct.value = false;
      return;
    }

    // Assuming HomeController is registered and exposes a storeList.
    final homeController = Get.find<HomeController>(tag: 'home');

    hasNonDeliveryOnlyProduct.value = cart.any((product) {
      final store = homeController.storeList.firstWhereOrNull(
        (store) => store.id == product.storeId,
      );
      // The condition checks if the store exists and its deliveryOnly flag is false.
      return store != null && store.deliveryOnly != true;
    });
  }

  void removeProductsFromCart(List<Product> products,
      {bool fromCartList = false, fromBottomSheet = false}) {
    // Store removed products and their indices
    List<Map<String, dynamic>> removedProducts = [];

    for (Product product in products) {
      // Find the index of the product to be removed
      int removedProductIndex =
          cart.indexWhere((element) => element == product);

      // Remove the product from the cart and store it for undo action
      if (removedProductIndex != -1) {
        // Ensure the product exists and store the removed product with its index
        Product removedProduct = cart.removeAt(removedProductIndex);
        removedProducts.add({
          'product': removedProduct,
          'index': removedProductIndex,
        });
      }
    }

    // Update the cart state and product count after removal
    numberOfItemsInCart.value = cart.length;
    numberOfItemsInCart.refresh();
    cart.refresh();
    calculateTotalProductPrice();

    // If fromCartList is true, show SnackBar with Undo button for bulk removal
    if (fromCartList && removedProducts.isNotEmpty) {
      // Display SnackBar with Undo option
      Get.snackbar(
        'Products Removed',
        '${removedProducts.length} products have been removed from your cart.',
        duration: const Duration(seconds: 5), // Duration for Snackbar
        mainButton: AnimatedUndoButton(
          width: 80,
          height: 50,
          buttonText: 'Undo',
          progressColor: Colors.white,
          buttonColor: maincolor,
          onPressed: () {
            // Reinsert the removed products at their original indices if Undo is pressed
            for (var removedItem in removedProducts) {
              Product product = removedItem['product'];
              int index = removedItem['index'];
              cart.add(product); // Reinsert at original position
            }
            numberOfItemsInCart.value = cart.length;
            numberOfItemsInCart.refresh();
            cart.refresh();
            calculateTotalProductPrice();
            Get.back(); // Close the Snackbar
          },
          child: const Text('Undo'),
        ),
        snackPosition: SnackPosition.TOP,
        borderRadius: 8,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  var selectedPaymentPlan = PaymentMethod.none.obs;
  RxMap<String, List<Product>> groupedItemsCache =
      RxMap<String, List<Product>>({});

  // This method will group products by storeId
  Map<String, List<Product>> groupCartItemsByStore() {
    // if (groupItems.value) {
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
    groupedItemsCache.value = groupedCart;
    // Logger().d(groupedCart);
    return groupedCart;
    // } else {
    //   return groupedItemsCache;
    // }
  }

  String? storeNameById(String storeId) {
    String? storeName = '';
    if (Get.isRegistered<HomeController>(tag: 'home')) {
      storeName = Get.find<HomeController>(tag: 'home')
          .storeList
          .firstWhere((store) => store.id == storeId)
          .name;
    }
    return storeName;
  }

  var block = (UserController.user.value.block ?? 0).toString().obs;
  var room = (UserController.user.value.room ?? 0).toString().obs;

  var transactionId = ''.obs;
  var orderId = ''.obs;
  var listOfSelectedProductsInCart = <Product>[].obs;
  var listOfSelectedProductsInStore = <Product>[].obs;

  void toggleSelectionInStore(Product product) {
    if (!canAddProductToCart(product)) return;
    Logger().d('CLOSED');
    if (listOfSelectedProductsInStore.contains(product)) {
      listOfSelectedProductsInStore.remove(product);
      product.isSelected = false;
    } else {
      listOfSelectedProductsInStore.add(product);
      product.isSelected = true;
    }
    listOfSelectedProductsInStore.refresh();
    if (Get.isRegistered<HomeController>(tag: 'home')) {
      Get.find<HomeController>(tag: 'home').filteredProductList.refresh();
    }
  }

  void addSelectedProductsToCart() {
    int originalNumberOfItemsInCart = cart.length;
    cart.addAll(listOfSelectedProductsInStore);
    cart.refresh();
    numberOfItemsInCart.value = cart.length;
    numberOfItemsInCart.refresh();
    int numberOfAddedProducts = listOfSelectedProductsInStore.length;
    List<Product> addedProducts = listOfSelectedProductsInStore;
    listOfSelectedProductsInStore.clear();
    Get.snackbar(
      'Success',
      '$numberOfAddedProducts have been added to your cart.',
      duration: const Duration(seconds: 5), // Duration for Snackbar
      mainButton: AnimatedUndoButton(
        width: 80,
        height: 50,
        buttonText: 'Undo',
        progressColor: Colors.white,
        buttonColor: maincolor,
        onPressed: () {
          for (int i = originalNumberOfItemsInCart; i < cart.length; i++) {
            cart.removeAt(i);
          }
          cart.refresh();
          numberOfItemsInCart.value = cart.length;
          numberOfItemsInCart.refresh();
          Get.back(); // Close the Snackbar
        },
        child: const Text('Undo'),
      ),
      snackPosition: SnackPosition.TOP,
      borderRadius: 8,
      margin: const EdgeInsets.all(10),
    );
  }

  void toggleSelectionInCart(Product product) {
    if (listOfSelectedProductsInCart.contains(product)) {
      listOfSelectedProductsInCart.remove(product);
      product.isSelected = false;
    } else {
      listOfSelectedProductsInCart.add(product);
      product.isSelected = true;
    }
    listOfSelectedProductsInCart.refresh();
    if (Get.isRegistered<HomeController>(tag: 'home')) {
      Get.find<HomeController>(tag: 'home').filteredProductList.refresh();
    }
  }

  var groupItems = true.obs;
  var recalculateTotals = true.obs;
  var nameOfStoreAccount = ''.obs;
  var storeAccount = ''.obs;
  var placingOrder = ApiCallStatus.holding.obs;
  void placeOrder({required TabController tabController}) async {
    UserController.getLoggedInUser();
    Map<String, dynamic> body = {
      "order": groupCartItemsByStore().entries.map((entry) {
        String storeId = entry.key;
        List<Product> products = entry.value;

        // Create a list to hold merged products
        List<Product> mergedProducts = mergeSameProducts(products);

        // Map the merged products into the final JSON structure
        return {
          "storeId": storeId,
          "orderItems": mergedProducts.map((product) {
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
              if (addonList.isNotEmpty) "addons": addonList
            };
          }).toList(),
        };
      }).toList(),
      if (block.value != UserController.user.value.block.toString())
        "deliveryBlock": block.value,
      if (room.value != UserController.user.value.room.toString())
        "deliveryRoom": room.value,
      "paymentMethod": selectedPaymentPlan.value.name,
      "orderType":
          hasNonDeliveryOnlyProduct.value ? orderType.value.name : 'DELIVERY'
    };

    // Logging the generated body
    Logger().i(body);
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    print(ConfigPreference.getUserToken());
    // groupItems.value = false;
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
        recalculateTotals.value = false;
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
          print('here1');
          Get.offNamedUntil(Routes.initialRoute, (r) => true);
          UserController.getWalletBalance();
          var mainControl = Get.find<MainLayoutController>(tag: 'main');
          mainControl.controller.jumpToTab(3);
          // cart.clear();
          // numberOfItemsInCart.value = 0;
          // numberOfItemsInCart.refresh();
          // cart.refresh();
          orderId.value = '';
          transactionId.value = '';
          selectedPaymentPlan.value = PaymentMethod.none;
          placingOrder.value = ApiCallStatus.success;
          return;
        }

        if (response.data['data'].containsKey('bankAccountInfo')) {
          nameOfStoreAccount.value =
              response.data['data']['bankAccountInfo']['name'];
          storeAccount.value =
              response.data['data']['bankAccountInfo']['account_number'];
        }

        if (selectedPaymentPlan.value != PaymentMethod.wallet) {
          tabController.animateTo(1);
        }
        print('here 2 ${selectedPaymentPlan.value}');
        // cart.clear();
        // numberOfItemsInCart.value = 0;
        // numberOfItemsInCart.refresh();
        // cart.refresh();
        // orderId.value = '';
        transactionId.value = '';
        // selectedPaymentPlan.value = PaymentMethod.none;
        // placingOrder.value = ApiCallStatus.holding;
      } else {
        throw Exception(response.data['message']);
      }
      placingOrder.value = ApiCallStatus.success;
      recalculateTotals.value = true;
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      placingOrder.value = ApiCallStatus.error;
      Get.snackbar('Error', 'Failed to place order, please try again');
    }
  }

  List<Product> mergeSameProducts(List<Product> products) {
    List<Product> mergedProducts = [];

    // Iterate through products and merge similar ones
    for (var product in products) {
      bool found = false;

      // Check if product already exists in the mergedProducts list
      for (var mergedProduct in mergedProducts) {
        if (mergedProduct.isTheSameAs(product)) {
          // If a similar product is found, increase its amount
          mergedProduct.amount =
              (mergedProduct.amount ?? 1) + (product.amount ?? 1);

          found = true;
          break;
        }
      }

      // If the product wasn't found, add it as a new product
      if (!found) {
        mergedProducts.add(
            Product.copy(product)); // Create a copy to avoid reference issues
      }
    }
    return mergedProducts;
  }

  var verifyingPayment = false.obs;

  void verifyPayment() async {
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    verifyingPayment.value = true;
    await DioService.dioTwoProngedRequest(
        path: '/user/payment/verify-order-payment',
        paymentMethod: selectedPaymentPlan.value,
        orderId: orderId.value,
        transactionId: transactionId.value,
        options: dio.Options(
          headers: {
            'Authorization': ConfigPreference.getUserToken(),
          },
          contentType: 'multipart/form-data',
        ),
        onSuccess: (res) async {
          print('Upload successful');
          Logger().d(res.data);
          if ((res.statusCode == 201 || res.statusCode == 200) &&
              res.data['status']) {
            cart.clear();
            numberOfItemsInCart.value = 0;
            numberOfItemsInCart.refresh();
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
            // groupItems.value = true;
          } else {
            verifyingPayment.value = false;
            throw Exception(res.data['message']);
          }
          verifyingPayment.value = false;
        },
        onFailure: (e, res) {
          verifyingPayment.value = false;
          Get.snackbar('Error', 'Failed to verify payment, please try again');
        });
  }

  // Expose the helper methods via the same method names
  String calculateSpecificProductPrice(Product product) {
    return CalculationHelper.calculateSpecificProductPrice(product);
  }

  String calculateStoreDeliveryFee(String storeId) {
    if (Get.isRegistered<HomeController>(tag: 'home')) {
      return CalculationHelper.calculateStoreDeliveryFee(
          storeId, cart, Get.find<HomeController>(tag: 'home').storeList);
    }
    return '0';
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
}

// void verifyPayment() async {
//   verifyingPayment.value = true;
//   // Step 1: Download the PDF receipt file
//   final directory = await getExternalStorageDirectory();
//   final filePath = '${directory?.path}/receipt.pdf';
//   final pdfFile = File(filePath);
//   print('going to download');
//   var dioCertBypass = dio.Dio();
//
//   (dioCertBypass.httpClientAdapter as DefaultHttpClientAdapter)
//       .onHttpClientCreate = (HttpClient client) {
//     client.badCertificateCallback =
//         (X509Certificate cert, String host, int port) => true;
//     return client;
//   };
//   var downloadRes = await dioCertBypass.download(
//       'https://apps.cbe.com.et:100/?id=FT24297FC1Q899264969', filePath);
//   print(downloadRes.data);
//
//   // Step 3: Create FormData with the HTML file
//   dio.FormData formData = dio.FormData.fromMap({
//     "receipt":
//         await dio.MultipartFile.fromFile(filePath, filename: "receipt.pdf"),
//     "orderId": orderId.value,
//     "paymentMethod": "CBE",
//   });
//
//   // Step 4: Send the HTML file as form data
//   await DioService.dioPostFormData(
//       path:
//           'https://793b-102-213-68-99.ngrok-free.app/user/payment/verify-order-payment',
//       formData: formData,
//       options: dio.Options(
//         headers: {
//           'Authorization': ConfigPreference.getUserToken(),
//         },
//         contentType: 'multipart/form-data',
//       ),
//       onSuccess: (res) async {
//         print('Upload successful');
//         Logger().d(res.data);
//         if ((res.statusCode == 201 || res.statusCode == 200) &&
//             res.data['status']) {
//           if (await pdfFile.exists()) {
//             await pdfFile.delete();
//             print('HTML file deleted successfully');
//           }
//           cart.clear();
//           numberOfItemsInCart.value = 0;
//           numberOfItemsInCart.refresh();
//           cart.refresh();
//           orderId.value = '';
//           transactionId.value = '';
//           selectedPaymentPlan.value = PaymentMethod.none;
//
//           Get.snackbar('Success', 'Payment successfully verified',
//               backgroundColor: maincolor, colorText: Colors.white);
//           if (Get.isRegistered<OrderController>()) {
//             var orderControl = Get.find<OrderController>(tag: 'order');
//             orderControl.fetchActiveOrders();
//           } else {
//             var orderControl = Get.put(OrderController(), tag: 'order');
//             orderControl.fetchActiveOrders();
//           }
//           Get.offNamedUntil(Routes.initialRoute, (r) => true);
//           var mainControl = Get.find<MainLayoutController>(tag: 'main');
//           mainControl.controller.jumpToTab(3);
//         } else {
//           throw Exception(res.data['message']);
//         }
//         placingOrder.value = ApiCallStatus.holding;
//         verifyingPayment.value = false;
//       });
//   // await DioService.dioGet(
//   //     path:
//   //         'https://transactioninfo.ethiotelecom.et/receipt/${transactionId.value}',
//   //     onSuccess: (res) async {
//   //       Logger().f(res.data);
//   //       // // Step 2: Convert response data to HTML and save it on the phone
//   //       // final htmlContent = res.data.toString();
//   //       // final directory = await getApplicationDocumentsDirectory();
//   //       // final filePath = '${directory.path}/receipt.html';
//   //       // final htmlFile = File(filePath);
//   //       // await htmlFile.writeAsString(htmlContent);
//   //
//   //
//   //     },
//   //     onFailure: (e, res) {
//   //       verifyingPayment.value = false;
//   //       Get.snackbar('Error', 'Failed to verify payment, please try again');
//   //     });
//   // response = await DioConfig.dio().post(
//   //   '/user/payment/verify-order-payment',
//   //   data: {"orderId": orderId.value, "referenceId": transactionId.value},
//   //   options: dio.Options(
//   //     headers: {
//   //       'Authorization': ConfigPreference.getUserToken(),
//   //     },
//   //     contentType: 'application/json',
//   //   ),
//   // );
// }
