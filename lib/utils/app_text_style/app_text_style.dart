import 'package:flutter/material.dart';
import '../../core/responsive_layout/dimensions.dart';
import '../app_colors/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String helveticaNeue = "HelveticaNeue";

  // 🔹 Headers
  static TextStyle h1 = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(28),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(24),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(18),
    fontWeight: FontWeight.w700,
    color: AppColors.blackColor,
  );

  static TextStyle h4 = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(16),
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
  );

  // 🔹 Aliases for existing styles
  static TextStyle get title => h2;
  static TextStyle get sectionTitle => h3;

  // 🔹 Body / Subtitle
  static TextStyle bodyText = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w400,
    color: AppColors.darkGreyColor,
  );

  static TextStyle get body => bodyText;

  // 🔹 Hint / Label
  static TextStyle hint = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w400,
    color: AppColors.hintTextColor,
  );

  // 🔹 Button
  static TextStyle button = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(16),
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );

  static TextStyle buttonSmall = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );

  static TextStyle buttonOutlined = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(16),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  // 🔹 AppBar
  static TextStyle appBarTitle = h3.copyWith(
    fontStyle: FontStyle.italic,
  );

  static TextStyle appBarAction = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  // 🔹 Label
  static TextStyle labelSmall = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(11),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryColor,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(12),
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondaryColor,
    letterSpacing: 0.4,
  );

  static TextStyle labelLarge = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryColor,
  );

  // 🔹 Caption
  static TextStyle caption = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(12),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryColor,
  );

  static TextStyle captionBold = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(12),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryColor,
  );

  // 🔹 Input field
  static TextStyle inputText = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w400,
    color: AppColors.inputTextColor,
  );

  static TextStyle inputHint = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w400,
    color: AppColors.hintTextColor,
  );

  static TextStyle inputLabel = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(13),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryColor,
  );

  static TextStyle inputError = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(12),
    fontWeight: FontWeight.w400,
    color: AppColors.redColor,
  );

  // 🔹 Status / Badge
  static TextStyle statusAccepted = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(12),
    fontWeight: FontWeight.w600,
    color: AppColors.acceptRequestColor,
  );

  static TextStyle statusRejected = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(12),
    fontWeight: FontWeight.w600,
    color: AppColors.rejectRequestColor,
  );

  static TextStyle statusPending = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(12),
    fontWeight: FontWeight.w600,
    color: AppColors.warningColor,
  );

  // 🔹 Navigation / Tab
  static TextStyle navLabelActive = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(11),
    fontWeight: FontWeight.w600,
    color: AppColors.iconActiveColor,
  );

  static TextStyle navLabelInactive = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(11),
    fontWeight: FontWeight.w400,
    color: AppColors.iconInactiveColor,
  );

  // 🔹 Card / List item
  static TextStyle cardTitle = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(15),
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryColor,
  );

  static TextStyle cardSubtitle = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(13),
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryColor,
  );

  static TextStyle cardMeta = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(11),
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor,
  );

  // 🔹 Link
  static TextStyle link = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(14),
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primaryColor,
  );

  // 🔹 Section header / Overline
  static TextStyle overline = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(11),
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondaryColor,
    letterSpacing: 1.2,
  );

  // 🔹 Counter / Badge number
  static TextStyle badgeCount = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(10),
    fontWeight: FontWeight.w700,
    color: AppColors.whiteColor,
  );

  // 🔹 Large display number (e.g. dashboard stats)
  static TextStyle displayNumber = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(36),
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );

  static TextStyle displayNumberSmall = TextStyle(
    fontFamily: helveticaNeue,
    fontSize: Dimensions.fs(22),
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );
}