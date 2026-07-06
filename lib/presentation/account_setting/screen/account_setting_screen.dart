import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/core/routes/route_path.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account settings',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
            SizedBox(height: Dimensions.h(8)),
            Text(
              'Manage your account security here. You can update your password to keep your account safe and secure.',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            ),
            SizedBox(height: Dimensions.h(32)),
            InkWell(
              onTap: () => Get.toNamed(RoutePath.updateProfile),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryColor,
                      size: Dimensions.rs(20),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.greyColor.withOpacity(0.2)),
            InkWell(
              onTap: () => Get.toNamed(RoutePath.changePassword),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Change Password',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryColor,
                      size: Dimensions.rs(20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
