import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_svg_icon.dart';

class SettingItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  
  const SettingItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(16),
        ),
        child: Row(
          children: [
            CustomSvgIcon(
              icon: icon,
              size: Dimensions.rs(20),
              color: AppColors.textPrimaryColor,
            ),
            SizedBox(width: Dimensions.w(16)),
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
              color: AppColors.primaryColor,
              size: Dimensions.rs(20),
            ),
          ],
        ),
      ),
    );
  }
}
