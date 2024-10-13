import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:merkastu_v2/config/dio_config.dart';
import 'package:merkastu_v2/controllers/home_controller.dart';
import 'package:merkastu_v2/utils/payment_methods.dart';
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
    token.value = const Uuid().v4();

    isLoading.value = true;
    Map<String, dynamic> data = {
      "botToken": token.value,
      "phoneNumber": '251${phone.value}',
      "blockNumber": int.parse(block.value),
      "roomNumber": int.parse(room.value),
      "firstName": firstName.value,
      "lastName": lastName.value,
      "password": int.parse(password.value)
    };
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    Logger().d(data);
    try {
      response = await DioConfig.dio().post(
        '/user/auth/sign-up',
        options: dio.Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: jsonEncode(data),
      );
      Logger().d(response.data);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data['status'] == true) {
        Get.offAndToNamed(Routes.phoneVerifyRoute);
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
        data: jsonEncode({"botToken": token.value}),
      );
      Logger().d(response.data);

      if (response.statusCode == 200 && response.data['status'] == true) {
        final data = response.data['data'];

        if (data['token'] != null) {
          // User is verified
          UserController.isLoggedIn.value = true;
          verificationStatus.value = VerificationStatus.verified;
          ConfigPreference.setUserToken(data['token']);
          UserController.getLoggedInUser();
          UserController.isLoggedIn.value = true;
          Get.back();
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
        if (firstName.isEmpty || lastName.isEmpty) {
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
  var phone = ''.obs;
  var password = ''.obs;

  // Loading state
  var isLoading = false.obs;

  // Form key to validate the form
  final formKey = GlobalKey<FormState>();

  // Function to perform login action
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      dio.Response response =
          dio.Response(requestOptions: dio.RequestOptions());
      Map<String, dynamic> body = {
        'phoneNumber': '251${phone.value}',
        'userPassword': password.value,
      };
      try {
        response = await DioConfig.dio()
            .post('/user/auth/sign-in', data: jsonEncode(body));
        Logger().d(response.data);
        if ((response.statusCode == 201 || response.statusCode == 200) &&
            response.data['status'] == true) {
          final data = response.data['data'];
          ConfigPreference.setUserToken(data['token']);
          UserController.getLoggedInUser();
          UserController.isLoggedIn.value = true;
          Get.back();
          Get.snackbar('Success', 'Logged in successfully');
        } else {
          throw 'custom' + response.data['message'];
        }
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
      isLoading.value = false;
      // Navigate to home screen or the relevant screen
      // Get.toNamed('/home');
    } else {
      Get.snackbar(
        'Error',
        'Please fill in all fields correctly',
      );
    }
  }

  // Dispose of controllers when not in use
  @override
  void onClose() {
    super.onClose();
  }
}

class UserController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static Rx<User> user = User().obs;
  static RxBool isLoggedIn = false.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  static getLoggedInUser() {
    User userTemp = User();
    bool status = ConfigPreference.getUserToken() != null;
    print("Logged in status = $status");
    if (status == true) {
      final accessToken = ConfigPreference.getUserToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);

      print('ACCESS TOKEN FETCH LOGGED IN USER: $accessToken');
      final user = User.fromJson(decodedToken, accessToken);
      // String blue = '\u001b[34m'; // ANSI code for blue
      // String reset = '\u001b[0m'; // Reset ANSI code
      // print('${blue} ${user.toString()} ${reset}');
      userTemp = user;
      if (Get.isRegistered<HomeController>(tag: 'home')) {
        Get.find<HomeController>(tag: 'home').block.value =
            (user.block ?? 0).toString();
        Get.find<HomeController>(tag: 'home').room.value =
            (user.room ?? 0).toString();
      }
      isLoggedIn.value = true;
      isLoggedIn.refresh();
      Logger().d('Logged in: ${isLoggedIn.value}');
      getWalletBallance();
    } else {
      isLoggedIn.value = false;
    }
    user.value = userTemp;
    user.refresh();
  }

  static var amount = ''.obs;
  static var selectedPaymentMethod = PaymentMethod.none.obs;
  static var transactionId = ''.obs;

  static var fillingWallet = false.obs;

  static fillWallet() async {
    fillingWallet.value = true;
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().post('/user/wallet/fill',
          data: {
            'amount': int.parse(amount.value),
            'paymentMethod': selectedPaymentMethod.value.name,
            'referenceId': transactionId.value
          },
          options: dio.Options(
            headers: {
              'Authorization': ConfigPreference.getUserToken(),
            },
            contentType: 'application/json',
          ));
      Logger().d(response.data);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status'] == true) {
        getWalletBallance();
        Get.back();
        amount.value = '';
        transactionId.value = '';
        selectedPaymentMethod.value = PaymentMethod.none;
        Get.snackbar('Success', 'Wallet filled successfully');
      } else {
        throw 'custom' + response.data['message'];
      }
      Logger().d(response.data);
      fillingWallet.value = false;
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
      fillingWallet.value = false;
    }
  }

  static RxDouble walletBallance = 0.00.obs;
  static var loadingBalance = false.obs;
  static getWalletBallance() async {
    loadingBalance.value = true;
    dio.Response response = dio.Response(requestOptions: dio.RequestOptions());
    try {
      response = await DioConfig.dio().get('/user/wallet/get-balance',
          options: dio.Options(
            headers: {
              'Authorization': ConfigPreference.getUserToken(),
            },
          ));
      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['status'] == true) {
        walletBallance.value =
            (response.data['data']['balance'] ?? 0).toDouble();
      } else {
        Exception(response.data['message']);
      }
      Logger().d(response.data);
      loadingBalance.value = false;
    } catch (e, stack) {
      loadingBalance.value = false;
      Logger().t(e, stackTrace: stack);
      Get.showSnackbar(const GetSnackBar(
        title: 'Error',
        message: 'Couldn\'t get wallet balance',
        duration: Duration(milliseconds: 1500),
      ));
    }
  }
}
