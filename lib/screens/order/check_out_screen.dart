import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/models/product.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/utils/payment_methods.dart';
import 'package:merkastu_v2/widgets/animated_widgets/loading_animated_button.dart';
import 'package:merkastu_v2/widgets/input_feilds/custom_input_field.dart';

import '../../components/order/order_tab.dart';
import '../../constants/assets.dart';
import '../../widgets/cards/error_card.dart';
import '../../widgets/wallet_balance.dart';

class CheckOutScreen extends StatefulWidget {
  CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  var transactionController = TextEditingController();
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>(tag: 'home');
    List<Product> products = controller.cart;

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
        controller.groupCartItemsByStore();
    groupedProducts.forEach((storeId, storeProducts) {
      // Find the store's delivery fee from the store list
      String storeName = controller.storeNameById(storeId) ?? "Unknown Store";
      num storeDeliveryFee = controller.storeList
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
    serviceCharge = (grandTotal * 0.15);

    // Add service charge to the grand total
    grandTotal += serviceCharge;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
        ),
        actions: const [WalletBalance()],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Order'),
              Tab(text: 'Payment'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OrderTab(
                  tabController: _tabController,
                  groupedProducts: groupedProducts,
                  homeController: controller,
                  subTotalPrice: subTotalPrice,
                  deliveryCharge: deliveryCharge,
                  serviceCharge: serviceCharge,
                  grandTotal: grandTotal,
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => controller.selectedPaymentPlan.value ==
                                    PaymentMethod.none ||
                                controller.orderId.value == ''
                            ? Center(
                                child: ErrorCard(
                                  errorData: ErrorData(
                                      title: 'No payment method',
                                      body:
                                          'Please select a payment method and place your order.',
                                      buttonText: 'Go back',
                                      image: Assets.errorsNotVerified),
                                  refresh: () => _tabController.animateTo(0),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  controller.selectedPaymentPlan.value.cover,
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Name:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              'Amanuel Wonde',
                                              style: TextStyle(
                                                  color: maincolor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Account:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              controller.selectedPaymentPlan
                                                  .value.accountNumber,
                                              style: TextStyle(
                                                  color: maincolor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Please make a payment to the account listed above and paste the transaction/reference ID below',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        CustomInputField(
                                          inputController:
                                              transactionController,
                                          label: 'Transaction ID',
                                          hintText:
                                              'Enter your transaction/reference ID',
                                          onChanged: (value) {
                                            print(value);
                                            controller.transactionId.value =
                                                value;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Obx(() => controller
                                                .verifyingPayment.value
                                            ? LoadingAnimatedButton(
                                                width: double.infinity,
                                                height: 50,
                                                color: maincolor,
                                                child: Text(
                                                  'Verifying payment...',
                                                  style: TextStyle(
                                                      color: maincolor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                onTap: () {})
                                            : SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: ElevatedButton(
                                                    onPressed: controller
                                                                .transactionId
                                                                .value !=
                                                            ''
                                                        ? () => controller
                                                            .verifyPayment()
                                                        : null,
                                                    style: ElevatedButton.styleFrom(
                                                        disabledForegroundColor:
                                                            Colors.grey,
                                                        disabledBackgroundColor:
                                                            Colors.grey),
                                                    child: const Text(
                                                      'Verify payment',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16),
                                                    )),
                                              )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
