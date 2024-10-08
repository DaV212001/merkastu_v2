import 'package:badges/badges.dart' as badges;
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/screens/favorites/favorites_screen.dart';
import 'package:merkastu_v2/screens/home/store_list_screen.dart';
import 'package:merkastu_v2/screens/order/cart_screen.dart';
import 'package:merkastu_v2/screens/order/order_history_screen.dart';
import 'package:merkastu_v2/screens/settings/settings_srceen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../constants/pages.dart';
import '../controllers/home_controller.dart';
import '../controllers/theme_mode_controller.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  var homeController = Get.put(HomeController(), tag: 'home');
  List<Widget> _buildScreens() {
    return [
      StoreListScreen(),
      const FavoritesScreen(),
      CartScreen(),
      const OrderHistoryScreen(),
      const SettingsSrceen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color activeColor =
        ThemeModeController.isCurrentlyLight() ? maincolor : Colors.white;
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
                    homeController.itemsInCart.value.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
            showBadge: homeController.itemsInCart.value > 0,
            child: Icon(
              EneftyIcons.shopping_cart_bold,
              color: secondarycolor,
              size: 35,
            ),
          ),
        )),
        inactiveIcon: Center(
            child: Obx(() => badges.Badge(
                  badgeContent: Obx(() => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          homeController.itemsInCart.value.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                  showBadge: homeController.itemsInCart.value > 0,
                  child: Icon(
                    EneftyIcons.shopping_cart_outline,
                    color: secondarycolor,
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

  int selectedIndex = 0;

  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      bottomScreenMargin: 70,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Theme.of(context).cardColor,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        colorBehindNavBar: Theme.of(context).cardColor,
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
