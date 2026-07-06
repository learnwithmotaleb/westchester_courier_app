import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_text_field.dart';
import 'package:westchester/widget/app_button.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: '',
        showBack: true,
        backgroundColor: AppColors.whiteColor,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Change Password',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Update your password to keep your account secure.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(32)),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          controller: controller.currentPasswordController,
                          hint: 'Current Password',
                          obscure: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter current password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Dimensions.h(16)),
                        AppTextField(
                          controller: controller.newPasswordController,
                          hint: 'New Password',
                          obscure: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Dimensions.h(16)),
                        AppTextField(
                          controller: controller.confirmPasswordController,
                          hint: 'Confirm Password',
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
                      ],
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(20)),
                child: AppButton(
                  label: 'Change Password',
                  onPressed: controller.changePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
