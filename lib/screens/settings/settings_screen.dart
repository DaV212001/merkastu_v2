import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:merkastu_v2/config/storage_config.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/app_info_controller.dart';
import 'package:merkastu_v2/controllers/auth_controller.dart';
import 'package:merkastu_v2/controllers/theme_mode_controller.dart';
import 'package:merkastu_v2/widgets/cards/profile_list_card.dart';
import 'package:merkastu_v2/widgets/wallet_balance.dart';

import '../../models/user.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  var control = Get.put(AppInfoController(), tag: 'appInfo');
  final List<Map<String, dynamic>> routesList = [
    // {
    //   'name': 'Profile',
    //   'icon': EneftyIcons.profile_circle_bold,
    //   'onTap': () => Get.toNamed(Routes.profileRoute),
    //   'isFirstTile': true,
    //   'isLastTile': false,
    // },
    {
      'name': 'My Wallet',
      'icon': EneftyIcons.wallet_2_bold,
      'onTap': () => Get.toNamed(Routes.walletHistoryRoute),
      'isFirstTile': true,
      'isLastTile': false,
    },
    // {
    //   'name': 'Help and Support',
    //   'icon': Ionicons.help_circle,
    //   'onTap': () {},
    //   'isFirstTile': true,
    //   'isLastTile': false,
    // },
    {
      'name': 'About Us',
      'icon': EneftyIcons.info_circle_bold,
      'onTap': () {
        var control = Get.find<AppInfoController>(tag: 'appInfo');
        control.fetchAbout();
        Get.toNamed(Routes.aboutRoute);
      },
      'isFirstTile': false,
      'isLastTile': true,
    },
    {
      'name': 'Terms and Conditions',
      'icon': Ionicons.document_text,
      'onTap': () {
        var control = Get.find<AppInfoController>(tag: 'appInfo');

        control.fetchTermsAndConditions();
        Get.toNamed(Routes.termsRoute);
      },
      'isFirstTile': true,
      'isLastTile': false,
    },
    {
      'name': 'Privacy Policy',
      'icon': Ionicons.lock_closed,
      'onTap': () {
        var control = Get.find<AppInfoController>(tag: 'appInfo');
        control.fetchPrivacyPolicy();
        Get.toNamed(Routes.privacyRoute);
      },
      'isFirstTile': false,
      'isLastTile': false,
    },
    {
      'name': 'Refund Policy',
      'icon': EneftyIcons.money_change_bold,
      'onTap': () {
        var control = Get.find<AppInfoController>(tag: 'appInfo');
        control.fetchRefundPolicy();
        Get.toNamed(Routes.refundRoute);
      },
      'isFirstTile': false,
      'isLastTile': false,
    },
    {
      'name': 'Cancellation Policy',
      'icon': EneftyIcons.stop_bold,
      'onTap': () {
        var control = Get.find<AppInfoController>(tag: 'appInfo');
        control.fetchCancellationPolicy();
        Get.toNamed(Routes.cancelRoute);
      },
      'isFirstTile': false,
      'isLastTile': false,
    },
    {
      'name': 'Shipping Policy',
      'icon': EneftyIcons.car_bold,
      'onTap': () {
        var control = Get.find<AppInfoController>(tag: 'appInfo');
        control.fetchShippingPolicy();
        Get.toNamed(Routes.shippingRoute);
      },
      'isFirstTile': false,
      'isLastTile': true,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                  color: ThemeModeController.isLightTheme.value
                      ? maincolor
                      : Theme.of(context).cardColor),
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          EneftyIcons.profile_circle_bold,
                          color: !ThemeModeController.isLightTheme.value
                              ? maincolor
                              : Colors.white,
                          size: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.48) -
                                      16,
                                  child: AutoSizeText(
                                    (UserController.user.value.firstName ??
                                            '') +
                                        (' ') +
                                        (UserController.user.value.lastName ??
                                            ''),
                                    maxLines: 1,
                                    minFontSize: 9,
                                    maxFontSize: 16,
                                    stepGranularity: 0.5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp),
                                  ),
                                )),
                            Obx(() => SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.48) -
                                      16,
                                  child: AutoSizeText(
                                    '+${UserController.user.value.phone ?? ''}',
                                    maxLines: 1,
                                    minFontSize: 5,
                                    maxFontSize: 12,
                                    stepGranularity: 0.5,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.sp),
                                  ),
                                )),
                            Row(
                              children: [
                                const Icon(
                                  HugeIcons.strokeRoundedBuilding02,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Obx(() => Text(
                                      (UserController.user.value.block ?? '')
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    )),
                                const SizedBox(
                                  width: 6,
                                ),
                                const Icon(
                                  Icons.sensor_door_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Obx(() => Text(
                                      (UserController.user.value.room ?? '')
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    )),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.walletHistoryRoute),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const WalletBalance(
                          fromSettings: true,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text(
                      'Theme',
                      style: TextStyle(fontSize: 12),
                    ),
                    contentPadding: EdgeInsets.zero,
                    trailing: AnimatedToggleSwitch<bool>.dual(
                      current: ThemeModeController.isLightTheme.value,
                      first: false,
                      second: true,
                      // dif: 10.0,
                      // borderColor: Colors.transparent,
                      borderWidth: 0.0,
                      height: 40,
                      onChanged: (val) {
                        ThemeModeController.toggleThemeMode(); // Toggle theme
                      },
                      // colorBuilder: (b) => b ? Colors.black : maincolor,
                      iconBuilder: (value) => value
                          ? const Icon(Icons.light_mode, color: Colors.white)
                          : const Icon(Icons.dark_mode, color: Colors.white),
                      textBuilder: (value) => value
                          ? const Center(child: Text('Light Mode'))
                          : const Center(child: Text('Dark Mode')),
                    ),
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                  // color: Theme.of(context).cardColor,
                  ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ...routesList.map((e) => ProfileListCard(
                          icon: e['icon'],
                          name: e['name'],
                          onTap: e['onTap'],
                          isFirstTile: e['isFirstTile'],
                          isLastTile: e['isLastTile'],
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 50,
                  child: GestureDetector(
                      onTap: () {
                        ConfigPreference.logOut();
                        UserController.isLoggedIn.value = false;
                        UserController.user.value = User();
                        Get.toNamed(Routes.loginRoute);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Ionicons.log_out,
                            color: Colors.red,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                                color: maincolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 70.h,
            )
          ],
        ),
      ),
    );
  }
}
