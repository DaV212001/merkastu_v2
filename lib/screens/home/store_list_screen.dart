import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/widgets/shimmers/shimmering_store_card.dart';
import 'package:merkastu_v2/widgets/store_card.dart';

import '../../components/restaurant/restaurant_list_top_section.dart';
import '../../constants/assets.dart';
import '../../models/store.dart';
import '../../utils/error_data.dart';
import '../../widgets/error_card.dart';

class StoreListScreen extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>(tag: 'home');
  StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RestaurantListTopSection(homeController: homeController),
            Obx(
              () => homeController.storeLoadingStatus.value ==
                      ApiCallStatus.loading
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return const ShimmeringStoreCard();
                        },
                      ),
                    )
                  : homeController.storeLoadingErrorData.value.body != ''
                      ? ErrorCard(
                          errorData: homeController.storeLoadingErrorData.value,
                          refresh: homeController.fetchStores,
                        )
                      : homeController.filteredStoreList.isEmpty
                          ? ErrorCard(
                              errorData: ErrorData(
                                  title: '',
                                  body: 'No restaurants found',
                                  image: Assets.empty,
                                  buttonText: 'Retry'),
                              refresh: homeController.fetchStores,
                            )
                          : Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  homeController.fetchStores();
                                },
                                child: ListView.builder(
                                    itemCount:
                                        homeController.filteredStoreList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Store previousStore = homeController
                                                .selectedStore.value;
                                            homeController.selectedStore.value =
                                                homeController
                                                    .filteredStoreList[index];
                                            if (homeController
                                                    .productList.isEmpty ||
                                                previousStore.id !=
                                                    homeController
                                                        .filteredStoreList[
                                                            index]
                                                        .id) {
                                              homeController.fetchProducts();
                                            }
                                            Get.toNamed(
                                                Routes.restaurantDetailRoute);
                                          },
                                          child: StoreCard(
                                              name: homeController
                                                  .filteredStoreList[index]
                                                  .name!,
                                              location: homeController
                                                  .filteredStoreList[index]
                                                  .location!,
                                              image: homeController
                                                  .filteredStoreList[index]
                                                  .cover!,
                                              deliveryTime: homeController
                                                  .filteredStoreList[index]
                                                  .deliveryTime!
                                                  .toString()),
                                        ),
                                      );
                                    }),
                              ),
                            ),
            ),
            // const ProductCard(
            //     image:
            //         'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            //     name: 'Burger',
            //     description: 'fffffffffffffffffffffffffffffff',
            //     price: '234',
            //     favorited: false),
            // const RestaurantDetailScreenTopSection(
            //   image:
            //       'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            //   name: 'Burger King',
            //   location: 'Infront of Kilinto prison jjjjjjjjj',
            //   favorited: false,
            // )
          ],
        ),
      ),
    );
  }
}
