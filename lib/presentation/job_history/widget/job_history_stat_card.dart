import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';

class JobHistoryStatCard extends StatelessWidget {
  final String month;
  final String filter;
  final int assigned;
  final int delivery;
  final int canceled;
  final ValueChanged<String>? onFilterChanged;

  const JobHistoryStatCard({
    super.key,
    required this.month,
    required this.filter,
    required this.assigned,
    required this.delivery,
    required this.canceled,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(16)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                month,
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: onFilterChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                color: AppColors.whiteColor,
                itemBuilder: (context) =>
                    ['Monthly', 'Weekly', 'Yearly'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.textPrimaryColor,
                          ),
                        ),
                      );
                    }).toList(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(12),
                    vertical: Dimensions.h(4),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.r(20)),
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        filter,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      SizedBox(width: Dimensions.w(4)),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: Dimensions.rs(16),
                        color: AppColors.textPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(20)),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total Assigned', assigned.toString()),
              ),
              Container(
                width: 1,
                height: Dimensions.h(40),
                color: AppColors.greyColor.withOpacity(0.2),
              ),
              Expanded(
                child: _buildStatItem('Total Delivery', delivery.toString()),
              ),
              Container(
                width: 1,
                height: Dimensions.h(40),
                color: AppColors.greyColor.withOpacity(0.2),
              ),
              Expanded(
                child: _buildStatItem('Total Canceled', canceled.toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondaryColor,
          ),
        ),
        SizedBox(height: Dimensions.h(4)),
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
