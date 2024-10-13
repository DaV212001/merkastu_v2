import 'package:flutter/material.dart';

import '../constants/constants.dart';

ColorScheme appColor([bool? isDark]) => ColorScheme.fromSeed(
    seedColor: const Color(0xFF039D55),
    primary: const Color(0xFF039D55),
    secondary: const Color(0xFF062945),
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    surface:
        (isDark ?? false) ? const Color(0xFF121212) : const Color(0xFFF1EFEF),
    brightness: isDark == null
        ? Brightness.light
        : isDark
            ? Brightness.dark
            : Brightness.light);

// Cache to store the theme based on the isDark parameter
Map<bool?, ThemeData> _themeCache = {};

ThemeData appTheme(BuildContext context, {bool? isDark}) {
  // Check if the theme for this isDark parameter is already cached
  if (_themeCache.containsKey(isDark)) {
    return _themeCache[isDark]!;
  }

  // If not cached, create the theme
  ColorScheme themeColor = appColor(isDark);
  ThemeData theme = ThemeData(
    primaryColor: const Color(0xFF3AE0C4),
    colorScheme: themeColor,
    fontFamily: 'Montserrat',
    useMaterial3: true,
    appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
      fontSize: 18,
      fontFamily: 'Montserrat',
      color: isDark == true ? Colors.white : Colors.black,
    )),
    cardColor: isDark == true ? const Color(0xFF171717) : Colors.white,
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(
          color: (isDark ?? true) ? Colors.white : themeColor.primary,
          fontFamily: 'Montserrat',
          fontSize: 12),
      unselectedLabelStyle: TextStyle(
        color: (isDark ?? true) ? maincolor.withOpacity(0.5) : Colors.black,
        fontFamily: 'Montserrat',
      ),
      unselectedLabelColor:
          (isDark ?? true) ? themeColor.primary.withOpacity(0.5) : Colors.black,
    ),
    scaffoldBackgroundColor:
        (isDark ?? true) ? themeColor.surface : const Color(0xFFF8F6F6),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(themeColor.primary),
      ),
    ),
  );

  // Cache the newly created theme
  _themeCache[isDark] = theme;

  // Return the newly created theme
  return theme;
}
