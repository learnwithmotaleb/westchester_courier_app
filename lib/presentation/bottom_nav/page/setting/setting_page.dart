import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/widget/app_alert.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/widget/setting_item.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/widget/profile_card.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CommonAppBar(
        title: 'Settings',
        showBack: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(16),
        ),
        child: Column(
          children: [
            const ProfileCard(),
            SizedBox(height: Dimensions.h(24)),

            // Settings list
            Container(
              decoration: BoxDecoration(
                color: AppColors.scaffoldBgColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimensions.r(20)),
              ),
              child: Column(
                children: [
                  SettingItem(
                    icon: AppIcons.setting,
                    label: 'Account Settings',
                    onTap: () => Get.toNamed(RoutePath.accountSetting),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.greyColor.withOpacity(0.1),
                  ),
                  SettingItem(
                    icon: AppIcons.order_icon,
                    label: 'Job history',
                    onTap: () => Get.toNamed(RoutePath.jobHistory),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.greyColor.withOpacity(0.1),
                  ),
                  SettingItem(
                    icon: AppIcons.terms_condition,
                    label: 'Terms & Condition',
                    onTap: () => Get.toNamed(RoutePath.termsCondition),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.greyColor.withOpacity(0.2),
                  ),
                  SettingItem(
                    icon: AppIcons.privacy_policy,
                    label: 'Privacy Policy',
                    onTap: () => Get.toNamed(RoutePath.privacyPolicy),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.greyColor.withOpacity(0.2),
                  ),
                  SettingItem(
                    icon: AppIcons.help_support,
                    label: 'Contact & Support',
                    onTap: () => Get.toNamed(RoutePath.contactSupport),
                  ),

                  // Logout
                  GestureDetector(
                    onTap: () {
                      AppAlerts.actionConfirm(
                        title: 'Confirm Logout',
                        message: 'Are you sure you want to log out\nof your account?',
                        confirmLabel: 'Logout',
                        onConfirm: () => Get.offAllNamed(RoutePath.login),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: Dimensions.h(16)),
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Dimensions.r(20)),
                          bottomRight: Radius.circular(Dimensions.r(20)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: AppColors.redColor,
                            size: Dimensions.rs(20),
                          ),
                          SizedBox(width: Dimensions.w(8)),
                          Text(
                            'Logout',
                            style: AppTextStyles.bodyText.copyWith(
                              color: AppColors.redColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
