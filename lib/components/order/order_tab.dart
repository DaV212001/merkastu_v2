import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/components/order/payment_method_selection.dart';
import 'package:merkastu_v2/components/order/price_summary.dart';

import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/product.dart';
import '../../utils/payment_methods.dart';
import 'delivery_address_selection.dart';
import 'order_summary.dart';

class Order extends StatelessWidget {
  const Order({
    super.key,
    required this.groupedProducts,
    required this.homeController,
    required this.subTotalPrice,
    required this.deliveryCharge,
    required this.serviceCharge,
    required this.grandTotal,
    required this.tabController,
  });

  final Map<String, List<Product>> groupedProducts;
  final HomeController homeController;
  final double subTotalPrice;
  final double deliveryCharge;
  final double serviceCharge;
  final double grandTotal;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() => Column(
                children: [
                  Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Icon(
                          EneftyIcons.tick_circle_bold,
                          color: maincolor,
                        ),
                      ),
                    ),
                  ),
                  Text('Order Placed Successfully',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: maincolor,
                      ))
                ],
              )),
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
          OrderSummary(
            groupedProducts: groupedProducts,
            homeController: homeController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              'Price summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PriceSummary(
            subTotalPrice: subTotalPrice,
            deliveryCharge: deliveryCharge,
            serviceCharge: serviceCharge,
            grandTotal: grandTotal,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              'Delivery address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DeliveryAddressSelection(homeController: homeController),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              'Select a payment method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentMethodSelection(
                  walletInsufficient:
                      UserController.walletBallance.value < grandTotal,
                  onMethodSelected: (paymentMethod) {
                    homeController.selectedPaymentPlan.value = paymentMethod;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: homeController.selectedPaymentPlan.value ==
                              PaymentMethod.none
                          ? null
                          : () => homeController.placeOrder(
                              tabController: tabController),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
