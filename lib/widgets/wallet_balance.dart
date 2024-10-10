import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/auth_controller.dart';
import 'loading.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: maincolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => UserController.loadingBalance.value
                  ? const SizedBox(
                      height: 50,
                      width: 50,
                      child: Loading(
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                  : Row(
                      children: [
                        const Icon(
                          EneftyIcons.wallet_2_bold,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          UserController.walletBallance.value
                              .toStringAsFixed(2),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
            ),
          )),
    );
  }
}
