import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';

class AppPillChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color? selectedColor;

  const AppPillChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = selectedColor ?? AppColors.primaryColor;
    final bg = selected ? activeColor.withOpacity(0.15) : AppColors.textFieldBackgroundColor;
    final fg = selected ? activeColor : AppColors.darkGreyColor;
    final border = selected ? activeColor : AppColors.greyColor.withOpacity(0.3);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: fg,
          ),
        ),
      ),
    );
  }
}