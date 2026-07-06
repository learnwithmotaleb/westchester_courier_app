import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';

class JobHistoryCard extends StatelessWidget {
  final String jobId;
  final String assignDate;
  final String status;
  final String fromAddress;
  final String toAddress;

  const JobHistoryCard({
    super.key,
    required this.jobId,
    required this.assignDate,
    required this.status,
    required this.fromAddress,
    required this.toAddress,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = status.toLowerCase() == 'delivered';
    
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.h(12)),
      padding: EdgeInsets.all(Dimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(16)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job ID - $jobId',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(2)),
                    Text(
                      'Assign Date: $assignDate',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: Dimensions.h(30),
                color: AppColors.greyColor.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: Dimensions.w(12)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.h(2)),
                  Text(
                    status,
                    style: AppTextStyles.caption.copyWith(
                      color: isDelivered ? AppColors.successColor : AppColors.redColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(16)),
          Row(
            children: [
              Expanded(
                child: Text(
                  fromAddress,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(12)),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.greyColor,
                  size: Dimensions.rs(16),
                ),
              ),
              Expanded(
                child: Text(
                  toAddress,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimaryColor,
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
