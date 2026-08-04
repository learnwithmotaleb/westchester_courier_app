import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/widget/app_alert.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/controller/setting_controller.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/widget/setting_item.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/widget/profile_card.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController());
    }

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
            SizedBox(height: Dimensions.h(16)),

            // ── Profile Info Card ──────────────────────────────
            Obx(() {
              final p = controller.profile.value;
              if (p == null) return const SizedBox.shrink();

              // Format date of birth
              String dob = '—';
              if (p.dateOfBirth != null) {
                try {
                  final dt = DateTime.parse(p.dateOfBirth!);
                  dob =
                      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
                } catch (_) {
                  dob = p.dateOfBirth!;
                }
              }

              // Approval status badge color
              final statusColor = p.approvalStatus == 'APPROVED'
                  ? Colors.green
                  : p.approvalStatus == 'REJECTED'
                  ? AppColors.redColor
                  : Colors.orange;

              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(20),
                  vertical: Dimensions.h(16),
                ),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBgColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Dimensions.r(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(16)),
                    _InfoRow(label: 'Phone', value: p.phoneNumber ?? '—'),
                    _Divider(),
                    _InfoRow(label: 'Address', value: p.address ?? '—'),
                    _Divider(),
                    _InfoRow(label: 'Date of Birth', value: dob),
                    _Divider(),
                    _InfoRow(label: 'Driver ID', value: p.driverId ?? '—'),
                    _Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Approval Status',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondaryColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(10),
                            vertical: Dimensions.h(4),
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(
                              Dimensions.r(20),
                            ),
                          ),
                          child: Text(
                            p.approvalStatus ?? '—',
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _Divider(),
                    _InfoRow(
                      label: 'Profile Completed',
                      value: (p.isProfileCompleted ?? false) ? 'Yes' : 'No',
                    ),
                    _Divider(),
                    _InfoRow(
                      label: 'Online Status',
                      value: (p.isOnline ?? false) ? 'Online' : 'Offline',
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: Dimensions.h(16)),

            // ── Settings list ──────────────────────────────────
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
                        message:
                            'Are you sure you want to log out\nof your account?',
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

            SizedBox(height: Dimensions.h(24)),
          ],
        ),
      ),
    );
  }
}

// ── Private helper widgets ─────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.h(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondaryColor,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: Dimensions.h(16),
      color: AppColors.greyColor.withOpacity(0.15),
    );
  }
}
