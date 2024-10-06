import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/dio_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../config/storage_config.dart';
import '../constants/pages.dart';
import '../models/user.dart';
import '../utils/error_utils.dart';

enum VerificationStatus { notVerified, verified, pending }

class SignUpController extends GetxController {
  // Form fields
  var email = ''.obs;
  var password = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var phone = ''.obs;
  var block = ''.obs;
  var room = ''.obs;

  // Form key to validate the form
  final formKey = GlobalKey<FormState>();

  // Loading state
  var isLoading = false.obs;

  // Tab controller
  late TabController tabController;

  // Initialize the tab controller with 3 tabs
  void setTabController(TickerProvider vsync) {
    tabController = TabController(length: 3, vsync: vsync);
  }

  var token = ''.obs;
  var verificationStatus = VerificationStatus.pending.obs;
  // Function to perform the sign-up action
  Future<void> signUp() async {
    isLoading.value = true;
    Map<String, dynamic> data = {
      "botToken": token.value,
      "phoneNumber": phone.value,
      "blockNumber": block.value,
      "roomNumber": room.value,
      "email": email.value,
      "password": password.value
    };
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get(
        '/user/auth/sign-up',
        options: dio.Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: jsonEncode(data),
      );
      Logger().d(response.data);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data['status'] == true) {
        Get.snackbar('Success', 'Sign-up completed!');
        // Get.toNamed(Routes.phoneVerifyRoute);
      } else {
        throw Exception(response.data);
      }
      isLoading.value = false;
    } catch (e, stack) {
      Logger().t(e, stackTrace: stack);
      String errorString = (await ErrorUtil.getErrorData(e.toString())).body;
      if (errorString.startsWith('custom')) {
        errorString = errorString.replaceFirst('custom', '');
      }
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.none) {
        errorString = 'No internet connection';
      }
      if (e is FormatException) {
        errorString = 'Unexpected error occured, please try again';
      }
      Get.snackbar('Error', errorString);
      isLoading.value = false;
    }
  }

  // New method to check phone verification status
  Future<void> checkPhoneVerification() async {
    try {
      dio.Response response = await DioConfig.dio().post(
        '/user/auth/check-phone-verification',
        options: dio.Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: jsonEncode({"phoneNumber": phone.value}),
      );
      Logger().d(response.data);

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data['data'];

        if (data['token'] != null) {
          // User is verified
          var userContrller = Get.find<UserController>();
          userContrller.isLoggedIn.value = true;
          verificationStatus.value = VerificationStatus.verified;
          ConfigPreference.setUserToken(data['token']);
          Get.offAllNamed(Routes.initialRoute);
        } else if (data['status'] == 'pending') {
          // Verification is pending, no action needed
          verificationStatus.value = VerificationStatus.pending;
        } else if (data['status'] == 'not verified') {
          // Verification failed
          verificationStatus.value = VerificationStatus.notVerified;
          Get.snackbar('Error', 'Verification failed, please try again',
              backgroundColor: Colors.red);
          Get.back();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error occurred while verifying',
          backgroundColor: Colors.red);
    }
  }

  void launchTelegram() async {
    token.value = const Uuid().v4();
    String url = 'https://t.me/merkastubot?start=${token.value}';
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  // Function to validate fields in individual tabs before navigating to the next tab
  bool validateFieldsForTab(int index) {
    switch (index) {
      case 0:
        if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty) {
          Get.snackbar('Error', 'Please fill in all fields',
              backgroundColor: Colors.red);
          return false;
        }
        break;
      case 1:
        if (block.isEmpty || room.isEmpty) {
          Get.snackbar('Error', 'Please fill in all fields',
              backgroundColor: Colors.red);
          return false;
        }
        break;
      default:
        break;
    }
    return true;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class LoginController extends GetxController {
  // Email and Password fields as observable variables
  var email = ''.obs;
  var password = ''.obs;

  // Loading state
  var isLoading = false.obs;

  // Form key to validate the form
  final formKey = GlobalKey<FormState>();

  // Function to perform login action
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simulate a login process (you should replace this with actual login API call)
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      // If login is successful
      Get.snackbar('Success', 'Logged in successfully!',
          backgroundColor: Colors.green);
      // Navigate to home screen or the relevant screen
      Get.toNamed('/home');
    } else {
      Get.snackbar('Error', 'Please fill in all fields correctly',
          backgroundColor: Colors.red);
    }
  }

  // Dispose of controllers when not in use
  @override
  void onClose() {
    super.onClose();
  }
}

class UserController extends GetxController {
  var user = User().obs;
  var isLoggedIn = false.obs;
}
