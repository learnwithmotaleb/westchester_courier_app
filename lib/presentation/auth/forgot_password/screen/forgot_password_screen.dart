import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/widget/app_text_field.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.h(40)),

              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: Dimensions.w(40),
                    height: Dimensions.w(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withOpacity(0.08),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: Dimensions.w(18),
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),

              SizedBox(height: Dimensions.h(30)),

              // App Logo
              Image.asset(AppIcons.appLogo, width: Dimensions.w(120)),

              SizedBox(height: Dimensions.h(30)),

              // Title
              Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),

              SizedBox(height: Dimensions.h(8)),

              Text(
                'Enter your registered email and we\'ll\nsend you a reset code.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.darkGreyColor,
                ),
              ),

              SizedBox(height: Dimensions.h(40)),

              // Email Field
              AppTextField(
                controller: controller.emailController,
                hint: 'Email Address',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: Dimensions.h(32)),

              // Send Code Button
              Obx(() => AppButton(
                    label: 'Send Reset Code',
                    onPressed: controller.sendForgotPasswordEmail,
                    isLoading: controller.isLoading.value,
                    backgroundColor: AppColors.primaryColor,
                    textColor: AppColors.whiteColor,
                    borderSideColor: AppColors.primaryColor,
                    borderRadius: Dimensions.r(8),
                  )),

              SizedBox(height: Dimensions.h(24)),

              // Back to login
              GestureDetector(
                onTap: () => Get.back(),
                child: Text(
                  'Back to Sign In',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
