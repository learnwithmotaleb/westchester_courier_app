import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import '../controller/privacy_policy_controller.dart';

class PrivacyPolicyScreen extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyScreen({super.key});

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
                'Privacy Policy',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Learn how we collect, use, store, and protect your personal information.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(24)),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '', // Empty for now as per design
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
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
