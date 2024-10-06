import 'package:flutter/material.dart';

ColorScheme appColor([bool? isDark]) => ColorScheme.fromSeed(
    seedColor: const Color(0xFF3AE0C4),
    primary: const Color(0xFF3AE0C4),
    secondary: const Color(0xFF062945),
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    brightness: isDark == null
        ? Brightness.light
        : isDark
            ? Brightness.dark
            : Brightness.light);

ThemeData appTheme(BuildContext context, {bool? isDark}) {
  ColorScheme themeColor = appColor(isDark);
  return ThemeData(
      primaryColor: const Color(0xFF3AE0C4),
      colorScheme: themeColor,
      fontFamily: 'Montserrat',
      useMaterial3: true,
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(
            color: (isDark ?? true) ? Colors.white : themeColor.primary,
            fontFamily: 'Montserrat'),
        unselectedLabelColor:
            (isDark ?? true) ? themeColor.primary : Colors.black,
      ),
      scaffoldBackgroundColor:
          (isDark ?? true) ? themeColor.surfaceContainer : Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        // minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
        backgroundColor: WidgetStatePropertyAll(themeColor.primary),
        // overlayColor:
        //     WidgetStatePropertyAll(themeColor.onPrimaryContainer)),
      )));
}
