import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/components/order/payment_method_selection.dart';
import 'package:merkastu_v2/components/order/price_summary.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/widgets/animated_widgets/loading_animated_button.dart';

import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/product.dart';
import '../../utils/payment_methods.dart';
import 'delivery_address_selection.dart';
import 'order_summary.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({
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
          Obx(() => homeController.orderId.value == ''
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Icon(
                            EneftyIcons.tick_circle_bold,
                            color: maincolor,
                            size: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                      ),
                    ),
                    Text('Order Placed Successfully',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          OrderSummary(
            groupedProducts: groupedProducts,
            storeList: homeController.storeList,
            calculateStoreDeliveryFee: homeController.calculateStoreDeliveryFee,
            storeNameById: homeController.storeNameById,
            calculateTotalQuantityOfProductsFromStore: homeController
                .calculateTotalQuantityOfProductsFromSpecificStore,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              'Price summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
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
                Obx(
                  () =>
                      homeController.placingOrder.value == ApiCallStatus.loading
                          ? SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: LoadingAnimatedButton(
                                  color: maincolor,
                                  child: Text(
                                    'Placing order',
                                    style: TextStyle(
                                        color: maincolor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  onTap: () {}),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed: homeController
                                              .selectedPaymentPlan.value ==
                                          PaymentMethod.none
                                      ? null
                                      : homeController.placingOrder.value ==
                                              ApiCallStatus.success
                                          ? () => tabController.animateTo(1)
                                          : () => homeController.placeOrder(
                                              tabController: tabController),
                                  style: ElevatedButton.styleFrom(
                                      disabledBackgroundColor: Colors.grey,
                                      disabledForegroundColor: maincolor),
                                  child: homeController.placingOrder.value ==
                                          ApiCallStatus.success
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Pay for your order',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              EneftyIcons.arrow_right_4_bold,
                                              color: Colors.white,
                                            )
                                          ],
                                        )
                                      : const Text(
                                          'Place Order',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                ),
                              ),
                            ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
