import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/app_button.dart';

import 'package:westchester/core/routes/route_path.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(AppIcons.appLogo, width: Dimensions.w(120)),
              
              SizedBox(height: Dimensions.h(40)),
              
              // Title
              Text(
                "Verification Successful",
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              
              // Subtitle
              Text(
                "Continue to Setup your Profile",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: Dimensions.h(40)),
              
              // Continue Button
              AppButton(
                label: "Continue",
                onPressed: () => Get.offAllNamed(RoutePath.welcome),
                backgroundColor: AppColors.primaryColor,
                textColor: AppColors.whiteColor,
                borderSideColor: AppColors.primaryColor,
                borderRadius: Dimensions.r(8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
