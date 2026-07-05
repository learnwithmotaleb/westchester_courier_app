import 'package:flutter/material.dart';
import '../../utils/app_colors/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double? radius;
  final Color? backgroundColor;
  final bool showShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius,
    this.backgroundColor,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius ?? 12);
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(12),
      child: child,
    );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.whiteColor,
        borderRadius: borderRadius,
        boxShadow: showShadow ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}
