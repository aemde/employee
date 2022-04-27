import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static Color error = Colors.red[700]!;
  static final Color primaryColor = Color(0xFF303F9F);
  static final Color primaryColorLite = Color(0xFF303F9F);
  static final Color primarySwatchColor = Color(0xFF303F9F);
  static final Color primaryDarkColor = Color(0xFF303F9F);

  static final ThemeData ReqResUserThemeData = ThemeData(
    fontFamily: 'roboto',
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    primaryColor: primaryDarkColor,
    primaryColorDark: primarySwatchColor,
  );
}
