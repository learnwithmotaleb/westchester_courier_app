import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/widget/app_text_field.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
          child: Form(
            key: controller.formKey,
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
                  'Set New Password',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: Dimensions.h(8)),

                Text(
                  'Your new password must be different\nfrom your previous password.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.darkGreyColor,
                  ),
                ),

                SizedBox(height: Dimensions.h(40)),

                // New Password Field
                AppTextField(
                  controller: controller.newPasswordController,
                  hint: 'New Password',
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: Dimensions.h(16)),

                // Confirm Password Field
                AppTextField(
                  controller: controller.confirmPasswordController,
                  hint: 'Confirm New Password',
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != controller.newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: Dimensions.h(32)),

                // Reset Button
                Obx(
                  () => AppButton(
                    label: 'Reset Password',
                    onPressed: controller.resetPassword,
                    isLoading: controller.isLoading.value,
                    backgroundColor: AppColors.primaryColor,
                    textColor: AppColors.whiteColor,
                    borderSideColor: AppColors.primaryColor,
                    borderRadius: Dimensions.r(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
