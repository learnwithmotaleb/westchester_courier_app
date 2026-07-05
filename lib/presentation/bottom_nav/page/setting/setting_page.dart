import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_svg_icon.dart';
import 'package:westchester/core/routes/route_path.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────
            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(16),
              ),
              child: Row(
                children: [
                  Text(
                    'Settings',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16),
                  vertical: Dimensions.h(16),
                ),
                child: Column(
                  children: [
                    // Profile card
                    Container(
                      padding: EdgeInsets.all(Dimensions.w(16)),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(Dimensions.r(12)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Dimensions.w(28),
                            backgroundColor: AppColors.lightGreyColor,
                            child: Icon(
                              Icons.person,
                              size: Dimensions.rs(28),
                              color: AppColors.greyColor,
                            ),
                          ),
                          SizedBox(width: Dimensions.w(14)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John Driver',
                                  style: AppTextStyles.h4.copyWith(
                                    color: AppColors.textPrimaryColor,
                                  ),
                                ),
                                SizedBox(height: Dimensions.h(2)),
                                Text(
                                  'john.driver@example.com',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.greyColor,
                            size: Dimensions.rs(20),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.h(16)),

                    // Settings list
                    _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: AppIcons.notification,
                          label: 'Notifications',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: AppIcons.change_password,
                          label: 'Change Password',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: AppIcons.language_preference,
                          label: 'Language',
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.h(12)),

                    _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: AppIcons.privacy_policy,
                          label: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: AppIcons.terms_condition,
                          label: 'Terms & Conditions',
                          onTap: () {},
                        ),
                        _SettingsItem(
                          icon: AppIcons.help_support,
                          label: 'Help & Support',
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.h(16)),

                    // Logout
                    GestureDetector(
                      onTap: () => Get.offAllNamed(RoutePath.login),
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.h(14)),
                        decoration: BoxDecoration(
                          color: AppColors.redColor.withOpacity(0.08),
                          borderRadius:
                              BorderRadius.circular(Dimensions.r(10)),
                          border: Border.all(
                            color: AppColors.redColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: AppColors.redColor,
                              size: Dimensions.rs(18),
                            ),
                            SizedBox(width: Dimensions.w(8)),
                            Text(
                              'Log Out',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.redColor,
                              ),
                            ),
                          ],
                        ),
                      ),
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

// ── Settings Group ───────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: Dimensions.w(52),
                color: AppColors.dividerColor,
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.r(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(16),
          vertical: Dimensions.h(14),
        ),
        child: Row(
          children: [
            Container(
              width: Dimensions.w(34),
              height: Dimensions.w(34),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor,
                borderRadius: BorderRadius.circular(Dimensions.r(8)),
              ),
              child: Center(
                child: CustomSvgIcon(
                  icon: icon,
                  size: Dimensions.rs(18),
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(width: Dimensions.w(12)),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.greyColor,
              size: Dimensions.rs(18),
            ),
          ],
        ),
      ),
    );
  }
}
