import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class PriceSummary extends StatelessWidget {
  const PriceSummary({
    super.key,
    required this.subTotalPrice,
    required this.deliveryCharge,
    required this.serviceCharge,
    required this.grandTotal,
  });

  final double subTotalPrice;
  final double deliveryCharge;
  final double serviceCharge;
  final double grandTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 32.0, right: 16.0, top: 16.0, bottom: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Subtotal:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              "${subTotalPrice.toStringAsFixed(2)} Birr",
              style: TextStyle(color: maincolor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total delivery charge:"),
            Text(
              '${deliveryCharge.toStringAsFixed(2)} Birr',
              style: TextStyle(color: maincolor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text("Service Charge:"),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Service Charge Info"),
                            content: const Text(
                              "The service charge is 15% of the subtotal + delivery charges.",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.info_outline,
                      color: maincolor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "${serviceCharge.toStringAsFixed(2)} Birr",
              style: TextStyle(color: maincolor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total: ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              "${grandTotal.roundToDouble().toStringAsFixed(2)} Birr",
              style: TextStyle(
                  color: maincolor, fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ]),
    );
  }
}
