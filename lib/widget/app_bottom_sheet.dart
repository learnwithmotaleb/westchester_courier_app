import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors/app_colors.dart';

Future<T?> AppBottomSheet<T>({required Widget child}) {
  return Get.bottomSheet<T>(
    SafeArea(child: child),
    backgroundColor: AppColors.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
  );
}