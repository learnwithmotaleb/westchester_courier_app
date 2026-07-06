import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/assets_image/app_images.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';

class ProfileCard extends StatelessWidget {
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
      child: Column(
        children: [
          CircleAvatar(
            radius: Dimensions.w(30),
            backgroundColor: AppColors.lightGreyColor,
            backgroundImage: const AssetImage(AppImages.profileImage),
          ),
          SizedBox(height: Dimensions.h(12)),
          Text(
            'Ronald Richards',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimensions.h(4)),
          Text(
            'tim.jennings@example.com',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondaryColor,
            ),
          ),
          SizedBox(height: Dimensions.h(2)),
          Text(
            'ID - 458926',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondaryColor,
            ),
          ),
          SizedBox(height: Dimensions.h(16)),
          OutlinedButton(
            onPressed: () => Get.toNamed(RoutePath.updateProfile),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.r(30)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(40),
                vertical: Dimensions.h(10),
              ),
            ),
            child: Text(
              'Edit Profile',
              style: AppTextStyles.bodyText.copyWith(
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
