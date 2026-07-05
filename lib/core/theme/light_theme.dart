import 'package:flutter/material.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_text_style/app_text_style.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: AppTextStyles.helveticaNeue,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: AppColors.whiteColor,
    background: AppColors.backgroundColor,
    error: AppColors.redColor,
    onPrimary: AppColors.whiteColor,
    onSecondary: AppColors.whiteColor,
    onSurface: AppColors.blackColor,
    onBackground: AppColors.blackColor,
  ),

  scaffoldBackgroundColor: AppColors.backgroundColor,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.backgroundColor,
    foregroundColor: AppColors.blackColor,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: AppTextStyles.helveticaNeue,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.blackColor,
    ),
    iconTheme: IconThemeData(color: AppColors.blackColor),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontFamily: AppTextStyles.helveticaNeue,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.textFieldBackgroundColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(color: AppColors.hintTextColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColors.whiteColor,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.whiteColor,
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: AppColors.greyColor,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);
