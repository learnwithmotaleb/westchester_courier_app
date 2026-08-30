import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/presentation/account_setting/controller/account_setting_controller.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/widget/app_text_field.dart';

class AccountSettingScreen extends GetView<AccountSettingController> {
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
            Divider(height: 1, color: AppColors.greyColor.withOpacity(0.2)),
            InkWell(
              onTap: _showDeleteWarning,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete Account',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.redColor,
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

  Future<void> _showDeleteWarning() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete your account?'),
        content: const Text(
          'This action is permanent. Your account and associated data will be '
          'deleted and cannot be recovered.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Continue', style: TextStyle(color: AppColors.redColor)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (confirmed == true) _showPasswordConfirmation();
  }

  void _showPasswordConfirmation() {
    controller.passwordController.clear();
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm account deletion'),
        content: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your password to permanently delete your account.'),
              SizedBox(height: Dimensions.h(16)),
              AppTextField(
                controller: controller.passwordController,
                label: 'Password',
                hint: 'Enter your password',
                obscure: true,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Password is required'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(() => SizedBox(
                width: 150,
                child: AppButton(
                  label: 'Delete account',
                  backgroundColor: AppColors.redColor,
                  borderSideColor: AppColors.redColor,
                  isLoading: controller.isDeleting.value,
                  onPressed: controller.deleteAccount,
                ),
              )),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
