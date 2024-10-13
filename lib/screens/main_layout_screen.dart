import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/main_layout_controller.dart';
import 'package:merkastu_v2/screens/auth/login_prompter.dart';
import 'package:merkastu_v2/screens/favorites/favorites_screen.dart';
import 'package:merkastu_v2/screens/home/store_list_screen.dart';
import 'package:merkastu_v2/screens/order/cart_screen.dart';
import 'package:merkastu_v2/screens/order/order_history_screen.dart';
import 'package:merkastu_v2/screens/settings/settings_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MainLayoutScreen extends StatelessWidget {
  MainLayoutScreen({super.key});

  final mainLayoutController = Get.put(MainLayoutController(), tag: 'main');

  List<Widget> _buildScreens() {
    return [
      StoreListScreen(),
      Obx(() => UserController.isLoggedIn.value
          ? FavoritesScreen()
          : const LoginPrompter()),
      CartScreen(),
      Obx(() => UserController.isLoggedIn.value
          ? OrderHistoryScreen()
          : const LoginPrompter()),
      Obx(() => UserController.isLoggedIn.value
          ? SettingsScreen()
          : const LoginPrompter()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      controller: mainLayoutController.controller,
      screens: _buildScreens(),
      items: mainLayoutController.navBarsItems(),
      confineToSafeArea: true,
      margin: const EdgeInsets.all(10),
      backgroundColor: Theme.of(context).cardColor,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(40),
        // const BorderRadius.only(
        //     topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        colorBehindNavBar: Colors.transparent,
      ),
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
      navBarHeight: 50.h,
      navBarStyle: NavBarStyle.style15,
    );
  }
}
