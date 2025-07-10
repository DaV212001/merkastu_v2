import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/components/order/payment_method_selection.dart';
import 'package:merkastu_v2/components/order/price_summary.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/widgets/animated_widgets/loading_animated_button.dart';
import 'package:merkastu_v2/widgets/order_option_selector.dart';

import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../utils/payment_methods.dart';
import 'delivery_address_selection.dart';
import 'order_summary.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({
    super.key,
    required this.groupedProducts,
    required this.cartController,
    required this.subTotalPrice,
    required this.deliveryCharge,
    required this.serviceCharge,
    required this.grandTotal,
    required this.tabController,
  });

  final Map<String, List<Product>> groupedProducts;
  final CartController cartController;
  final double subTotalPrice;
  final double deliveryCharge;
  final double serviceCharge;
  final double grandTotal;
  final TabController tabController;

  // final CartController cartController = Get.find<CartController>(tag: 'cart');
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(
            () => cartController.orderId.value == ''
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
                  ),
          ),
          if (cartController.orderId.value != '')
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0),
              child: Row(
                children: [
                  const Text(
                    'Order Type: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(cartController.orderType!.value.nameDisplay),
                ],
              ),
            ),
          if (groupedProducts.isNotEmpty)
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
          if (groupedProducts.isNotEmpty)
            OrderSummary(
              groupedProducts: groupedProducts,
              calculateStoreDeliveryFee:
                  cartController.calculateStoreDeliveryFee,
              storeNameById: cartController.storeNameById,
              calculateTotalQuantityOfProductsFromStore: cartController
                  .calculateTotalQuantityOfProductsFromSpecificStore,
            ),
          const SizedBox(height: 10),
          if (cartController.hasNonDeliveryOnlyProduct.value &&
              cartController.orderId.value == '')
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                'Delivery Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (cartController.hasNonDeliveryOnlyProduct.value &&
              cartController.orderId.value == '')
            OrderOptionSelector(onSelectionChanged: (orderOption) {
              cartController.orderType.value = orderOption;
            }),
          if ((cartController.hasNonDeliveryOnlyProduct.value &&
                  cartController.orderType.value == OrderType.delivery) ||
              (!cartController.hasNonDeliveryOnlyProduct.value &&
                  (cartController.cart.isNotEmpty ||
                      cartController.orderType.value == OrderType.delivery)))
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
          if ((cartController.hasNonDeliveryOnlyProduct.value &&
                  cartController.orderType.value == OrderType.delivery) ||
              (!cartController.hasNonDeliveryOnlyProduct.value &&
                  (cartController.cart.isNotEmpty ||
                      cartController.orderType.value == OrderType.delivery)))
            DeliveryAddressSelection(homeController: cartController),
          if (cartController.orderId.value != '')
            Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Row(children: [
                    const Text(
                      'Selected Payment Method: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(cartController.selectedPaymentPlan.value.name)
                  ]),
                ),
              ],
            ),
          if (cartController.orderId.value != '') const SizedBox(height: 10),
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
          if (cartController.hasNonDeliveryOnlyProduct.value)
            const SizedBox(height: 10),
          if (cartController.orderId.value == '')
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
                if (cartController.orderId.value == '')
                  PaymentMethodSelection(
                    initialMethod: cartController.selectedPaymentPlan.value,
                    walletInsufficient:
                        UserController.walletBalance.value < grandTotal,
                    onMethodSelected: (paymentMethod) {
                      cartController.selectedPaymentPlan.value = paymentMethod;
                    },
                  ),
                Obx(
                  () =>
                      cartController.placingOrder.value == ApiCallStatus.loading
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
                                  onPressed: cartController
                                              .selectedPaymentPlan.value ==
                                          PaymentMethod.none
                                      ? null
                                      : cartController.placingOrder.value ==
                                                  ApiCallStatus.success &&
                                              cartController.orderId.value != ''
                                          ? () => tabController.animateTo(1)
                                          : () => cartController.placeOrder(
                                              tabController: tabController),
                                  style: ElevatedButton.styleFrom(
                                      disabledBackgroundColor: Colors.grey,
                                      disabledForegroundColor: maincolor),
                                  child: cartController.placingOrder.value ==
                                              ApiCallStatus.success &&
                                          cartController.orderId.value != ''
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
