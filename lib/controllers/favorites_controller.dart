import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/storage_config.dart';

import '../config/dio_config.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/store.dart';
import '../utils/api_call_status.dart';
import '../utils/error_data.dart';
import '../utils/error_utils.dart';

class FavoritesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Initialize the TabController
  @override
  void onInit() {
    super.onInit();
    fetchFavoritedStores();
    fetchFavoritedProducts();
    tabController = TabController(length: 2, vsync: this);
  }

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
  //
  // var cart = <Product>[].obs;
  // var itemsInCart = 0.obs;
  //
  // void filterStores() {
  //   filteredStoreList.value = List.from(storeList);
  //   if (all.value) {
  //     filteredStoreList.value = List.from(storeList);
  //   } else {
  //     filteredStoreList.value = filteredStoreList
  //         .where((element) => element.insideAastu == insideAastu.value)
  //         .toList();
  //   }
  // }
  //
  // void searchForStores(String query) {
  //   if (query.isEmpty) {
  //     filteredStoreList.value = List.from(storeList);
  //     return;
  //   }
  //   filteredStoreList.value = List.from(storeList);
  //   filteredStoreList.value = filteredStoreList
  //       .where((element) =>
  //       element.name!.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  // }

  void fetchFavoritedStores() async {
    storeLoadingStatus.value = ApiCallStatus.loading;
    storeLoadingErrorData.value = ErrorData(title: '', body: '', image: '');
    selectedIndex.value = 0;
    dio.Response response;
    try {
      response = await DioConfig.dio().get('/user/store/saved',
          options: dio.Options(headers: {
            'Authorization': ConfigPreference.getUserToken(),
          }));
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        storeList = (response.data['data'] as List)
            .map((e) => Store.fromJson(e['store']))
            .toList()
            .obs;
        filteredStoreList.value = List.from(storeList);
        storeLoadingStatus.value = ApiCallStatus.success;
      } else {
        if (response.data['message'] == 'No saved stores found') {
          storeList.value = <Store>[];
          filteredStoreList.value = List.from(storeList);
          storeLoadingStatus.value = ApiCallStatus.success;
        } else {
          throw Exception(response.data);
        }
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      storeLoadingStatus.value = ApiCallStatus.error;
      storeLoadingErrorData.value = await ErrorUtil.getErrorData(e.toString());
    }
  }
  //
  // void searchForProducts(String query) {
  //   if (query.isEmpty) {
  //     filteredProductList.value = List.from(productList);
  //     return;
  //   }
  //   filteredProductList.value = List.from(productList);
  //   filteredProductList.value = filteredProductList
  //       .where((element) =>
  //       element.name!.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  // }
  //
  // void filterProducts() {
  //   filteredProductList.value = List.from(productList);
  //   if (selectedCategory.value.id == 'all') {
  //     filteredProductList.value = List.from(productList);
  //   } else {
  //     filteredProductList.value = filteredProductList
  //         .where((element) => element.categoryId == selectedCategory.value.id)
  //         .toList();
  //   }
  // }

  void fetchFavoritedProducts() async {
    productLoadingStatus.value = ApiCallStatus.loading;
    productLoadingErrorData.value = ErrorData(title: '', body: '', image: '');
    selectedCategory.value = ProductCategory(id: 'all');
    dio.Response response;
    try {
      response = await DioConfig.dio().get('/user/store/product/saved',
          options: dio.Options(headers: {
            'Authorization': ConfigPreference.getUserToken(),
          }));
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        productList = (response.data['data'] as List)
            .map((e) => Product.fromJson(e['product']))
            .toList()
            .obs;
        // productCategoryList.value =
        //     (response.data['data']['ProductCategories'] as List)
        //         .map((e) => ProductCategory.fromJson(e))
        //         .toList();
        // productCategoryList.insert(0, ProductCategory(id: 'all'));
        filteredProductList.value = List.from(productList);
        productLoadingStatus.value = ApiCallStatus.success;
      } else {
        if (response.data['message'] == 'No saved products found') {
          productList.value = <Product>[];
          filteredProductList.value = List.from(productList);
          productLoadingStatus.value = ApiCallStatus.success;
        } else {
          throw Exception(response.data);
        }
      }
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      productLoadingStatus.value = ApiCallStatus.error;
      productLoadingErrorData.value =
          await ErrorUtil.getErrorData(e.toString());
    }
  }

  // Dispose of the controller when no longer needed
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
