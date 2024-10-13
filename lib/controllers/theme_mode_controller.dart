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
    isLightTheme = ConfigPreference.getThemeIsLight().obs;
    print('SET THEME: ${ConfigPreference.getThemeIsLight()}');
  }

  static late RxBool isLightTheme;

  static ThemeData getThemeMode() => _themeMode.value;
  static void setThemeMode(ThemeData value) {
    _themeMode.value = value;
    isLightTheme.value = isCurrentlyLight();
  }

  static bool isCurrentlyLight() =>
      _themeMode.value == appTheme(_context, isDark: false);
  static void toggleThemeMode() {
    bool isCurrentlyLight =
        _themeMode.value == appTheme(_context, isDark: false);
    setThemeMode(appTheme(_context, isDark: isCurrentlyLight));
    ConfigPreference.setThemeIsLight(!isCurrentlyLight);
    Logger().d(isCurrentlyLight);
  }
}
