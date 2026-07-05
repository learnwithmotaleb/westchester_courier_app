import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? AppColors.primaryColor : AppColors.iconInactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: Dimensions.w(80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active indicator line
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.5,
              width: isActive ? Dimensions.w(40) : 0,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: Dimensions.h(6)),
            Icon(
              icon,
              size: Dimensions.rs(22),
              color: color,
            ),
            SizedBox(height: Dimensions.h(4)),
            Text(
              label,
              style: isActive
                  ? AppTextStyles.navLabelActive
                  : AppTextStyles.navLabelInactive,
            ),
            SizedBox(height: Dimensions.h(4)),
          ],
        ),
      ),
    );
  }
}
