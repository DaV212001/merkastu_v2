import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/order/payment_method_selection.dart';
import '../../../constants/constants.dart';
import '../../../controllers/wallet_controller.dart';
import '../../../utils/payment_methods.dart';
import '../../../widgets/animated_widgets/loading_animated_button.dart';
import '../../../widgets/input_feilds/custom_input_field.dart';

class WithdrawalRequestScreen extends StatelessWidget {
  WithdrawalRequestScreen({super.key, this.fromCancel});
  final bool? fromCancel;
  final controller = Get.find<WalletController>(tag: 'wallet');
  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Request'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    inputController: TextEditingController(
                        text: controller.amountToWithdraw.value),
                    enabeled: fromCancel == true ? false : true,
                    hintText: 'Enter the withdrawal amount ',
                    onChanged: (value) =>
                        controller.amountToWithdraw.value = value),
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
                  controller.withdrawalPaymentMethod.value = method;
                },
                walletInsufficient: true,
                fromFill: true,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text(
                'Enter Account',
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
                child: Obx(
                  () => CustomInputField(
                    inputController: accountNumberController,
                    hintText:
                        'Enter the account to withdraw to ${controller.withdrawalPaymentMethod.value == PaymentMethod.cbe ? '(1000xxxxxxxxx)' : controller.withdrawalPaymentMethod.value == PaymentMethod.teleBirr ? '(09xxxxxxxx)' : ''}',
                    onChanged: (value) =>
                        controller.withdrawalAccountNumber.value = value,
                    validator: (val) {
                      if (controller.withdrawalPaymentMethod.value ==
                          PaymentMethod.none) {
                        return 'Please select a payment method';
                      } else if (controller.withdrawalPaymentMethod.value ==
                          PaymentMethod.cbe) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter your CBE account number';
                        }
                        if (!val.startsWith('1000')) {
                          return 'Please enter a valid CBE account number. (Must start with 1000)';
                        }
                        if (val.length != 13) {
                          return 'Please enter a valid CBE account number. (Must be 13 digits)';
                        }
                      } else if (controller.withdrawalPaymentMethod.value ==
                          PaymentMethod.teleBirr) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter your Telebirr account number';
                        }
                        if (!val.startsWith('09')) {
                          return 'Please enter a valid Telebirr account number. (Must start with 09)';
                        }
                        if (val.length != 10) {
                          return 'Please enter a valid Telebirr account number. (Must be 10 digits)';
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: Obx(
                  () => controller.requestingWithdrawal.value
                      ? SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: LoadingAnimatedButton(
                            onTap: () {},
                            color: maincolor,
                            child: Text(
                              'Request Withdrawal',
                              style: TextStyle(
                                  color: maincolor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: controller.amountToWithdraw.value == '' ||
                                  controller.withdrawalAccountNumber.value ==
                                      '' ||
                                  controller.withdrawalPaymentMethod.value ==
                                      PaymentMethod.none
                              ? null
                              : () => controller.requestWithdrawal(),
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                            disabledForegroundColor: Colors.grey,
                          ),
                          child: const Text(
                            'Request Withdrawal',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
