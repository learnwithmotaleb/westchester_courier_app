import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/widget/app_text_field.dart';

import 'package:westchester/core/routes/route_path.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

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
              
              // App Logo
              Image.asset(AppIcons.appLogo, width: Dimensions.w(120)),
              
              SizedBox(height: Dimensions.h(30)),
              
              // Title
              Text(
                "Sign up to\nWestchester Courier",
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
              
              // Create Password Field
              AppTextField(
                controller: controller.passwordController,
                hint: "Create Password",
                obscure: true,
              ),
              
              SizedBox(height: Dimensions.h(16)),

              // Confirm Password Field
              AppTextField(
                controller: controller.confirmPasswordController,
                hint: "Confirm Password",
                obscure: true,
              ),

              SizedBox(height: Dimensions.h(32)),
              
              // Continue Button
              Obx(() => AppButton(
                label: "Continue",
                onPressed: controller.signup,
                isLoading: controller.isLoading.value,
                backgroundColor: AppColors.primaryColor,
                textColor: AppColors.whiteColor,
                borderSideColor: AppColors.primaryColor,
                borderRadius: Dimensions.r(8),
              )),
              
              SizedBox(height: Dimensions.h(24)),
              
              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(RoutePath.login),
                    child: Text(
                      "Sign in",
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
              SizedBox(height: Dimensions.h(20)),
            ],
          ),
        ),
      ),
    );
  }
}
