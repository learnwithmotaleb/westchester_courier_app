import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import '../controller/terms_condition_controller.dart';

class TermsConditionScreen extends GetView<TermsConditionController> {
  const TermsConditionScreen({super.key});

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
                'Terms & Conditions',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Read the terms and conditions that govern your use of the app and our services.',
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
