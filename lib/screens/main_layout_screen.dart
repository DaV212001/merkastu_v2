import 'package:badges/badges.dart' as badges;
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:merkastu_v2/screens/favorites/favorites_screen.dart';
import 'package:merkastu_v2/screens/home/restaurant_list_screen.dart';
import 'package:merkastu_v2/screens/order/check_out_screen.dart';
import 'package:merkastu_v2/screens/order/order_history_screen.dart';
import 'package:merkastu_v2/screens/settings/settings_srceen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../controllers/theme_mode_controller.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  List<Widget> _buildScreens() {
    return [
      const RestaurantListScreen(),
      const FavoritesScreen(),
      const CheckOutScreen(),
      const OrderHistoryScreen(),
      const SettingsSrceen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color activeColor = ThemeModeController.isCurrentlyLight()
        ? const Color(0xFF3AE0C4)
        : Colors.white;
    Color? inactiveColor = ThemeModeController.isCurrentlyLight()
        ? Colors.black
        : Colors.white.withOpacity(0.4);
    double size = 25;
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          EneftyIcons.home_2_bold,
          color: activeColor,
          size: size,
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
          size: size,
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
        icon: Center(
            child: Obx(
          () => badges.Badge(
            badgeContent: Obx(() => const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    '0',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            showBadge: true,
            child: Icon(
              EneftyIcons.shopping_cart_bold,
              color: activeColor,
              size: size,
            ),
          ),
        )),
        inactiveIcon: Center(
            child: Obx(
          () => badges.Badge(
            badgeContent: Obx(() => const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    '0',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            showBadge: true,
            child: Icon(
              EneftyIcons.shopping_cart_outline,
              color: inactiveColor,
              size: size,
            ),
          ),
        )),
        // title: ('Chats'),
        // textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          EneftyIcons.note_2_bold,
          color: activeColor,
          size: size,
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
          size: size,
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
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
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
      navBarHeight: 70.h,
      navBarStyle: NavBarStyle.style15,
    );
  }
}
