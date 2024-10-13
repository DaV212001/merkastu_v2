import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/widgets/cards/store_card.dart';

import '../../components/restaurant/restaurant_list_top_section.dart';
import '../../constants/assets.dart';
import '../../models/store.dart';
import '../../utils/animations.dart';
import '../../utils/error_data.dart';
import '../../widgets/cards/error_card.dart';
import '../../widgets/shimmers/shimmering_store_card.dart';

class StoreListScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>(tag: 'home');
  StoreListScreen({super.key});
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
      body: SafeArea(
        child: Column(
          children: [
            RestaurantListTopSection(homeController: controller),
            Obx(
              () => controller.storeLoadingStatus.value == ApiCallStatus.loading
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return const ShimmeringStoreCard();
                        },
                      ),
                    )
                  : controller.storeLoadingErrorData.value.body != ''
                      ? ErrorCard(
                          errorData: controller.storeLoadingErrorData.value,
                          refresh: controller.fetchStores,
                        )
                      : controller.filteredStoreList.isEmpty
                          ? ErrorCard(
                              errorData: ErrorData(
                                  title: '',
                                  body: 'No restaurants found',
                                  image: Assets.empty,
                                  buttonText: 'Retry'),
                              refresh: controller.fetchStores,
                            )
                          : Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  controller.fetchStores();
                                },
                                child: ListView.builder(
                                    itemCount:
                                        controller.filteredStoreList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Store previousStore =
                                                controller.selectedStore.value;
                                            controller.selectedStore.value =
                                                controller
                                                    .filteredStoreList[index];
                                            if (controller
                                                    .productList.isEmpty ||
                                                previousStore.id !=
                                                    controller
                                                        .filteredStoreList[
                                                            index]
                                                        .id) {
                                              controller.fetchProducts();
                                            }
                                            Get.toNamed(
                                                Routes.restaurantDetailRoute,
                                                arguments: controller);
                                          },
                                          child: StoreCard(
                                            name: controller
                                                .filteredStoreList[index].name!,
                                            location: controller
                                                .filteredStoreList[index]
                                                .location!,
                                            image: controller
                                                .filteredStoreList[index]
                                                .cover!,
                                            deliveryTime: controller
                                                .filteredStoreList[index]
                                                .deliveryTime!
                                                .toString(),
                                            favorited: controller
                                                .filteredStoreList[index]
                                                .favorited,
                                            onHeartTap: () {
                                              if (controller
                                                  .filteredStoreList[index]
                                                  .favorited) {
                                                controller.unfavoriteStore(
                                                    controller
                                                            .filteredStoreList[
                                                        index]);
                                              } else {
                                                controller.favoriteStore(
                                                    controller
                                                            .filteredStoreList[
                                                        index]);
                                              }
                                            },
                                          ).animateOnPageLoad(animationsMap[
                                              'containerOnPageLoadAnimation']!),
                                        ),
                                      );
                                    }),
                              ),
                            ),
            ),
            SizedBox(
              height: 70.h,
            )
          ],
        ),
      ),
    );
  }
}
