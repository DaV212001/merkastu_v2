import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/constants.dart';

import '../../controllers/home_controller.dart';
import '../../utils/payment_methods.dart';

class PaymentMethodSelection extends StatefulWidget {
  final Function(PaymentMethod) onMethodSelected;
  final bool walletInsufficient;

  const PaymentMethodSelection({
    super.key,
    required this.onMethodSelected,
    required this.walletInsufficient,
  });

  @override
  _PaymentMethodSelectionState createState() => _PaymentMethodSelectionState();
}

class _PaymentMethodSelectionState extends State<PaymentMethodSelection> {
  final HomeController homeController = Get.find<HomeController>(tag: 'home');
  PaymentMethod _selectedMethod = PaymentMethod.none;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PaymentMethod.values
          .where((method) => method != PaymentMethod.none)
          .map((method) {
        bool isWalletMethod = method == PaymentMethod.wallet;
        bool isWalletDisabled = isWalletMethod && widget.walletInsufficient;

        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                  color: isWalletDisabled
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.grey,
                  width: 2),
            ),
            leading: Radio<PaymentMethod>(
              value: method,
              groupValue: homeController.selectedPaymentPlan.value,
              onChanged: (PaymentMethod? value) {
                if (isWalletDisabled) {
                  Get.snackbar('Error',
                      'Your wallet balance is insufficient. Please top up to use this payment method.');
                } else {
                  // Update the selected method if not disabled
                  setState(() {
                    _selectedMethod = value!;
                  });
                  // Execute the provided callback function
                  widget.onMethodSelected(value!);
                }
              },
              // Disable the wallet option if wallet is insufficient
              activeColor: isWalletDisabled ? Colors.grey : maincolor,
              visualDensity: VisualDensity.compact,
            ),
            title: Text(
              method.name,
              style: TextStyle(
                fontSize: 16,
                color: isWalletDisabled ? Colors.grey : Colors.black,
              ),
            ),
            trailing: isWalletDisabled
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      EneftyIcons.wallet_2_bold,
                      color: Colors.grey,
                      size: 40,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: method.icon,
                  ),
          ),
        );
      }).toList(),
    );
  }
}
