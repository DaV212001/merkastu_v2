import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Function to perform the sign-up action
  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simulate a network call (replace this with actual API call)
      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      // If sign-up is successful
      Get.snackbar('Success', 'Sign-up completed!',
          backgroundColor: Colors.green);
      Get.toNamed('/home');
    } else {
      Get.snackbar('Error', 'Please fill all fields correctly',
          backgroundColor: Colors.red);
    }
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

class UserController extends GetxController {}
