import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';

class ShowAppSnackBar {
  ShowAppSnackBar._();

  /// ✅ Success snackbar
  static void success(String message, {String? title}) {
    _show(
      message,
      title: title ?? "Success",
      backgroundColor: AppColors.primaryColor,
      textColor: AppColors.whiteColor,
    );
  }

  /// ❌ Failure snackbar
  static void fail(String message, {String? title}) {
    _show(
      message,
      title: title ?? "Error",
      backgroundColor: AppColors.redColor,
      textColor: AppColors.whiteColor,
    );
  }

  /// ℹ️ Info / Warning snackbar
  static void info(String message, {String? title}) {
    _show(
      message,
      title: title ?? "Info",
      backgroundColor: AppColors.darkGreyColor,
      textColor: AppColors.whiteColor,
    );
  }

  /// 🔒 Generic snackbar (private)
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
