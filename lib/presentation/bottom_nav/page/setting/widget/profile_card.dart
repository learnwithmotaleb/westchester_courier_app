import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/controller/setting_controller.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';

class ProfileCard extends GetView<SettingController> {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(20),
        vertical: Dimensions.h(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(Dimensions.r(20)),
      ),
      child: Obx(() {
        final isLoading = controller.isLoading.value;
        final profile = controller.profile.value;

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final imageUrl = ApiUrl.buildImageUrl(profile?.profileImage);

        return Column(
          children: [
            CircleAvatar(
              radius: Dimensions.w(30),
              backgroundColor: AppColors.lightGreyColor,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(
                      Icons.person,
                      size: Dimensions.w(30),
                      color: AppColors.greyColor,
                    )
                  : null,
            ),
            SizedBox(height: Dimensions.h(12)),
            Text(
              profile?.name ?? '—',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.h(4)),
            Text(
              profile?.email ?? '—',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            ),
            SizedBox(height: Dimensions.h(2)),
            Text(
              profile?.driverId != null ? 'ID - ${profile!.driverId}' : '—',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            ),
            SizedBox(height: Dimensions.h(5)),

          ],
        );
      }),
    );
  }
}
