import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/constants.dart';

import '../../controllers/auth_controller.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  PhoneVerificationScreenState createState() => PhoneVerificationScreenState();
}

class PhoneVerificationScreenState extends State<PhoneVerificationScreen>
    with WidgetsBindingObserver {
  final SignUpController signUpController = Get.find<SignUpController>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // // Start polling for verification status every 2 seconds
    // _startVerificationPolling();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Recheck verification when app comes to the foreground
      signUpController.checkPhoneVerification();
    }
  }

  // void _startVerificationPolling() {
  //   _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
  //     signUpController.checkPhoneVerification();
  //   });
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset('assets/images/phone_verify.svg'),
                ),
              ),
              const Text(
                'To verify your phone number, please head over to our Telegram bot by tapping on the button below.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUpController.launchTelegram,
                    child: Text(
                      "Launch Telegram",
                      style: TextStyle(color: secondarycolor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
