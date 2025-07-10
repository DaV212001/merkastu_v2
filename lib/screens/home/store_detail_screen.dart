import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badge;
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/components/restaurant/restaurant_detail_screen_top_section.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/widgets/animated_widgets/animated_search_bar.dart';
import 'package:merkastu_v2/widgets/cards/error_card.dart';
import 'package:merkastu_v2/widgets/cards/product_card.dart';
import 'package:merkastu_v2/widgets/shimmers/shimmering_product_card.dart';

import '../../constants/assets.dart';
import '../../constants/constants.dart';
import '../../controllers/drag_and_drop_controller.dart';
import '../../models/product.dart';
import '../../widgets/product_detail_bottom_sheet.dart';

class StoreDetailScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>(tag: 'home');
  final CartController cartController = Get.find<CartController>(tag: 'cart');
  final DragDropController dragDropController = Get.put(DragDropController());
  StoreDetailScreen({super.key});

  // Define an initial position for the draggable FAB
  final Rx<Offset> fabPosition = Offset(
    MediaQuery.of(Get.context!).size.width -
        MediaQuery.of(Get.context!).size.width * 0.18,
    MediaQuery.of(Get.context!).size.height -
        MediaQuery.of(Get.context!).size.height * 0.12,
  ).obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                RestaurantDetailScreenTopSection(
                  image: controller.selectedStore.value.logo!,
                  name: controller.selectedStore.value.name!,
                  location: controller.selectedStore.value.location!,
                  favorited: controller.selectedStore.value.favorited,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            controller.selectedCategory.value.name ??
                                'All products',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )),
                      AnimatedSearchBar(
                        onChanged: controller.searchForProducts,
                      ),
                    ],
                  ),
                ),
                ProductCategorySection(controller: controller),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => controller.productLoadingStatus.value ==
                          ApiCallStatus.loading
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: 10,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return const ShimmeringProductCard();
                            },
                          ),
                        )
                      : controller.productLoadingErrorData.value.body != ''
                          ? ErrorCard(
                              errorData:
                                  controller.productLoadingErrorData.value,
                              refresh: controller.fetchProducts,
                            )
                          : controller.filteredProductList.isEmpty
                              ? ErrorCard(
                                  errorData: ErrorData(
                                    title: '',
                                    body: 'No products found',
                                    image: Assets.empty,
                                    buttonText: 'Retry',
                                  ),
                                  refresh: controller.fetchProducts,
                                )
                              : Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      controller.fetchProducts();
                                    },
                                    child: ListView.builder(
                                      itemCount:
                                          controller.filteredProductList.length,
                                      itemBuilder: (context, index) {
                                        var currentProduct = controller
                                            .filteredProductList[index];
                                        return Obx(() =>
                                            LongPressDraggable<Product>(
                                              data:
                                                  currentProduct, // The product being dragged
                                              feedback: Opacity(
                                                opacity: 0.7,
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: ProductCard(
                                                    // Product card shown during drag
                                                    image:
                                                        currentProduct.image!,
                                                    forGhost: true,
                                                    name: currentProduct.name!,
                                                    description: currentProduct
                                                        .description!,
                                                    price: currentProduct.price!
                                                        .toString(),
                                                    favorited: currentProduct
                                                            .favorited ??
                                                        false,
                                                    onHeartTap:
                                                        () {}, // Disable interactions during drag
                                                    onImageTap: () {},
                                                    isSelected: false,
                                                  ),
                                                ),
                                              ),
                                              onDragStarted: () =>
                                                  dragDropController
                                                      .startDragging(
                                                          currentProduct),
                                              onDraggableCanceled: (_, __) =>
                                                  dragDropController
                                                      .stopDragging(),
                                              onDragEnd: (_) =>
                                                  dragDropController
                                                      .stopDragging(),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (controller.selectedStore
                                                          .value.isAvailable ==
                                                      true) {
                                                    Get.bottomSheet(
                                                        ProductDetail(
                                                      product: currentProduct,
                                                    ));
                                                  }
                                                },
                                                child: ProductCard(
                                                  image: currentProduct.image!,
                                                  name: currentProduct.name!,
                                                  description: currentProduct
                                                      .description!,
                                                  price: currentProduct.price!
                                                      .toString(),
                                                  favorited: currentProduct
                                                          .favorited ??
                                                      false,
                                                  onHeartTap: () {
                                                    if (currentProduct
                                                        .favorited!) {
                                                      controller
                                                          .unfavoriteProduct(
                                                              currentProduct);
                                                    } else {
                                                      controller
                                                          .favoriteProduct(
                                                              currentProduct);
                                                    }
                                                  },
                                                  onImageTap: () {
                                                    Logger().d('IS AVAILABLE: '
                                                        '${controller.selectedStore.value.isAvailable}');
                                                    controller
                                                                .selectedStore
                                                                .value
                                                                .isAvailable ==
                                                            true
                                                        ? cartController
                                                            .toggleSelectionInStore(
                                                                currentProduct)
                                                        : Get.snackbar('Error',
                                                            'Cannot select products when store is closed');
                                                  },
                                                  isSelected: cartController
                                                      .listOfSelectedProductsInStore
                                                      .contains(currentProduct),
                                                ),
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                ),
              ],
            ),
            Obx(() => Positioned(
                  left: fabPosition.value.dx,
                  top: fabPosition.value.dy,
                  child: DragTarget<Product>(
                    onAcceptWithDetails: (DragTargetDetails<Product> product) {
                      if (controller.selectedStore.value.isAvailable == true) {
                        dragDropController.addToCart(product.data);
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Draggable(
                        feedback: FloatingActionButton(
                          backgroundColor: maincolor,
                          onPressed: () => Get.toNamed(Routes.cartRoute),
                          child: Obx(() => badge.Badge(
                                showBadge:
                                    cartController.numberOfItemsInCart.value >
                                        0,
                                badgeContent: Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      cartController.numberOfItemsInCart.value
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  EneftyIcons.shopping_cart_bold,
                                  size: 35,
                                ),
                              )),
                        ),
                        onDragEnd: (dragDetails) {
                          fabPosition.value = dragDetails.offset;
                        },
                        childWhenDragging:
                            Container(), // Empty container when dragging
                        child: FloatingActionButton(
                          backgroundColor: maincolor,
                          onPressed: () => Get.toNamed(Routes.cartRoute),
                          child: Obx(() => badge.Badge(
                                showBadge:
                                    cartController.numberOfItemsInCart.value >
                                        0,
                                badgeContent: Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      cartController.numberOfItemsInCart.value
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  EneftyIcons.shopping_cart_outline,
                                  size: 35,
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ProductCategorySection extends StatelessWidget {
  const ProductCategorySection({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.productCategoryList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.selectedCategory.value =
                              controller.productCategoryList[index];
                          controller.filterProducts();
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                              color: controller.selectedCategory.value.id ==
                                      controller.productCategoryList[index].id
                                  ? maincolor
                                  : Colors.grey,
                              width: controller.selectedCategory.value.id ==
                                      controller.productCategoryList[index].id
                                  ? 2
                                  : 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 70,
                              child: AutoSizeText(
                                controller.productCategoryList[index].id ==
                                        'all'
                                    ? 'All'
                                    : controller
                                        .productCategoryList[index].name!,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                minFontSize: 5,
                                maxFontSize: 10,
                                stepGranularity: 0.5,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: controller.selectedCategory.value.id ==
                                          controller
                                              .productCategoryList[index].id
                                      ? maincolor
                                      : null,
                                  fontWeight:
                                      controller.selectedCategory.value.id ==
                                              controller
                                                  .productCategoryList[index].id
                                          ? FontWeight.w600
                                          : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
