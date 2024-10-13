import 'package:badges/badges.dart' as badges;
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:merkastu_v2/controllers/theme_mode_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../constants/constants.dart';
import '../constants/pages.dart';
import 'auth_controller.dart';
import 'home_controller.dart';

class MainLayoutController extends GetxController {
  late PersistentTabController controller;
  @override
  void onInit() {
    UserController.getLoggedInUser();
    controller = PersistentTabController();
    super.onInit();
  }

  final _homeController = Get.put(HomeController(), tag: 'home');
  List<PersistentBottomNavBarItem> navBarsItems() {
    Color activeColor = maincolor;
    Color? inactiveColor = ThemeModeController.isCurrentlyLight()
        ? Colors.black
        : Colors.white.withOpacity(0.4);
    double size = 25;
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          EneftyIcons.home_2_bold,
          color: activeColor,
          size: 35,
        ),
        inactiveIcon: Icon(
          HugeIcons.strokeRoundedHome01,
          color: inactiveColor,
          size: size,
        ),
        // title: ('Window'),
        // textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          EneftyIcons.heart_bold,
          color: activeColor,
          size: 35,
        ),
        inactiveIcon: Icon(
          EneftyIcons.heart_outline,
          color: inactiveColor,
          size: size,
        ),
        // title: ('Window'),
        // textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        onPressed: (context) {
          Get.toNamed(Routes.cartRoute);
        },
        icon: Center(
            child: Obx(
          () => badges.Badge(
            badgeContent: Obx(() => Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    _homeController.itemsInCart.value.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
            showBadge: _homeController.itemsInCart.value > 0,
            child: const Icon(
              EneftyIcons.shopping_cart_bold,
              color: Colors.white,
              size: 35,
            ),
          ),
        )),
        inactiveIcon: Center(
            child: Obx(() => badges.Badge(
                  badgeContent: Obx(() => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          _homeController.itemsInCart.value.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                  showBadge: _homeController.itemsInCart.value > 0,
                  child: const Icon(
                    EneftyIcons.shopping_cart_outline,
                    color: Colors.white,
                    size: 35,
                  ),
                ))),
        // title: ('Chats'),
        // textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          EneftyIcons.note_2_bold,
          color: activeColor,
          size: 35,
        ),
        inactiveIcon: Icon(
          EneftyIcons.note_2_outline,
          color: inactiveColor,
          size: size,
        ),
        // title: ('Matches'),
        // textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          EneftyIcons.setting_2_bold,
          color: activeColor,
          size: 35,
        ),
        inactiveIcon: Icon(
          EneftyIcons.setting_2_outline,
          color: inactiveColor,
          size: size,
        ),
        // title: ('Settings'),
        // textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
    ];
  }
}
