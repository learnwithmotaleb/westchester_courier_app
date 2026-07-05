import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: AppTextStyles.cardTitle,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.cardSubtitle,
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.greyColor,
          ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
