import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/assets.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/widgets/cards/cart_item_card.dart';
import 'package:merkastu_v2/widgets/cards/error_card.dart';
import 'package:merkastu_v2/widgets/product_detail_bottom_sheet.dart';

import '../../models/product.dart';

class CartScreen extends StatelessWidget {
  final CartController controller = Get.find<CartController>(tag: 'cart');
  final HomeController homeController = Get.find<HomeController>(tag: 'home');
  CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: maincolor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              )),
            ),
          ),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Obx(() => controller.listOfSelectedProductsInCart.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: maincolor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: AutoSizeText(
                          'Total: ETB ${controller.totalProductPrice}',
                          maxLines: 1,
                          minFontSize: 5,
                          maxFontSize: 10,
                          textAlign: TextAlign.center,
                          stepGranularity: 0.5,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.removeProductsFromCart(
                          controller.listOfSelectedProductsInCart,
                          fromCartList: true);
                      controller.listOfSelectedProductsInCart.clear();
                    },
                    child: Icon(
                      EneftyIcons.trash_bold,
                      color: maincolor,
                      size: 30,
                    ),
                  ),
                ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            // Group products by store
            Map<String, List<Product>> groupedCart =
                controller.groupCartItemsByStore();

            return controller.cart.isEmpty
                ? Center(
                    child: ErrorCard(
                      errorData: ErrorData(
                          title: 'No items',
                          body: 'Let\'s fill this cart up!',
                          image: Assets.emptyCart),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: groupedCart.keys.length,
                      itemBuilder: (context, storeIndex) {
                        String storeId = groupedCart.keys.elementAt(storeIndex);
                        List<Product> storeProducts = groupedCart[storeId]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8),
                              child: Text(
                                '${controller.storeNameById(storeId)}', // Assuming you have a method to get store name
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: storeProducts.length,
                                itemBuilder: (context, productIndex) {
                                  var product = storeProducts[productIndex];
                                  var favorited =
                                      (product.favorited ?? false).obs;
                                  return Obx(() => GestureDetector(
                                        onTap: () {
                                          Get.bottomSheet(
                                              ProductDetail(product: product));
                                        },
                                        child: Dismissible(
                                          key: UniqueKey(),
                                          onDismissed: (direction) {
                                            controller.removeProductFromCart(
                                                product,
                                                fromCartList: true);
                                          },
                                          background:
                                              Container(color: Colors.red),
                                          child: CartItemCard(
                                            favorited: favorited.value,
                                            onHeartTap: () {
                                              if (product.favorited!) {
                                                homeController
                                                    .unfavoriteProduct(product);
                                              } else {
                                                homeController
                                                    .favoriteProduct(product);
                                              }
                                            },
                                            image: product.image!,
                                            name: product.name!,
                                            description: product.description!,
                                            price: controller
                                                .calculateSpecificProductPrice(
                                                    product),
                                            onAdd: () => controller
                                                .addProductAmount(product),
                                            onDuplicate: () => controller
                                                .duplicateProductToCart(
                                                    product),
                                            onRemove: () {
                                              if (product.amount == 1) {
                                                controller
                                                    .removeProductFromCart(
                                                        product,
                                                        fromCartList: true);
                                              } else {
                                                controller.removeProductAmount(
                                                    product);
                                              }
                                            },
                                            amount: product.amount.toString(),
                                            onImageTap: () {
                                              controller.toggleSelectionInCart(
                                                  product);
                                            },
                                            isSelected: controller
                                                .listOfSelectedProductsInCart
                                                .contains(product),
                                          ),
                                        ),
                                      ));
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
          }),
          Obx(() => controller.cart.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        UserController.getWalletBalance();
                        Get.toNamed(Routes.checkoutRoute);
                      },
                      child: const Text(
                        'Proceed to checkout',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
