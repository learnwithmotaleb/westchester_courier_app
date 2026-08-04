import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/widget/app_text_field.dart';

import '../controller/driver_verification_controller.dart';

class DriverVerificationScreen extends GetView<DriverVerificationController> {
  const DriverVerificationScreen({super.key});

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
                "Driver Verification",
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
                "Enter your Driving ID",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: Dimensions.h(40)),

              // Driving ID Field
              AppTextField(
                controller: controller.drivingIdController,
                hint: "Driving ID",
                keyboardType: TextInputType.text,
              ),

              SizedBox(height: Dimensions.h(16)),

              // Date of Birth Field
              AppTextField(
                controller: controller.dobController,
                hint: "Date of Birth",
                readOnly: true,
                onTap: () => controller.selectDate(context),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () => controller.selectDate(context),
                ),
              ),

              SizedBox(height: Dimensions.h(16)),

              // Phone Number Field
              AppTextField(
                controller: controller.phoneNumberController,
                hint: "Phone Number",
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: Dimensions.h(16)),

              // Address Field
              AppTextField(
                controller: controller.addressController,
                hint: "Address",
                keyboardType: TextInputType.streetAddress,
              ),

              SizedBox(height: Dimensions.h(32)),

              // Continue Button
              Obx(() => AppButton(
                label: "Continue",
                onPressed: controller.submit,
                isLoading: controller.isLoading.value,
                backgroundColor: AppColors.primaryColor,
                textColor: AppColors.whiteColor,
                borderSideColor: AppColors.primaryColor,
                borderRadius: Dimensions.r(8),
              )),
              
            ],
          ),
        ),
      ),
    );
  }
}
