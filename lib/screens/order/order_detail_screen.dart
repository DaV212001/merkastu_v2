import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merkastu_v2/components/order/price_summary.dart';
import 'package:merkastu_v2/constants/assets.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/models/order.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/utils/order_status.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/order/order_summary.dart';
import '../../constants/constants.dart';
import '../../controllers/order_detail_controller.dart';
import '../../utils/payment_methods.dart';
import '../../widgets/animated_widgets/loading.dart';
import '../../widgets/animated_widgets/loading_animated_button.dart';
import '../../widgets/cached_image_widget_wrapper.dart';
import '../../widgets/cards/error_card.dart';
import '../../widgets/input_feilds/custom_input_field.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({
    super.key,
  });

  final OrderDetailController controller =
      Get.put(OrderDetailController(), permanent: true);
  final CartController cartController = Get.find<CartController>(tag: 'cart');
  final TextEditingController transactionController = TextEditingController();
  void _makePhoneCall(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    await launchUrl(
      phoneUri,
      mode: LaunchMode.externalApplication,
    );
  }

  final formKey = GlobalKey<FormState>();
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
            // Tab(
            //   text: 'Delivery',
            // )
          ],
        ),
      ),
      body: Obx(() {
        bool isOrderFromNonDeliveryOnly = cartController
            .isOrderFromNonDeliveryOnly(controller.orderPassed.value);
        var serviceCharge = (((controller.orderPassed.value.orderPrice! +
                controller.orderPassed.value.deliveryFee!) *
            0.05));

        return controller.gettingOrderDetail.value == ApiCallStatus.loading
            ? Loading(
                size: MediaQuery.of(context).size.width * 0.3,
                color: maincolor,
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
                                if (controller
                                        .selectedOrder.value.orderStatus ==
                                    OrderStatus.accepted)
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.0, left: 64.0),
                                    child: Text(
                                      'Your order is being delivered by',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                if (controller
                                        .selectedOrder.value.orderStatus ==
                                    OrderStatus.accepted)
                                  buildDeliveryPersonDetail(),
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
                                  calculateStoreDeliveryFee:
                                      controller.calculateStoreDeliveryFee,
                                  storeNameById: controller.storeNameById,
                                  calculateTotalQuantityOfProductsFromStore:
                                      controller
                                          .calculateTotalQuantityOfProductsFromSpecificStore,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 24.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Order Type: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(controller.selectedOrder.value
                                          .orderType!.nameDisplay),
                                    ],
                                  ),
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
                                  serviceCharge: serviceCharge.toDouble(),
                                  grandTotal: controller
                                      .selectedOrder.value.totalPrice!,
                                  serviceChargeInfo: null,
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
                                  ),
                                if (controller
                                            .selectedOrder.value.orderStatus ==
                                        OrderStatus.ready &&
                                    cartController.isOrderFromNonDeliveryOnly(
                                        controller.selectedOrder.value))
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                                title: 'Got my order',
                                                middleText:
                                                    'Are you sure you got your order from ${controller.selectedOrder.value.stores![0].storeName}? You are acknowledging that you have received your order.',
                                                onConfirm: () {
                                                  controller.orderReceipt();
                                                  Get.back();
                                                  Get.snackbar(
                                                      'Order Confirmed',
                                                      'Your order has been confirmed successfully.',
                                                      backgroundColor:
                                                          Colors.green,
                                                      colorText: Colors.white);
                                                },
                                                textCancel: 'No',
                                                textConfirm:
                                                    'Yes, I have my order',
                                                confirmTextColor: Colors.white,
                                                buttonColor: maincolor);
                                          },
                                          child: const Text(
                                            'Got my order',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ),
                                if (controller
                                            .selectedOrder.value.orderStatus ==
                                        OrderStatus.active &&
                                    !cartController.isOrderFromNonDeliveryOnly(
                                        controller.selectedOrder.value))
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: "Cancel Order",
                                              middleText:
                                                  "Are you sure you want to cancel this order? Once canceled, the order will not be shown to any delivery personnel.",
                                              textCancel: "No",
                                              textConfirm: "Yes, Cancel",
                                              confirmTextColor: Colors.white,
                                              buttonColor: Colors.red,
                                              // onCancel: () {
                                              //   // If the user presses "No", simply close the dialog
                                              //   // Get.back();
                                              // },
                                              onConfirm: () {
                                                Get.back();
                                                Get.defaultDialog(
                                                  title: 'Refund',
                                                  content: Column(
                                                    children: [
                                                      const Text(
                                                        "Where do you want your refund to go?",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Row(children: [
                                                        //radio button between refund to wallet or account using controller.toWallet.value
                                                        Obx(() => Radio(
                                                              value: true,
                                                              groupValue:
                                                                  controller
                                                                      .toWallet
                                                                      .value,
                                                              onChanged:
                                                                  (value) {
                                                                controller
                                                                        .toWallet
                                                                        .value =
                                                                    true;
                                                              },
                                                            )),
                                                        const Expanded(
                                                          child: Text(
                                                            "Refund to wallet",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Obx(() => Radio(
                                                              value: false,
                                                              groupValue:
                                                                  controller
                                                                      .toWallet
                                                                      .value,
                                                              onChanged:
                                                                  (value) {
                                                                controller
                                                                        .toWallet
                                                                        .value =
                                                                    false;
                                                              },
                                                            )),
                                                        const Expanded(
                                                          child: Text(
                                                            "Refund to account",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10),
                                                          ),
                                                        )
                                                      ]),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              controller
                                                                  .orderCancel();
                                                              Get.snackbar(
                                                                  'Order Canceled',
                                                                  'Your order has been canceled successfully.',
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  colorText:
                                                                      Colors
                                                                          .white);
                                                            },
                                                            child: const Text(
                                                              'Confirm',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text(
                                            'Cancel order',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Payment Details Tab
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: controller.selectedOrder.value.orderStatus ==
                                    OrderStatus.inactive
                                ? _buildInactivePaymentSection(controller)
                                : _buildVerifiedPaymentSection(controller),
                          ),
                        ],
                      );
      }),
    );
  }

  Padding buildDeliveryPersonDetail() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 8, top: 16, bottom: 16),
      child: Row(
        children: [
          Column(
            children: [
              cachedNetworkImageWrapper(
                imageUrl: controller.selectedOrder.value.deliveryPerson!.image!,
                imageBuilder: (context, imageProvider) => Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: maincolor,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      controller.selectedOrder.value.deliveryPerson!.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholderBuilder: (context, path) => Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Loading(
                      size: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ),
                ),
                errorWidgetBuilder: (context, path, object) => Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: maincolor,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${controller.selectedOrder.value.deliveryPerson!.name!}, ${controller.selectedOrder.value.deliveryPerson!.gender!}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _makePhoneCall(
                        controller.selectedOrder.value.deliveryPerson!.phone!);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        EneftyIcons.call_bold,
                        color: maincolor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        controller.selectedOrder.value.deliveryPerson!.phone!,
                        style: TextStyle(color: maincolor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                          title: 'Got my order',
                          middleText:
                              'Are you sure you got your order from ${controller.selectedOrder.value.deliveryPerson!.name!}? You are acknowledging that you have received your order.',
                          onConfirm: () {
                            controller.orderReceipt();
                            Get.back();
                            Get.snackbar('Order Confirmed',
                                'Your order has been confirmed successfully.',
                                backgroundColor: Colors.green,
                                colorText: Colors.white);
                          },
                          textCancel: 'No',
                          textConfirm: 'Yes, I have my order',
                          confirmTextColor: Colors.white,
                          buttonColor: maincolor);
                    },
                    child: const Text(
                      'Got my order',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactivePaymentSection(OrderDetailController controller) {
    // final controller = Get.find<OrderDetailController>();

    bool isWalletEnough = UserController.walletBalance.value >=
        controller.selectedOrder.value.totalPrice!;
    var paymentMethodFromOrder = controller.selectedOrder.value.payment;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(Get.context!).size.width * 0.5,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: maincolor),
              ),
              child: Center(
                child: DropdownButton<PaymentMethod>(
                  items: PaymentMethod.values
                      .where((e) =>
                          e != PaymentMethod.none &&
                          (isWalletEnough ? true : e != PaymentMethod.wallet))
                      .map((e) => DropdownMenuItem<PaymentMethod>(
                          value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (paymentMethod) {
                    controller.selectedPaymentMethod[
                        controller.selectedOrder.value.id!] = paymentMethod!;
                  },
                  value: controller.selectedPaymentMethod[
                                  controller.selectedOrder.value.id!] ==
                              PaymentMethod.none &&
                          controller.selectedPaymentMethod[
                                  controller.selectedOrder.value.id!] !=
                              null
                      ? null
                      : controller.selectedPaymentMethod[
                          controller.selectedOrder.value.id!],
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
                ),
              ),
            ),
          ),
          // const SizedBox(height: 20),
          Center(
              child: controller.selectedPaymentMethod[
                              controller.selectedOrder.value.id!] !=
                          PaymentMethod.none &&
                      controller.selectedPaymentMethod[
                              controller.selectedOrder.value.id!] !=
                          null
                  ? controller
                      .selectedPaymentMethod[controller.selectedOrder.value.id!]
                      ?.cover
                  : paymentMethodFromOrder!.cover),
          const SizedBox(height: 20),
          if (controller
                  .selectedPaymentMethod[controller.selectedOrder.value.id!] !=
              PaymentMethod.wallet)
            Column(
              children: [
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
                          Obx(
                            () => Text(
                              controller.selectedPaymentMethod[
                                          controller.selectedOrder.value.id!] ==
                                      PaymentMethod.cbe
                                  ? controller.accountNameCBE.value == ''
                                      ? 'Amanuel Wonde'
                                      : controller.accountNameCBE.value
                                  : controller.selectedPaymentMethod[controller
                                              .selectedOrder.value.id!] ==
                                          PaymentMethod.teleBirr
                                      ? controller.accountNameTel.value == ''
                                          ? 'Amanuel Wonde'
                                          : controller.accountNameTel.value
                                      : controller.accountNameCBE.value == ''
                                          ? 'Amanuel Wonde'
                                          : controller.accountNameCBE.value,
                              style: TextStyle(
                                  color: maincolor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
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
                                controller.selectedPaymentMethod[controller.selectedOrder.value.id!] !=
                                            PaymentMethod.none &&
                                        controller.selectedPaymentMethod[controller.selectedOrder.value.id!] !=
                                            null
                                    ? controller.selectedPaymentMethod[controller
                                                .selectedOrder.value.id!]! ==
                                            PaymentMethod.cbe
                                        ? controller.accountNumberCBE.value ==
                                                ''
                                            ? controller
                                                .selectedPaymentMethod[controller
                                                    .selectedOrder.value.id!]!
                                                .accountNumber
                                            : controller.accountNumberCBE.value
                                        : controller.selectedPaymentMethod[
                                                    controller.selectedOrder
                                                        .value.id!]! ==
                                                PaymentMethod.teleBirr
                                            ? controller.accountNumberTel.value == ''
                                                ? controller.selectedPaymentMethod[controller.selectedOrder.value.id!]!.accountNumber
                                                : controller.accountNumberTel.value
                                            : controller.accountNumberCBE.value == ''
                                                ? controller.selectedPaymentMethod[controller.selectedOrder.value.id!]!.accountNumber
                                                : controller.accountNumberCBE.value
                                    : paymentMethodFromOrder == PaymentMethod.cbe
                                        ? controller.accountNumberCBE.value == ''
                                            ? paymentMethodFromOrder!.accountNumber
                                            : controller.accountNumberCBE.value
                                        : paymentMethodFromOrder == PaymentMethod.teleBirr
                                            ? controller.accountNumberTel.value == ''
                                                ? paymentMethodFromOrder!.accountNumber
                                                : controller.accountNumberTel.value
                                            : controller.accountNumberCBE.value == ''
                                                ? paymentMethodFromOrder!.accountNumber
                                                : controller.accountNumberCBE.value,
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
                                    text: controller.selectedPaymentMethod[
                                                    controller.selectedOrder
                                                        .value.id!] !=
                                                PaymentMethod.none &&
                                            controller.selectedPaymentMethod[
                                                    controller.selectedOrder
                                                        .value.id!] !=
                                                null
                                        ? controller
                                            .selectedPaymentMethod[controller
                                                .selectedOrder.value.id!]!
                                            .accountNumber
                                        : paymentMethodFromOrder!.accountNumber,
                                  )).then((_) {
                                    Get.snackbar(
                                        'Copied', 'Copied to clipboard',
                                        snackPosition: SnackPosition.BOTTOM);
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
                const Text(
                  'Please make a payment to the account listed above and paste the transaction/reference ID below\n\n⚠️NOTE: Please make sure you are using a SIM issued by Ethio Telecom for this operation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
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
                      if ((controller.selectedPaymentMethod[controller.selectedOrder.value.id!] !=
                                      PaymentMethod.none &&
                                  controller.selectedPaymentMethod[controller.selectedOrder.value.id!] !=
                                      null
                              ? controller.selectedPaymentMethod[
                                  controller.selectedOrder.value.id!]!
                              : paymentMethodFromOrder!) ==
                          PaymentMethod.cbe) {
                        if (!value!
                            .startsWith('https://apps.cbe.com.et:100/?id=')) {
                          return 'Please enter a valid CBE receipt link';
                        }
                      } else if ((controller.selectedPaymentMethod[
                                          controller.selectedOrder.value.id!] !=
                                      PaymentMethod.none &&
                                  controller.selectedPaymentMethod[
                                          controller.selectedOrder.value.id!] !=
                                      null
                              ? controller.selectedPaymentMethod[controller.selectedOrder.value.id!]!
                              : paymentMethodFromOrder!) ==
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
                              color: maincolor, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: controller.selectedPaymentMethod[
                                          controller.selectedOrder.value.id!] !=
                                      PaymentMethod.none &&
                                  controller.selectedPaymentMethod[
                                          controller.selectedOrder.value.id!] !=
                                      null
                              ? controller
                                  .selectedPaymentMethod[
                                      controller.selectedOrder.value.id!]!
                                  .sampleLink
                              : paymentMethodFromOrder!.sampleLink,
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ])),
                ),
                const SizedBox(height: 10),
              ],
            ),
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
                      onPressed: controller.selectedPaymentMethod[
                                  controller.selectedOrder.value.id!] ==
                              PaymentMethod.wallet
                          ? () => controller.verifyPayment()
                          : controller.transactionId.value != ''
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

  Widget _buildVerifiedPaymentSection(OrderDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: controller.selectedOrder.value.payment!.cover),
        if (controller.selectedOrder.value.payment! != PaymentMethod.wallet)
          Column(
            children: [
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
                      style: TextStyle(
                          color: maincolor, fontWeight: FontWeight.w600),
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
                      style: TextStyle(
                          color: maincolor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
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
