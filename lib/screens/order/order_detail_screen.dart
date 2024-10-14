import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merkastu_v2/components/order/price_summary.dart';
import 'package:merkastu_v2/constants/assets.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/utils/order_status.dart';

import '../../components/order/order_summary.dart';
import '../../constants/constants.dart';
import '../../controllers/order_controller.dart';
import '../../utils/payment_methods.dart';
import '../../widgets/animated_widgets/loading.dart';
import '../../widgets/animated_widgets/loading_animated_button.dart';
import '../../widgets/cards/error_card.dart';
import '../../widgets/input_feilds/custom_input_field.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({
    super.key,
  });

  final OrderController controller = Get.find<OrderController>(tag: 'order');
  final TextEditingController transactionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        bottom: TabBar(
          controller: controller.orderDetailTabController,
          tabs: const [
            Tab(text: "Order"),
            Tab(text: "Payment"),
          ],
        ),
      ),
      body: Obx(() {
        var serviceCharge = (((controller.selectedOrder.value.orderPrice! +
                controller.selectedOrder.value.deliveryFee!) *
            0.15));

        return controller.gettingOrderDetail.value == ApiCallStatus.loading
            ? Center(
                child: Loading(
                  size: MediaQuery.of(context).size.width * 0.5,
                  color: maincolor,
                ),
              )
            : controller.gettingOrderDetail.value == ApiCallStatus.error
                ? Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: ErrorCard(
                        errorData: controller.errorGettingOrderDetail.value,
                        refresh: controller.fetchOrderDetail,
                      ),
                    ),
                  )
                : controller.storesInOrder.isEmpty ||
                        controller.productsInOrder.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                          child: ErrorCard(
                              errorData: ErrorData(
                                  title: 'No details found',
                                  body:
                                      'We couldn\'t find the details of this order, please try again',
                                  image: Assets.empty)),
                        ),
                      )
                    : TabBarView(
                        controller: controller.orderDetailTabController,
                        children: [
                          // Order Summary Tab
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, left: 16.0),
                                  child: Text(
                                    'Order summary',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                OrderSummary(
                                  groupedProducts:
                                      controller.groupedOrderProducts,
                                  storeList: controller.storesInOrder,
                                  calculateStoreDeliveryFee:
                                      controller.calculateStoreDeliveryFee,
                                  storeNameById: controller.storeNameById,
                                  calculateTotalQuantityOfProductsFromStore:
                                      controller
                                          .calculateTotalQuantityOfProductsFromSpecificStore,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, left: 16.0),
                                  child: Text(
                                    'Price summary',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                PriceSummary(
                                  subTotalPrice: controller
                                      .selectedOrder.value.orderPrice!,
                                  deliveryCharge: controller
                                      .selectedOrder.value.deliveryFee!,
                                  serviceCharge: serviceCharge,
                                  grandTotal: controller
                                      .selectedOrder.value.totalPrice!,
                                ),
                                if (controller
                                        .selectedOrder.value.orderStatus ==
                                    OrderStatus.inactive)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () => controller
                                              .orderDetailTabController
                                              .animateTo(1),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Pay for your order',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                EneftyIcons.arrow_right_4_bold,
                                                color: Colors.white,
                                              )
                                            ],
                                          )),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          // Payment Details Tab
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: controller.selectedOrder.value.orderStatus ==
                                    OrderStatus.inactive
                                ? _buildInactivePaymentSection()
                                : _buildVerifiedPaymentSection(),
                          ),
                        ],
                      );
      }),
    );
  }

  Widget _buildInactivePaymentSection() {
    final controller = Get.find<OrderController>(tag: 'order');
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(Get.context!).size.width * 0.43,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: maincolor),
              ),
              child: Center(
                child: DropdownButton<PaymentMethod>(
                  items: PaymentMethod.values
                      .where((e) => e != PaymentMethod.none)
                      .map((e) => DropdownMenuItem<PaymentMethod>(
                          value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (paymentMethod) {
                    controller.selectedPaymentMethod.value = paymentMethod!;
                  },
                  value: controller.selectedPaymentMethod.value ==
                          PaymentMethod.none
                      ? null
                      : controller.selectedPaymentMethod.value,
                  icon: Icon(
                    EneftyIcons.arrow_circle_down_bold,
                    size: 16,
                    color: maincolor,
                  ),
                  underline: const SizedBox.shrink(),
                  hint: const Text(
                    'Change payment method   ',
                    style: TextStyle(fontSize: 10),
                  ),
                  borderRadius: BorderRadius.circular(10),

                  // decoration: InputDecoration(
                  //   hintText: 'Change payment method',
                  //   icon: null,
                  //   suffixIcon: null,
                  //   suffix: null,
                  //   hintStyle: const TextStyle(fontSize: 10),
                  //   focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide(color: maincolor)),
                  //   enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide(color: maincolor)),
                  // ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 20),
          Center(child: controller.selectedOrder.value.payment!.cover),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Name:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Amanuel Wonde',
                      style: TextStyle(
                          color: maincolor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Account:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      controller.selectedOrder.value.payment!.accountNumber,
                      style: TextStyle(
                          color: maincolor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Text(
            'Please make a payment to the account listed above and paste the transaction/reference ID below',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          CustomInputField(
            inputController: transactionController,
            label: 'Transaction ID',
            hintText: 'Enter your transaction/reference ID',
            onChanged: (value) {
              controller.transactionId.value = value;
            },
          ),
          const SizedBox(height: 10),
          Obx(() => controller.verifyingPayment.value
              ? LoadingAnimatedButton(
                  width: double.infinity,
                  height: 50,
                  color: maincolor,
                  child: Text(
                    'Verifying payment...',
                    style: TextStyle(
                        color: maincolor, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {})
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: controller.transactionId.value != ''
                          ? () => controller.verifyPayment()
                          : null,
                      style: ElevatedButton.styleFrom(
                          disabledForegroundColor: Colors.grey,
                          disabledBackgroundColor: Colors.grey),
                      child: const Text(
                        'Verify payment',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )),
                )),
        ],
      ),
    );
  }

  Widget _buildVerifiedPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Get.find<OrderController>(tag: 'order')
                .selectedOrder
                .value
                .payment!
                .cover),
        const Padding(
          padding: EdgeInsets.only(top: 8.0, left: 16.0),
          child: Text(
            'Paid to',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Name:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Amanuel Wonde',
                style: TextStyle(color: maincolor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Account:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                controller.selectedOrder.value.payment!.accountNumber,
                style: TextStyle(color: maincolor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Paid on:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                DateFormat('d/MM/y, hh:mm a').format(controller
                    .selectedOrder.value.paidAt!
                    .toUtc()
                    .add(const Duration(hours: 3))),
                style: TextStyle(color: maincolor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
