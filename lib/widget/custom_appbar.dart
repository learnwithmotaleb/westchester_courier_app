import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';
import '../core/responsive_layout/dimensions.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final Color titleColor;
  final double? height;
  final Color backIconColor;
  final List<Widget>? actions;
  final bool centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.backgroundColor = AppColors.backgroundColor,
    this.titleColor = AppColors.blackColor,
    this.backIconColor = AppColors.blackColor,
    this.actions,
    this.height = 56,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leadingWidth: showBack ? Dimensions.w(65) : 0,
      leading: showBack
          ? Center(
              child: GestureDetector(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                child: Container(
                  height: Dimensions.w(40),
                  width: Dimensions.w(40),
                  decoration: BoxDecoration(
                    color: AppColors.appBarBtnColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.appBarBtnBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: backIconColor,
                    size: Dimensions.icon(20),
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.appBarTitle.copyWith(color: titleColor),
      ),
      actions: actions,
    );
  }
}
