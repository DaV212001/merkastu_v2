import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/screens/auth/sign_up_screen.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/animated_widgets/loading_animated_button.dart';
import '../../widgets/input_feilds/password_input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize and bind the controller
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 40,
        elevation: 0,
        title: const Center(
          child: Text('Login',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 50.0, bottom: 60.0, right: 40, left: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset('assets/images/login.svg'),
              ),

              Form(
                key: loginController.formKey,
                child: Column(
                  children: [
                    PhoneNumberInput(
                      textEditingController: TextEditingController(
                          text: loginController.phone.value),
                      onChanged: (val) {
                        loginController.phone.value =
                            val; // Update email in controller
                      },
                    ),
                    PasswordInput(
                      textEditingController: TextEditingController(
                          text: loginController.password
                              .value), // Not needed if using form fields in controller
                      hintText: 'Enter your password',
                      onChanged: (val) {
                        loginController.password.value =
                            val; // Update password in controller
                      },
                    ),
                  ],
                ),
              ),
              // Use Obx to listen to loading state
              Obx(() {
                return loginController.isLoading.value
                    ? Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: LoadingAnimatedButton(
                          color: maincolor,
                          width: double.infinity,
                          onTap: () {},
                          child: Text(
                            "Logging in...",
                            style: TextStyle(
                                color: maincolor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                  colors: [maincolor, maincolor]),
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: WidgetStateProperty.all(0),
                                alignment: Alignment.center,
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.only(
                                      right: 75, left: 75, top: 15, bottom: 15),
                                ),
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                              onPressed: () async {
                                await loginController
                                    .login(); // Call the login function
                              },
                              child: const Text("Login",
                                  style: TextStyle(
                                      color: Color(0xffffffff), fontSize: 16)),
                            ),
                          ),
                        ),
                      );
              }),
              const SizedBox(height: 16.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAndToNamed(
                            Routes.signupRoute); // Use Get for navigation
                      },
                      child: Text(
                        " Sign Up",
                        style: TextStyle(
                            color: maincolor,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
