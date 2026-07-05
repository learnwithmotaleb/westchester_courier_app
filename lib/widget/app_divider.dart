import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';

class AppDivider extends StatelessWidget {
  final double thickness;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const AppDivider({super.key, this.thickness = 1.0, this.margin, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        color: color ?? AppColors.greyColor.withOpacity(0.1),
        thickness: thickness,
        height: thickness,
      ),
    );
  }
}
