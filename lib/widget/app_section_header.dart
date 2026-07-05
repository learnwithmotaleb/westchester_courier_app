import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? trailingText;
  final VoidCallback? onAction;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.trailingText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(color: AppColors.blackColor),
          ),
          const Spacer(),
          if (trailingText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                trailingText!,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
