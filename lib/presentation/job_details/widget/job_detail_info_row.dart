import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';

class JobDetailInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const JobDetailInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.h(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: Dimensions.rs(18), color: AppColors.primaryColor),
            SizedBox(width: Dimensions.w(10)),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.greyColor,
                    fontSize: Dimensions.fs(10),
                  ),
                ),
                SizedBox(height: Dimensions.h(3)),
                Text(
                  value,
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.fs(13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
