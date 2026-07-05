import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController()); // Ensure it's active

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Image.asset(AppIcons.appLogo, width: Dimensions.w(200)),
      ),
    );
  }
}
