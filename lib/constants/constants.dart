import 'dart:io';

import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

import '../controllers/theme_mode_controller.dart';

String kApiBaseUrl = 'https://merkastu.endevour.org';
String kStoreImageBaseUrl = '$kApiBaseUrl/public/store-images/';
String kProductImagebaseUrl = '$kApiBaseUrl/public/product-images/';
String kDeliveryPersonProfileImageBaseUrl =
    '$kApiBaseUrl/public/delivery-person-images/';

final client = HttpClient();
const retryOptions = RetryOptions(
    maxDelay: Duration(milliseconds: 300),
    delayFactor: Duration(seconds: 0),
    maxAttempts: 3);
const timeOut = Duration(seconds: 15);

String imageBaseUrl = 'https://merkastuapi.endevour.org/public/store-images';
RegExp phoneNumberRegex = RegExp(r'^(09|07)\d{8}$');
RegExp usernameRegex = RegExp(r'^(?!_+$)[a-zA-Z0-9_]+$');
RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
String personAvatar =
    'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_man_people_person_avatar_white_tone_icon_159363.png';
String imageLoader = 'assets/images/loading.gif';
String apartmentImage =
    'https://images.pexels.com/photos/323705/pexels-photo-323705.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
Color maincolor = const Color(0xFF039D55);
Color secondarycolor = const Color(0xFF062945);
Color maincolorLightTint = const Color(0xFFBDECD6);
List<BoxShadow> kCardShadow() {
  return [
    BoxShadow(
      color: ThemeModeController.isLightTheme.value
          ? Colors.grey.withOpacity(0.3)
          : Colors.black38,
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ];
}
