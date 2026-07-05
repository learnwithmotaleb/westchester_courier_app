import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_svg_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──────────────────────────────────────────────
            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(12),
              ),
              child: Row(
                children: [
                  Image.asset(AppIcons.appLogo, width: Dimensions.w(110)),
                  const Spacer(),
                  _AppBarButton(icon: AppIcons.search_icon),
                  SizedBox(width: Dimensions.w(10)),
                  _AppBarButton(icon: AppIcons.notification),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16),
                  vertical: Dimensions.h(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stats Card ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.w(20),
                        vertical: Dimensions.h(20),
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryLightColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.r(14)),
                      ),
                      child: Row(
                        children: [
                          _StatItem(
                            label: 'Pending Task',
                            value: '16',
                          ),
                          Container(
                            height: Dimensions.h(40),
                            width: 1,
                            color: AppColors.whiteColor.withOpacity(0.3),
                          ),
                          _StatItem(
                            label: 'Completed Task',
                            value: '142',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.h(20)),

                    // ── Section Title ───────────────────────────────
                    Text(
                      "Today's Tasks | Jul 24, 2026",
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: Dimensions.h(12)),

                    // ── Task List ───────────────────────────────────
                    ...List.generate(
                      4,
                      (i) => Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.h(12)),
                        child: const _TaskCard(),
                      ),
                    ),

                    SizedBox(height: Dimensions.h(8)),

                    Text(
                      "July 25, 2026",
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: Dimensions.h(12)),

                    ...List.generate(
                      2,
                      (i) => Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.h(12)),
                        child: const _TaskCard(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AppBar Icon Button ─────────────────────────────────────────────────────
class _AppBarButton extends StatelessWidget {
  final String icon;
  const _AppBarButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.w(36),
      height: Dimensions.w(36),
      decoration: BoxDecoration(
        // color: AppColors.appBarBtnColor,
        borderRadius: BorderRadius.circular(Dimensions.r(8)),
        border: Border.all(color: AppColors.appBarBtnBorderColor),
      ),
      child: Center(
        child: CustomSvgIcon(
          icon: icon,
          size: Dimensions.rs(18),
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

// ── Stat Item ─────────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.whiteColor.withOpacity(0.8),
            ),
          ),
          SizedBox(height: Dimensions.h(4)),
          Text(
            value,
            style: AppTextStyles.displayNumberSmall.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Task Card ─────────────────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  const _TaskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.w(14)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pick-up
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PIC-UP LOCATION',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.greyColor,
                        fontSize: Dimensions.fs(9),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      '1426 Atlantic Ave,\nBrooklyn, NY 11216',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontSize: Dimensions.fs(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              Padding(
                padding: EdgeInsets.only(top: Dimensions.h(14)),
                child: Icon(
                  Icons.arrow_forward,
                  size: Dimensions.rs(18),
                  color: AppColors.primaryColor,
                ),
              ),
              // Delivery
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'DELIVERY LOCATION',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.greyColor,
                        fontSize: Dimensions.fs(9),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(4)),
                    Text(
                      '151 Newark Ave,\nJersey City, NJ 07302',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontSize: Dimensions.fs(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(12)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(6)),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.h(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Open Map',
                    style: AppTextStyles.buttonSmall,
                  ),
                ),
              ),
              SizedBox(width: Dimensions.w(10)),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(6)),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.h(8)),
                  ),
                  child: Text(
                    'View Details',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
