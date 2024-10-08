import 'package:dio/dio.dart' as dio;
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/utils/error_utils.dart';
import 'package:merkastu_v2/widgets/animated_undo_button.dart';

import '../config/dio_config.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/store.dart';

Map<String, dynamic> sampleResponseRestaurantById = {
  "status": true,
  "message": "Store fetched successfully",
  "data":
// {
      // "id": "6a4c630c-991e-409d-bfaf-08b8b8a35f3d",
      // "name": " Abyssinia Traditional Foods",
      // "location": " AASTU next to Gate 2",
      // "latitude": 123321,
      // "longitude": 65498732,
      // "logo": "logo-1728042397473-81775629.png",
      // "cover_image": "coverImage-1728042397474-52589415.jpg",
      // "vat": 7,
      // "estimated_delivery_time": 50,
      // "owner_id": "0330a4cc-d2da-42d3-bdd6-f5e957274754",
      // "inside_aastu": false,
      // "product":
      [
    {
      "id": "8c6c4c13-f2a6-4727-a98c-ae107128027b",
      "name": " Kitfo",
      "price": 200,
      "description":
          "A classic Ethiopian dish made from raw minced beef, seasoned with spices and served with mustard and a side of gomen (cooked greens).",
      "image": "image-1728048780486-879682545.png",
      "store_id": "6a4c630c-991e-409d-bfaf-08b8b8a35f3d",
      "category_id": "aa9034b0-7f0f-4eec-8a77-28fe3e319a14",
      "Addon": [
        {
          "id": "0fc5996f-2216-409d-afad-7e0b26259c9d",
          "name": "Gomen",
          "price": 5,
          "product_id": "8c6c4c13-f2a6-4727-a98c-ae107128027b"
        },
        {
          "id": "84c4df77-b6a2-44cf-9f7e-5c99417aeb20",
          "name": "Ayib",
          "price": 10,
          "product_id": "8c6c4c13-f2a6-4727-a98c-ae107128027b"
        }
      ]
    },
    {
      "id": "e89fdcd5-0450-49d1-b430-09b823dc8edc",
      "name": " Shiro",
      "price": 120,
      "description":
          " A flavorful chickpea stew seasoned with spices, often served with injera or rice.",
      "image": "image-1728048820313-251608609.png",
      "store_id": "6a4c630c-991e-409d-bfaf-08b8b8a35f3d",
      "category_id": "aa9034b0-7f0f-4eec-8a77-28fe3e319a14",
      "Addon": [
        {
          "id": "9e821b53-1404-43ee-832d-b525350ea3c0",
          "name": "Sambusa",
          "price": 10,
          "product_id": "e89fdcd5-0450-49d1-b430-09b823dc8edc"
        },
        {
          "id": "bf9797dd-bfa3-4bd4-b500-0c9e4b9bf57b",
          "name": "Gomen",
          "price": 5,
          "product_id": "e89fdcd5-0450-49d1-b430-09b823dc8edc"
        }
      ]
    }
  ],
  "ProductCategories": [
    {
      "id": "24910b21-1233-48fc-bfa1-94931773f8bc",
      "name": "Lunch",
      "store_id": "6a4c630c-991e-409d-bfaf-08b8b8a35f3d"
    },
    {
      "id": "7faad460-89e2-4067-a6c4-bf3a224f902b",
      "name": "Breakfast",
      "store_id": "6a4c630c-991e-409d-bfaf-08b8b8a35f3d"
    },
    {
      "id": "aa9034b0-7f0f-4eec-8a77-28fe3e319a14",
      "name": "Lunch",
      "store_id": "6a4c630c-991e-409d-bfaf-08b8b8a35f3d"
    },
    {
      "id": "bef39466-ee9f-4c53-9d4a-2145bd3a4b9a",
      "name": "Dinner",
      "store_id": "6a4c630c-991e-409d-bfaf-08b8b8a35f3d"
    }
  ]
};

Map<String, dynamic> sampleResponseRestaurantList = {
  "status": true,
  "message": "Restaurants fetched successfully",
  "data": [
    {
      "id": "1215d88e-3951-4dce-b6c8-cb9a7cf6e71d",
      "name": "kk yellow",
      "location": "aastu infront of cafteria",
      "latitude": 123456,
      "longitude": 12345678,
      "logo": "logo-1727953402514-845764961.png",
      "cover_image": "coverImage-1727953402515-486384279.png",
      "vat": 5,
      "estimated_delivery_time": 56,
      "owner_id": "2c8f964a-aa9e-4121-af11-c5621bb4879e",
      "inside_aastu": false
    },
    {
      "id": "d42e0c06-20b4-4e09-ac00-0533f4b0b66d",
      "name": "api dog",
      "location": "infront of kilint prison beside cbe brach",
      "latitude": 123456,
      "longitude": 12345678,
      "logo": "logo-1727951074651-271951425.png",
      "cover_image": "coverImage-1727951074652-174701046.png",
      "vat": 5,
      "estimated_delivery_time": 56,
      "owner_id": "e5088899-80fa-4d80-9838-6b1588a8e82b",
      "inside_aastu": false
    }
  ]
};

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

  void fetchStores() async {
    storeLoadingStatus.value = ApiCallStatus.loading;
    storeLoadingErrorData.value = ErrorData(title: '', body: '', image: '');
    selectedIndex.value = 0;
    dio.Response response;
    try {
      response = await DioConfig.dio().get('/store/get-stores');
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        storeList = (response.data['data'] as List)
            .map((e) => Store.fromJson(e))
            .toList()
            .obs;
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
    Logger().d('/store/get-store?storeId=${selectedStore.value.id}');
    try {
      response = await DioConfig.dio().get(
        '/store/get-store/${selectedStore.value.id}',
      );
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        productList = (response.data['data']['product'] as List)
            .map((e) => Product.fromJson(e))
            .toList()
            .obs;
        productCategoryList.value =
            (response.data['data']['ProductCategories'] as List)
                .map((e) => ProductCategory.fromJson(e))
                .toList();
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
  void calculateTotalProductPrice() {
    totalProductPrice.value = 0;
    for (var product in cart) {
      totalProductPrice.value +=
          ((product.price ?? 0.0).toDouble() * (product.amount ?? 1));
      for (var addon in product.addons ?? []) {
        totalProductPrice.value +=
            ((addon.price ?? 0.0).toDouble() * (addon.amount ?? 1));
      }
    }
    totalProductPrice.refresh();
  }

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

  String calculateSpecificProductPrice(Product product) {
    // Calculate the base price of the product
    double basePrice = (product.price ?? 0.0) * (product.amount ?? 1) / 1;

    // Calculate the total price of addons
    double addonsPrice = 0.0;

    // Check if product.addons is not null and has elements
    if (product.addons != null && product.addons!.isNotEmpty) {
      // Use map to calculate the total addon price, and use fold to avoid "No element" error
      addonsPrice = product.addons!
          .map((e) => (e.price ?? 0.0) * (e.amount ?? 1))
          .fold(0.0, (sum, element) => sum + element);
    }

    // Calculate total price
    double totalPrice = basePrice + addonsPrice;

    // Return total price as a string
    return totalPrice.toString();
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
              child: Text('Undo')),
          snackPosition: SnackPosition.TOP,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
        );
      }
    }
  }

  var selectedPaymentPlan = PaymentMethod.NONE.obs;
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

  void placeOrder() {
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
      "paymentMethod": selectedPaymentPlan.value.name,
    };

    // Logging the generated body
    Logger().i(body);
  }

  String calculateStoreDeliveryFee(String storeId) {
    // Retrieve the list of products from the specific store
    List<Product> storeProducts =
        cart.where((product) => product.storeId == storeId).toList();

    if (storeProducts.isEmpty) {
      return '0.0'; // No products from this store, so no delivery fee
    }

    // Retrieve the store's delivery fee from the store list
    num storeDeliveryFee =
        storeList.firstWhere((store) => store.id == storeId).deliveryFee ??
            10.00; // Default delivery fee if not specified

    // Calculate total quantity of products in this store
    int totalQuantity =
        storeProducts.fold(0, (sum, product) => sum + (product.amount ?? 1));

    // Calculate the number of product batches (e.g., 3 products per batch)
    int productBatches = (totalQuantity / 3).ceil();

    // Calculate the total delivery fee for this store based on the number of batches
    num deliveryFee = productBatches * storeDeliveryFee;

    return deliveryFee.toString();
  }

  int calculateTotalQuantityOfProductsFromSpecificStore(String storeId) {
    // Retrieve the list of products from the specific store
    List<Product> storeProducts =
        cart.where((product) => product.storeId == storeId).toList();
    // Calculate total quantity of products in this store
    int totalQuantity =
        storeProducts.fold(0, (sum, product) => sum + (product.amount ?? 1));
    return totalQuantity;
  }

  @override
  void onInit() {
    fetchStores();
    super.onInit();
    ever(cart, (_) => calculateTotalProductPrice());
  }
}

enum PaymentMethod { NONE, CBE, TELEBIRR, WALLET }

extension PaymentMethodExtension on PaymentMethod {
  String get name {
    switch (this) {
      case PaymentMethod.NONE:
        return "NONE";
      case PaymentMethod.CBE:
        return "CBE";
      case PaymentMethod.TELEBIRR:
        return "TELEBIRR";
      case PaymentMethod.WALLET:
        return "WALLET";
    }
  }

  Widget get icon {
    switch (this) {
      case PaymentMethod.NONE:
        return const Icon(Icons.abc);
      case PaymentMethod.CBE:
        return Image.asset(
          'assets/images/CBE.jpg',
          height: 40,
          width: 40,
        );
      case PaymentMethod.TELEBIRR:
        return Image.asset(
          'assets/images/TELEBIRR.jpg',
          height: 40,
          width: 40,
        );
      case PaymentMethod.WALLET:
        return Icon(
          EneftyIcons.wallet_2_bold,
          size: 40,
          color: maincolor,
        );
    }
  }
}
