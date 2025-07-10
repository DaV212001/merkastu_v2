import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/controllers/theme_mode_controller.dart';

import 'config/storage_config.dart';
import 'constants/pages.dart';

class Merkastu extends StatelessWidget {
  const Merkastu({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeModeController(context));
    print('SET THEME: ${ConfigPreference.getThemeIsLight()}');
    return Obx(() => ScreenUtilInit(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeModeController.getThemeMode(),
            // Set the initial route
            initialRoute: Routes.initialRoute,
            // Define the routes using GetPage
            getPages: Pages.pages,
          ),
        ));
  }
}
