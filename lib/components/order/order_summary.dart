import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../controllers/home_controller.dart';
import '../../models/product.dart';
import '../../models/store.dart';
import '../../widgets/product_check_out_card.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.groupedProducts,
    required this.homeController,
  });

  final Map<String, List<Product>> groupedProducts;
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
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
                0, (sum, product) => sum + num.parse(product.totalPrice()));

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
                    (homeController.storeNameById(storeId) ?? "Unknown Store")
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
                        "Store total: ${(storeTotalPrice + double.parse(homeController.calculateStoreDeliveryFee(storeId))).toStringAsFixed(2)} Birr",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        (numberOfProductsFromStoreInCart / 3)
                                            .ceil();
                                    return AlertDialog(
                                      title: const Text("Delivery Charge Info"),
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
    );
  }
}
