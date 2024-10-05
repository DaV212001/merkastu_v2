import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/pages.dart';

class Merkastu extends StatelessWidget {
  const Merkastu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX Navigation',
      debugShowCheckedModeBanner: false,

      // Set the initial route
      initialRoute: '/home',

      // Define the routes using GetPage
      getPages: Pages.pages,
    );
  }
}
