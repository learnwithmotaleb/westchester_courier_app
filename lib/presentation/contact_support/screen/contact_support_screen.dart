import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_text_field.dart';
import 'package:westchester/widget/app_button.dart';
import '../controller/contact_support_controller.dart';

class ContactSupportScreen extends GetView<ContactSupportController> {
  const ContactSupportScreen({super.key});

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
                'Contact & Support',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Need help? Contact our support team for assistance with your account, deliveries, or any issues you encounter.',
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
                        hint: 'Enter Your Name',
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppTextField(
                        controller: controller.emailController,
                        hint: 'Enter Email Address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: Dimensions.h(16)),
                      AppTextField(
                        controller: controller.messageController,
                        hint: 'Write here...',
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(20)),
                child: AppButton(
                  label: 'Submit',
                  onPressed: controller.submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
