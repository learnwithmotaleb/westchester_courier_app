import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';

class AppEmptyState extends StatelessWidget {
  final IconData ? icon;
  final String? title;
  final String? subtitle;
  final Widget? action;

  const AppEmptyState({
    super.key,
    this.icon ,
     this.title,
    this.subtitle,
    this.action,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.primaryColor),
            const SizedBox(height: 16),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(color: AppColors.blackColor),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(color: AppColors.greyColor),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ]
          ],
        ),
      ),
    );
  }
}
