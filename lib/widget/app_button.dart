import 'package:flutter/material.dart';
import 'app_loading.dart';
import '../utils/app_text_style/app_text_style.dart';
import '../utils/app_colors/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // make nullable
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double width;
  final Color? borderSideColor;
  final double borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isLoading;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final FontWeight? fontWeight;

  static int _lastClickTime = 0;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.whiteColor,
    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 10,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.borderSideColor = AppColors.primaryColor,
    this.fontSize,
    this.padding,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: (onPressed == null || isLoading)
              ? AppColors.greyColor // disabled color
              : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderSideColor != null
                ? BorderSide(
              color: borderSideColor!,
              width: 1.0,
            )
                : BorderSide.none,
          ),
        ),
        onPressed: isLoading
            ? null
            : (onPressed == null
                ? null
                : () {
                    final currentTime = DateTime.now().millisecondsSinceEpoch;
                    if (currentTime - _lastClickTime < 500) {
                      return; // Block duplicate rapid clicks
                    }
                    _lastClickTime = currentTime;
                    onPressed!();
                  }),
        child: isLoading
            ? AppLoading(color: textColor, size: 24)
            : Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon!,
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.button.copyWith(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
