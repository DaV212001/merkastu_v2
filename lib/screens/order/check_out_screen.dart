import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/controllers/checkout_controller.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/models/order.dart';
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

  final CartController controller = Get.find<CartController>(tag: 'cart');
  final HomeController homeController = Get.find<HomeController>(tag: 'home');
  final CheckoutController checkoutController = Get.put(CheckoutController());

  //form key for receipt link
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.orderId.value != '') {
          controller.cart.clear();
          controller.numberOfItemsInCart.value = 0;
          controller.numberOfItemsInCart.refresh();
          controller.cart.refresh();
        }

        controller.orderId.value = '';
        controller.transactionId.value = '';
        controller.selectedPaymentPlan.value = PaymentMethod.none;
        // controller.groupItems.value = true;
        // controller.cart.clear();
        // controller.cart.refresh();
        // controller.numberOfItemsInCart.value = 0;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Checkout",
          ),
          actions: const [WalletBalance()],
        ),
        body: Obx(() {
          Map<String, List<Product>> groupedProducts =
              controller.groupCartItemsByStore();
          // List<Product> products = controller.cart;
          //
          // double subTotalPrice = 0.00;
          // double deliveryCharge = 0.00; // Now calculated per store
          // double serviceCharge = 0.00;
          // double grandTotal = 0.00;

          // // Calculate the subtotal (product prices) first
          // for (var product in products) {
          //   subTotalPrice += num.parse(product.totalPrice());
          // }

          // Group products by store and calculate store-specific delivery fees

          // groupedProducts.forEach((storeId, storeProducts) {
          //   // Find the store's delivery fee from the store list
          //   String storeName =
          //       controller.storeNameById(storeId) ?? "Unknown Store";
          //   num storeDeliveryFee = homeController.storeList
          //       .firstWhere((store) => store.id == storeId)
          //       .deliveryFee ??
          //       10.00;
          //
          //   // You can adjust how you want to calculate the delivery charge based on the number of products, batches, etc.
          //   int totalQuantity = storeProducts.fold(
          //       0, (sum, product) => sum + (product.amount ?? 1));
          //   int productBatches = (totalQuantity / 3).ceil();
          //
          //   deliveryCharge += productBatches *
          //       storeDeliveryFee; // Different stores can have different fees
          // });
          //
          // if (controller.orderType.value == OrderType.delivery) {
          //   // Calculate the grand total (subtotal + delivery charges)
          //   grandTotal = subTotalPrice + deliveryCharge;
          // } else {
          //   grandTotal = subTotalPrice;
          //   deliveryCharge = 0;
          // }
          //
          // // Calculate the service charge as 7% of the grand total
          // serviceCharge = controller.hasNonDeliveryOnlyProduct.value
          //     ? controller.cart.length.toDouble()
          //     : (grandTotal * 0.07);
          //
          // // Add service charge to the grand total
          // grandTotal += serviceCharge;

          return Column(
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
                      cartController: controller,
                      subTotalPrice: checkoutController.subTotalPrice.value,
                      deliveryCharge: checkoutController.deliveryCharge.value,
                      serviceCharge: checkoutController.serviceCharge.value,
                      grandTotal: checkoutController.grandTotal.value,
                    ),
                    PaymentTab(
                        controller: controller,
                        tabController: _tabController,
                        checkoutController: checkoutController,
                        formKey: formKey,
                        transactionController: transactionController)
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class PaymentTab extends StatelessWidget {
  const PaymentTab({
    super.key,
    required this.controller,
    required TabController tabController,
    required this.checkoutController,
    required this.formKey,
    required this.transactionController,
  }) : _tabController = tabController;

  final CartController controller;
  final TabController _tabController;
  final CheckoutController checkoutController;
  final GlobalKey<FormState> formKey;
  final TextEditingController transactionController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => controller.selectedPaymentPlan.value == PaymentMethod.none ||
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Name:',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  controller.nameOfStoreAccount.value.isEmpty
                                      ? 'Amanuel Wonde'
                                      : controller.nameOfStoreAccount.value,
                                  style: TextStyle(
                                      color: maincolor,
                                      fontWeight: FontWeight.w600),
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
                                Row(
                                  children: [
                                    Text(
                                      controller.storeAccount.value.isEmpty
                                          ? controller.selectedPaymentPlan.value
                                              .accountNumber
                                          : controller.storeAccount.value,
                                      style: TextStyle(
                                          color: maincolor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                          text: controller
                                                  .storeAccount.value.isEmpty
                                              ? controller.selectedPaymentPlan
                                                  .value.accountNumber
                                              : controller.storeAccount.value,
                                        )).then((_) {
                                          Get.snackbar(
                                              'Copied', 'Copied to clipboard',
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        });
                                      },
                                      child: Icon(
                                        EneftyIcons.copy_outline,
                                        color: maincolor,
                                        size: 16,
                                      ),
                                    )
                                  ],
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
                            Text(
                              controller.orderType.value != OrderType.delivery
                                  ? 'Please make a payment of ${checkoutController.grandTotal.value.roundToDouble().toStringAsFixed(2)} Birr to the account listed above and paste the transaction/reference ID below'
                                  : 'Please make a payment of ${(checkoutController.grandTotal.value - checkoutController.deliveryCharge.value).roundToDouble().toStringAsFixed(2)} Birr to the account listed above and paste the transaction/reference ID below. Keep in mind, since you requested delivery, you will pay the delivery charge of ${(checkoutController.deliveryCharge.value).roundToDouble().toStringAsFixed(2)} Birr to the delivery person when you receive your order.',
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '⚠️NOTE: Please make sure you are using a SIM issued by Ethio Telecom for this operation.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: formKey,
                              child: CustomInputField(
                                inputController: transactionController,
                                label: 'Transaction receipt',
                                hintText: 'Enter your receipt link',
                                onChanged: (value) {
                                  print(value);
                                  controller.transactionId.value = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return 'Please enter a transaction receipt';
                                  if (controller.selectedPaymentPlan.value ==
                                      PaymentMethod.cbe) {
                                    if (!value!.startsWith(
                                        'https://apps.cbe.com.et:100/?id=')) {
                                      return 'Please enter a valid CBE receipt link';
                                    }
                                  } else if (controller
                                          .selectedPaymentPlan.value ==
                                      PaymentMethod.teleBirr) {
                                    if (!value!.startsWith(
                                        'https://transactioninfo.ethiotelecom.et/receipt/')) {
                                      return 'Please enter a valid Telebirr receipt link';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Sample: ',
                                      style: TextStyle(
                                          color: maincolor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: controller
                                          .selectedPaymentPlan.value.sampleLink,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ])),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(() => controller.verifyingPayment.value
                                ? LoadingAnimatedButton(
                                    width: double.infinity,
                                    height: 50,
                                    color: maincolor,
                                    child: Text(
                                      'Verifying payment...',
                                      style: TextStyle(
                                          color: maincolor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onTap: () {})
                                : SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed:
                                            controller.transactionId.value != ''
                                                ? () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      controller
                                                          .verifyPayment();
                                                    }
                                                  }
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
                                              fontWeight: FontWeight.w600,
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
    );
  }
}
