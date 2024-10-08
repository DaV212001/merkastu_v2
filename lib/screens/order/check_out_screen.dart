import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/components/payment_method_selection.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/models/product.dart';

import '../../models/store.dart';
import '../../widgets/loading.dart';
import '../../widgets/product_check_out_card.dart';

class CheckOutScreen extends StatelessWidget {
  CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>(tag: 'home');
    List<Product> products = homeController.cart;

    double subTotalPrice = 0.00;
    double deliveryCharge = 0.00; // Now calculated per store
    double serviceCharge = 0.00;
    double grandTotal = 0.00;

    // Calculate the subtotal (product prices) first
    for (var product in products) {
      subTotalPrice += num.parse(product.totalPrice());
    }

    // Group products by store and calculate store-specific delivery fees
    Map<String, List<Product>> groupedProducts =
        homeController.groupCartItemsByStore();
    groupedProducts.forEach((storeId, storeProducts) {
      // Find the store's delivery fee from the store list
      String storeName =
          homeController.storeNameById(storeId) ?? "Unknown Store";
      num storeDeliveryFee = homeController.storeList
              .firstWhere((store) => store.id == storeId)
              .deliveryFee ??
          10.00;

      // You can adjust how you want to calculate the delivery charge based on the number of products, batches, etc.
      int totalQuantity =
          storeProducts.fold(0, (sum, product) => sum + (product.amount ?? 1));
      int productBatches = (totalQuantity / 3).ceil();

      deliveryCharge += productBatches *
          storeDeliveryFee; // Different stores can have different fees
    });

    // Calculate the grand total (subtotal + delivery charges)
    grandTotal = subTotalPrice + deliveryCharge;

    // Calculate the service charge as 10% of the grand total
    serviceCharge = grandTotal * 0.10;

    // Add service charge to the grand total
    grandTotal += serviceCharge;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
        ),
        // backgroundColor: secondarycolor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: maincolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => UserController.loadingBalance.value
                        ? const Loading(
                            color: Colors.white,
                            size: 40,
                          )
                        : Row(
                            children: [
                              const Icon(
                                EneftyIcons.wallet_2_bold,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                UserController.walletBallance.value.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                  ),
                )),
          )
        ],
      ),
      // backgroundColor: secondarycolor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                'Order summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: ListView.builder(
                  itemCount: groupedProducts.keys.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, storeIndex) {
                    String storeId = groupedProducts.keys.elementAt(storeIndex);
                    Store store = homeController.storeList
                        .firstWhere((store) => store.id == storeId);
                    List<Product> storeProducts = groupedProducts[storeId]!;
                    double storeTotalPrice = storeProducts.fold(
                        0,
                        (sum, product) =>
                            sum + num.parse(product.totalPrice()));

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          // backgroundColor: maincolor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: BorderSide(color: maincolor)),
                          collapsedBackgroundColor: maincolor.withOpacity(0.2),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          initiallyExpanded: true,
                          childrenPadding:
                              const EdgeInsets.only(left: 16.0, bottom: 16.0),
                          title: Text(
                            (homeController.storeNameById(storeId) ??
                                    "Unknown Store")
                                .trim(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: maincolor),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total: ${storeTotalPrice + double.parse(homeController.calculateStoreDeliveryFee(storeId))} Birr",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: storeProducts.length,
                                itemBuilder: (context, index) {
                                  Product product = storeProducts[index];
                                  return ProductCheckOutCard(product: product);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  'Delivery fee for this store: ${store.deliveryFee} Birr'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                      'Delivery charge: ${homeController.calculateStoreDeliveryFee(storeId)} Birr'),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            var numberOfProductsFromStoreInCart =
                                                homeController
                                                    .calculateTotalQuantityOfProductsFromSpecificStore(
                                                        storeId);
                                            var numberOfBatches =
                                                (numberOfProductsFromStoreInCart /
                                                        3)
                                                    .ceil();
                                            return AlertDialog(
                                              title: const Text(
                                                  "Delivery Charge Info"),
                                              content: Text(
                                                "The delivery fee is charged for every batch of 3 products in your cart. In this case, ${store.deliveryFee} Birr per batch from this store. You have a total of $numberOfProductsFromStoreInCart ${numberOfProductsFromStoreInCart > 1 ? 'products' : 'product'} from ${store.name} in your cart, which amounts to $numberOfBatches ${numberOfBatches > 1 ? 'batches' : 'batch'}, and thus you are charged with ${homeController.calculateStoreDeliveryFee(storeId)} Birr ",
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text("OK"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.info_outline,
                                        color: maincolor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subtotal: $subTotalPrice Birr",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Total delivery charge: $deliveryCharge Birr"),
                    Row(
                      children: [
                        Text("Service Charge: $serviceCharge Birr"),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Service Charge Info"),
                                    content: const Text(
                                      "The service charge is 10% of the subtotal + delivery charges.",
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.info_outline,
                              color: maincolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total: $grandTotal Birr",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Select a payment method",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    PaymentMethodSelection(
                        walletInsufficient:
                            UserController.walletBallance.value < grandTotal,
                        onMethodSelected: (paymentMethod) {
                          homeController.selectedPaymentPlan.value =
                              paymentMethod;
                        }),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: homeController.selectedPaymentPlan.value ==
                                  PaymentMethod.NONE
                              ? null
                              : () => homeController.placeOrder(),
                          style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.grey,
                              disabledForegroundColor: maincolor),
                          child: const Text(
                            'Place Order',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
