import 'package:auto_size_text/auto_size_text.dart';
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
          Stack(
            alignment: Alignment.center,
            children: [
              Obx(() => Padding(
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
                            'Total: ETB ${homeController.totalProductPrice}',
                            maxLines: 1,
                            minFontSize: 5,
                            maxFontSize: 10,
                            stepGranularity: 0.5,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            // Group products by store
            Map<String, List<Product>> groupedCart =
                homeController.groupCartItemsByStore();

            return homeController.cart.isEmpty
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
                                '${homeController.storeNameById(storeId)}', // Assuming you have a method to get store name
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
                                  return GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                          ProductDetail(product: product));
                                    },
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) {
                                        homeController.removeProductFromCart(
                                            product,
                                            fromCartList: true);
                                      },
                                      background: Container(color: Colors.red),
                                      child: CartItemCard(
                                        // Build your cart item with product details here
                                        image: product.image!,
                                        name: product.name!,
                                        description: product.description!,
                                        price: homeController
                                            .calculateSpecificProductPrice(
                                                product),
                                        onAdd: () => homeController
                                            .addProductAmount(product),
                                        onDuplicate: () => homeController
                                            .duplicateProductToCart(product),
                                        onRemove: () {
                                          if (product.amount == 1) {
                                            homeController
                                                .removeProductFromCart(product,
                                                    fromCartList: true);
                                          } else {
                                            homeController
                                                .removeProductAmount(product);
                                          }
                                        },
                                        amount: product.amount.toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
          }),
          Obx(() => homeController.cart.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        UserController.getWalletBallance();
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
