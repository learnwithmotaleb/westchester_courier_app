import 'package:flutter/material.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_text_style/app_text_style.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: AppTextStyles.helveticaNeue,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: const Color(0xFF1E1E1E),
    background: const Color(0xFF121212),
    error: AppColors.redColor,
    onPrimary: AppColors.whiteColor,
    onSecondary: AppColors.whiteColor,
    onSurface: AppColors.whiteColor,
    onBackground: AppColors.whiteColor,
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: AppColors.whiteColor,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: AppTextStyles.helveticaNeue,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.whiteColor,
    ),
    iconTheme: IconThemeData(color: AppColors.whiteColor),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.blackColor, // Better contrast on yellow in dark mode
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
    fillColor: const Color(0xFF2C2C2C),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(color: Colors.grey),
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
    color: const Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);
