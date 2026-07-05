import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';

class AppIconBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const AppIconBadge({super.key, required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primaryColor;
    final bg = activeColor.withOpacity(0.1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: activeColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.captionBold.copyWith(color: activeColor),
          ),
        ],
      ),
    );
  }
}
