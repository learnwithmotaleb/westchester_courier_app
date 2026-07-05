import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/app_button.dart';
import '../controller/welcome_controller.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.h(100)),
              
              // Title
              Text(
                "Hi, Ronald Richards",
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              
              // Subtitle
              Text(
                "Setup your Profile",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: Dimensions.h(60)),
              
              // Profile Image Placeholder
              GestureDetector(
                onTap: () {
                  // Trigger image picker via controller
                },
                child: Container(
                  width: Dimensions.w(120),
                  height: Dimensions.w(120),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withOpacity(0.1),
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: Dimensions.w(60),
                        color: AppColors.primaryColor.withOpacity(0.4),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.w(8)),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.whiteColor, width: 2),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.whiteColor,
                            size: Dimensions.w(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Continue Button
              Obx(() => AppButton(
                label: "Continue",
                onPressed: controller.setupProfile,
                isLoading: controller.isLoading.value,
                backgroundColor: AppColors.primaryColor,
                textColor: AppColors.whiteColor,
                borderSideColor: AppColors.primaryColor,
                borderRadius: Dimensions.r(8),
              )),
              
              SizedBox(height: Dimensions.h(40)),
            ],
          ),
        ),
      ),
    );
  }
}
