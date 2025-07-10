import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../components/order/payment_method_selection.dart';
import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/error_data.dart';
import '../../../utils/payment_methods.dart';
import '../../../widgets/animated_widgets/loading_animated_button.dart';
import '../../../widgets/cards/error_card.dart';
import '../../../widgets/input_feilds/custom_input_field.dart';

class FillWalletScreen extends StatelessWidget {
  FillWalletScreen({super.key});
  final controller = Get.put(UserController());
  final TextEditingController amountController = TextEditingController();
  final TextEditingController transactionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill wallet'),
      ),
      body: Column(
        children: [
          TabBar(controller: controller.tabController, tabs: const [
            Tab(child: Text('Transaction Details')),
            Tab(child: Text('Payment')),
          ]),
          Expanded(
            child: TabBarView(controller: controller.tabController, children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text(
                            'Enter Amount',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                          child: SizedBox(
                            height: 45,
                            child: CustomInputField(
                                inputController: amountController,
                                hintText: 'Enter the fill amount ',
                                onChanged: (value) =>
                                    UserController.amount.value = value),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text(
                            'Select payment method',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: PaymentMethodSelection(
                            onMethodSelected: (method) {
                              UserController.selectedPaymentMethod.value =
                                  method;
                            },
                            walletInsufficient: true,
                            fromFill: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Obx(() => ElevatedButton(
                                onPressed: UserController.amount.value == '' ||
                                        UserController
                                                .selectedPaymentMethod.value ==
                                            PaymentMethod.none
                                    ? null
                                    : () =>
                                        controller.tabController.animateTo(1),
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: Colors.grey,
                                  disabledForegroundColor: Colors.grey,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Make your payment',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
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
                                ))),
                          ),
                        )
                      ]),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => UserController.selectedPaymentMethod.value ==
                                  PaymentMethod.none ||
                              UserController.amount.value == ''
                          ? Center(
                              child: ErrorCard(
                                errorData: ErrorData(
                                    title: 'No payment method',
                                    body:
                                        'Please select a payment method and come back.',
                                    buttonText: 'Go back',
                                    image: Assets.errorsNotVerified),
                                refresh: () =>
                                    controller.tabController.animateTo(0),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                UserController
                                    .selectedPaymentMethod.value.cover,
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
                                          Row(
                                            children: [
                                              Text(
                                                UserController
                                                    .selectedPaymentMethod
                                                    .value
                                                    .accountNumber,
                                                style: TextStyle(
                                                    color: maincolor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                    text: UserController
                                                        .selectedPaymentMethod
                                                        .value
                                                        .accountNumber,
                                                  )).then((_) {
                                                    Get.snackbar('Copied',
                                                        'Copied to clipboard',
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM);
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
                                        inputController: transactionController,
                                        label: 'Transaction ID',
                                        hintText:
                                            'Enter your transaction/reference ID',
                                        onChanged: (value) {
                                          print(value);
                                          UserController.transactionId.value =
                                              value;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Obx(
                                        () => UserController.fillingWallet.value
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
                                                  onPressed: UserController
                                                              .transactionId
                                                              .value !=
                                                          ''
                                                      ? () => UserController
                                                          .fillWallet()
                                                      : null,
                                                  style: ElevatedButton.styleFrom(
                                                      disabledForegroundColor:
                                                          Colors.grey,
                                                      disabledBackgroundColor:
                                                          Colors.grey),
                                                  child: const Text(
                                                    'Fill wallet',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                ),
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
              )
            ]),
          )
        ],
      ),
    );
  }
}
