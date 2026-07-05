import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_text_style/app_text_style.dart';

class AppSnackBar {
  AppSnackBar._();

  static void success(String message, {String? title}) {
    _show(
      message,
      title: title ?? "Success",
      backgroundColor: AppColors.primaryColor,
      textColor: AppColors.whiteColor,
    );
  }

  static void fail(String message, {String? title}) {
    _show(
      message,
      title: title ?? "Error",
      backgroundColor: AppColors.redColor,
      textColor: AppColors.whiteColor,
    );
  }

  static void info(String message, {String? title}) {
    _show(
      message,
      title: title ?? "Info",
      backgroundColor: AppColors.darkGreyColor,
      textColor: AppColors.whiteColor,
    );
  }

  static void _show(
    String message, {
    String? title,
    required Color backgroundColor,
    required Color textColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title ?? '',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      titleText: title != null
          ? Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(color: textColor),
            )
          : const SizedBox(),
      messageText: Text(
        message,
        style: AppTextStyles.caption.copyWith(color: textColor),
      ),
    );
  }
}
