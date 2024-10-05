import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../config/storage_config.dart';
import '../config/theme.dart';

class ThemeModeController extends GetxController {
  static late Rx<ThemeData> _themeMode;
  static late BuildContext _context;
  ThemeModeController(BuildContext context) {
    _context = context;
  }
  @override
  void onInit() {
    super.onInit();
    _themeMode =
        appTheme(_context, isDark: !ConfigPreference.getThemeIsLight()).obs;
    // print(
    //     'SET THEME: ${_themeMode.value.cardColor == appTheme(_context, isDark: true).cardColor}');
  }

  static ThemeData getThemeMode() => _themeMode.value;
  static void setThemeMode(ThemeData value) => _themeMode.value = value;
  static bool isCurrentlyLight() =>
      _themeMode.value.cardColor == appTheme(_context, isDark: false).cardColor;
  static void toggleThemeMode() {
    bool isCurrentlyLight = _themeMode.value.cardColor ==
        appTheme(_context, isDark: false).cardColor;
    bool isLight = !isCurrentlyLight;
    setThemeMode(appTheme(_context, isDark: !isLight));
    ConfigPreference.setThemeIsLight(isLight);
    Logger().d(isCurrentlyLight);
  }
}
