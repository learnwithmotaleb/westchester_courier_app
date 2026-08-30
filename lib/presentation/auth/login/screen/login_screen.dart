import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/widget/app_text_field.dart';

import 'package:westchester/core/routes/route_path.dart';
import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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
              SizedBox(height: Dimensions.h(60)),

              // App Logo
              Image.asset(AppIcons.appLogo, width: Dimensions.w(120)),

              SizedBox(height: Dimensions.h(40)),

              // Title
              Text(
                "Sign in to\nWestchester Courier",
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),

              SizedBox(height: Dimensions.h(40)),

              // Email Field
              AppTextField(
                controller: controller.emailController,
                hint: "Email Address",
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: Dimensions.h(16)),

              // Password Field
              AppTextField(
                controller: controller.passwordController,
                hint: "Password",
                obscure: true,
              ),

              SizedBox(height: Dimensions.h(32)),

              // Sign In Button
              Obx(
                () => AppButton(
                  label: "Sign In",
                  onPressed: controller.login,
                  isLoading: controller.isLoading.value,
                  backgroundColor: AppColors.primaryColor,
                  textColor: AppColors.whiteColor,
                  borderSideColor: AppColors.primaryColor,
                  borderRadius: Dimensions.r(8),
                ),
              ),

              SizedBox(height: Dimensions.h(24)),

              // Forgot Password Link
              GestureDetector(
                onTap: () => Get.toNamed(RoutePath.forgotPassword),
                child: Text(
                  'Forgot Password',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.darkGreyColor,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.darkGreyColor,
                  ),
                ),
              ),

              SizedBox(height: Dimensions.h(16)),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New here? ",
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(RoutePath.signup),
                    child: Text(
                      "Create an account",
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
            ],
          ),
        ),
      ),
    );
  }
}
