import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/components/restaurant/restaurant_detail_screen_top_section.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/widgets/animated_search_bar.dart';
import 'package:merkastu_v2/widgets/error_card.dart';
import 'package:merkastu_v2/widgets/product_card.dart';
import 'package:merkastu_v2/widgets/shimmers/shimmering_product_card.dart';

import '../../constants/assets.dart';
import '../../constants/constants.dart';
import '../../widgets/product_detail_bottom_sheet.dart';

class StoreDetailScreen extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>(tag: 'home');
  StoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          RestaurantDetailScreenTopSection(
              image: homeController.selectedStore.value.logo!,
              name: homeController.selectedStore.value.name!,
              location: homeController.selectedStore.value.location!,
              favorited: false),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(homeController.selectedCategory.value.name ??
                    'All products')),
                AnimatedSearchBar(
                  onChanged: homeController.searchForProducts,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => ListView.builder(
                      itemCount: homeController.productCategoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Obx(() => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  homeController.selectedCategory.value =
                                      homeController.productCategoryList[index];
                                  homeController.filterProducts();
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                      color: homeController
                                                  .selectedCategory.value.id ==
                                              homeController
                                                  .productCategoryList[index].id
                                          ? maincolor
                                          : Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      homeController.productCategoryList[index]
                                                  .id ==
                                              'all'
                                          ? 'All'
                                          : homeController
                                              .productCategoryList[index].name!,
                                      maxLines: 1,
                                      minFontSize: 9,
                                      maxFontSize: 12,
                                      stepGranularity: 0.5,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      })),
                ),
              ],
            ),
          ),
          Obx(
            () => homeController.productLoadingStatus.value ==
                    ApiCallStatus.loading
                ? Expanded(
                    child: ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return const ShimmeringProductCard();
                        }))
                : homeController.productLoadingErrorData.value.body != ''
                    ? ErrorCard(
                        errorData: homeController.productLoadingErrorData.value,
                        refresh: homeController.fetchProducts,
                      )
                    : homeController.filteredProductList.isEmpty
                        ? ErrorCard(
                            errorData: ErrorData(
                              title: '',
                              body: 'No products found',
                              image: Assets.empty,
                              buttonText: 'Retry',
                            ),
                            refresh: homeController.fetchProducts,
                          )
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                homeController.fetchProducts();
                              },
                              child: ListView.builder(
                                itemCount:
                                    homeController.filteredProductList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(ProductDetail(
                                          product: homeController
                                              .filteredProductList[index]));
                                    },
                                    child: ProductCard(
                                      image: homeController
                                          .filteredProductList[index].image!,
                                      name: homeController
                                          .filteredProductList[index].name!,
                                      description: homeController
                                          .filteredProductList[index]
                                          .description!,
                                      price: homeController
                                          .filteredProductList[index].price!
                                          .toString(),
                                      favorited: false,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
          ),
        ],
      )),
    );
  }
}
