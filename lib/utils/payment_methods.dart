import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';

enum PaymentMethod { none, cbe, teleBirr, wallet }

extension PaymentMethodExtension on PaymentMethod {
  String get name {
    switch (this) {
      case PaymentMethod.none:
        return "UNPAID";
      case PaymentMethod.cbe:
        return "CBE";
      case PaymentMethod.teleBirr:
        return "TELEBIRR";
      case PaymentMethod.wallet:
        return "WALLET";
    }
  }

  String get sampleLink {
    switch (this) {
      case PaymentMethod.none:
        return "";
      case PaymentMethod.cbe:
        return "https://apps.cbe.com.et:100/?id=FT24309AYKPK99723312";
      case PaymentMethod.teleBirr:
        return "https://transactioninfo.ethiotelecom.et/receipt/BKCOD2D9E";
      case PaymentMethod.wallet:
        return "";
    }
  }

  Widget get icon {
    switch (this) {
      case PaymentMethod.none:
        return const Icon(Icons.abc);
      case PaymentMethod.cbe:
        return Image.asset(
          'assets/images/CBE.png',
          height: 40,
          width: 40,
        );
      case PaymentMethod.teleBirr:
        return Image.asset(
          'assets/images/TELEBIRR.png',
          height: 40,
          width: 40,
        );
      case PaymentMethod.wallet:
        return Icon(
          EneftyIcons.wallet_2_bold,
          size: 40,
          color: maincolor,
        );
    }
  }

  Widget get cover {
    switch (this) {
      case PaymentMethod.none:
        return const Icon(Icons.abc);
      case PaymentMethod.cbe:
        return Image.asset(
          'assets/images/CBE-cover.png',
          height: MediaQuery.of(Get.context!).size.width * 0.5,
          width: MediaQuery.of(Get.context!).size.width * 0.5,
        );
      case PaymentMethod.teleBirr:
        return Image.asset(
          'assets/images/Telebirr-cover.png',
          height: MediaQuery.of(Get.context!).size.width * 0.5,
          width: MediaQuery.of(Get.context!).size.width * 0.5,
        );
      case PaymentMethod.wallet:
        return Icon(
          EneftyIcons.wallet_2_bold,
          size: MediaQuery.of(Get.context!).size.width * 0.5,
          color: maincolor,
        );
    }
  }

  String get accountNumber {
    switch (this) {
      case PaymentMethod.cbe:
        return '1000599264969';
      case PaymentMethod.teleBirr:
        return '0967292497';
      default:
        return "";
    }
  }

  static PaymentMethod fromName(String name) {
    switch (name) {
      case "CBE":
        return PaymentMethod.cbe;
      case "TELEBIRR":
        return PaymentMethod.teleBirr;
      case "WALLET":
        return PaymentMethod.wallet;
    }
    return PaymentMethod.none;
  }
}
