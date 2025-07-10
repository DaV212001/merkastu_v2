import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:merkastu_v2/controllers/favorites_controller.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/utils/animations.dart';
import 'package:merkastu_v2/widgets/cards/product_card.dart';

import '../../constants/assets.dart';
import '../../constants/pages.dart';
import '../../models/store.dart';
import '../../utils/api_call_status.dart';
import '../../utils/error_data.dart';
import '../../widgets/cards/error_card.dart';
import '../../widgets/cards/store_card.dart';
import '../../widgets/product_detail_bottom_sheet.dart';
import '../../widgets/shimmers/shimmering_product_card.dart';
import '../../widgets/shimmers/shimmering_store_card.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesController controller =
      Get.put(FavoritesController(), tag: 'favorites');
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 70),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Favorites'),
        // centerTitle: true,
        flexibleSpace: SafeArea(
          child: TabBar(
            controller: controller.tabController,
            tabs: const [
              Tab(
                  icon: Icon(
                    EneftyIcons.shop_bold,
                    size: 16,
                  ),
                  text: 'Stores'),
              Tab(
                  icon: Icon(
                    Ionicons.fast_food,
                    size: 16,
                  ),
                  text: 'Products'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          Obx(
            () => controller.storeLoadingStatus.value == ApiCallStatus.loading
                ? ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return const ShimmeringStoreCard();
                    },
                  )
                : controller.storeLoadingErrorData.value.body != ''
                    ? ErrorCard(
                        errorData: controller.storeLoadingErrorData.value,
                        refresh: controller.fetchFavoritedStores,
                      )
                    : controller.filteredStoreList.isEmpty
                        ? ErrorCard(
                            errorData: ErrorData(
                                title: '',
                                body: 'No saved restaurants found',
                                image: Assets.empty,
                                buttonText: 'Retry'),
                            refresh: controller.fetchFavoritedStores,
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              controller.fetchFavoritedStores();
                            },
                            child: ListView.builder(
                                itemCount: controller.filteredStoreList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        final homeController =
                                            Get.find<HomeController>(
                                                tag: 'home');
                                        Store previousStore =
                                            homeController.selectedStore.value;
                                        homeController.selectedStore.value =
                                            controller.filteredStoreList[index];
                                        if (homeController
                                                .productList.isEmpty ||
                                            previousStore.id !=
                                                controller
                                                    .filteredStoreList[index]
                                                    .id) {
                                          homeController.fetchProducts();
                                        }
                                        Get.toNamed(
                                            Routes.restaurantDetailRoute,
                                            arguments: controller);
                                      },
                                      child: StoreCard(
                                        name: controller
                                            .filteredStoreList[index].name!,
                                        location: controller
                                            .filteredStoreList[index].location!,
                                        image: controller
                                            .filteredStoreList[index].cover!,
                                        deliveryTime: controller
                                            .filteredStoreList[index]
                                            .deliveryTime!
                                            .toString(),
                                        favorited: true,
                                        isAvailable: controller
                                                .filteredStoreList[index]
                                                .isAvailable ??
                                            false,
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation']!),
                                    ),
                                  );
                                }),
                          ),
          ),
          Obx(
            () => controller.productLoadingStatus.value == ApiCallStatus.loading
                ? ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return const ShimmeringProductCard();
                    },
                  )
                : controller.productLoadingErrorData.value.body != ''
                    ? ErrorCard(
                        errorData: controller.productLoadingErrorData.value,
                        refresh: controller.fetchFavoritedProducts,
                      )
                    : controller.filteredProductList.isEmpty
                        ? ErrorCard(
                            errorData: ErrorData(
                              title: '',
                              body: 'No saved products found',
                              image: Assets.empty,
                              buttonText: 'Retry',
                            ),
                            refresh: controller.fetchFavoritedProducts,
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              controller.fetchFavoritedProducts();
                            },
                            child: ListView.builder(
                              itemCount: controller.filteredProductList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(ProductDetail(
                                      product:
                                          controller.filteredProductList[index],
                                    ));
                                  },
                                  child: ProductCard(
                                    image: controller
                                        .filteredProductList[index].image!,
                                    name: controller
                                        .filteredProductList[index].name!,
                                    description: controller
                                        .filteredProductList[index]
                                        .description!,
                                    price: controller
                                        .filteredProductList[index].price!
                                        .toString(),
                                    favorited: true,
                                    onImageTap: () {},
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'containerOnPageLoadAnimation']!);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
