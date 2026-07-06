import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_text_field.dart';
import 'package:westchester/widget/app_button.dart';
import '../controller/update_profile_controller.dart';

class UpdateProfileScreen extends GetView<UpdateProfileController> {
  const UpdateProfileScreen({super.key});

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
                'Edit Profile',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Update your personal information to keep your account details accurate and up to date.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(24)),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: controller.nameController,
                        hint: 'Name',
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppTextField(
                        controller: controller.phoneController,
                        hint: 'Contact Number',
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppTextField(
                        controller: controller.emailController,
                        hint: 'Email Address',
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppTextField(
                        controller: controller.idController,
                        hint: 'ID',
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppTextField(
                        controller: controller.dateController,
                        hint: 'Date of Birth',
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(20)),
                child: AppButton(
                  label: 'Save',
                  onPressed: controller.save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
