import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffFFFBF8),
    primaryColor: AppColors.primary,
    primarySwatch:
        MaterialColor(AppColors.primary.value, AppColors.primaryPallet),
    textTheme: textTheme,
    appBarTheme: appBarTheme,
    textButtonTheme: TextButtonThemeData(style: primaryTextButtonStyle),
    unselectedWidgetColor: Colors.white,
  );

  static AppBarTheme appBarTheme = AppBarTheme(
    color: AppColors.primary,
    centerTitle: true,
    titleTextStyle: appBarTitleTheme,
    iconTheme: appBarIconTheme,
    shadowColor: const Color.fromARGB(45, 0, 0, 0),
    // elevation: 1
  );

  static IconThemeData appBarIconTheme = const IconThemeData(
    color: AppColors.white,
  );

  static TextStyle appBarTitleTheme = const TextStyle();

  static TextTheme textTheme = TextTheme(
    bodyLarge: bodyText1,
    bodyMedium: bodyText2,
    bodySmall: bodyText3,
  );

  static TextStyle bodyText1 = GoogleFonts.notoSans(
      fontWeight: FontWeight.w600, fontSize: 32, color: Colors.black);

  static TextStyle bodyText2 = GoogleFonts.notoSans(
      fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black);

  static TextStyle bodyText3 = GoogleFonts.notoSans(
      fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black);

  static ButtonStyle primaryTextButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 23),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: AppColors.primary,
      textStyle: buttonTextStyle);

  static const buttonTextStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white);
}
