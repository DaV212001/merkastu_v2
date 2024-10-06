import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/controllers/theme_mode_controller.dart';

import 'constants/pages.dart';
import 'controllers/auth_controller.dart';

class Merkastu extends StatelessWidget {
  const Merkastu({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeModeController(context));
    Get.put(UserController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeModeController.getThemeMode(),
      // Set the initial route
      initialRoute: '/home',
      // Define the routes using GetPage
      getPages: Pages.pages,
    );
  }
}
