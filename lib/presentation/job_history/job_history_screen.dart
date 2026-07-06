import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/presentation/job_history/controller/job_history_controller.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'widget/job_history_stat_card.dart';
import 'widget/job_history_card.dart';

class JobHistoryScreen extends GetView<JobHistoryController> {
  const JobHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: 'History',
        showBack: true,
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        onBack: () => Get.back(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(20),
          vertical: Dimensions.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job History',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
            SizedBox(height: Dimensions.h(4)),
            Text(
              'View your completed, canceled, and ongoing delivery jobs in one place.',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            ),
            SizedBox(height: Dimensions.h(24)),

            Obx(
              () => JobHistoryStatCard(
                month: 'June 2026',
                filter: controller.selectedFilter.value,
                assigned: 16,
                delivery: 142,
                canceled: 16,
                onFilterChanged: (value) => controller.selectedFilter.value = value,
              ),
            ),

            SizedBox(height: Dimensions.h(24)),

            _buildDateHeader('July 24, 2026'),
            const JobHistoryCard(
              jobId: '844456568',
              assignDate: 'July 16, 2026',
              status: 'Delivered',
              fromAddress: '1428 Atlantic Ave,\nBrooklyn, NY 11216',
              toAddress: '151 Newark Ave, Jersey\nCity, NJ 07302',
            ),
            const JobHistoryCard(
              jobId: '844456568',
              assignDate: 'July 16, 2026',
              status: 'Canceled',
              fromAddress: '1428 Atlantic Ave,\nBrooklyn, NY 11216',
              toAddress: '151 Newark Ave, Jersey\nCity, NJ 07302',
            ),
            const JobHistoryCard(
              jobId: '844456568',
              assignDate: 'July 16, 2026',
              status: 'Delivered',
              fromAddress: '1428 Atlantic Ave,\nBrooklyn, NY 11216',
              toAddress: '151 Newark Ave, Jersey\nCity, NJ 07302',
            ),

            SizedBox(height: Dimensions.h(16)),
            _buildDateHeader('July 22, 2026'),
            const JobHistoryCard(
              jobId: '844456568',
              assignDate: 'July 16, 2026',
              status: 'Delivered',
              fromAddress: '1428 Atlantic Ave,\nBrooklyn, NY 11216',
              toAddress: '151 Newark Ave, Jersey\nCity, NJ 07302',
            ),

            SizedBox(height: Dimensions.h(16)),
            _buildDateHeader('July 21, 2026'),
            const JobHistoryCard(
              jobId: '844456568',
              assignDate: 'July 16, 2026',
              status: 'Delivered',
              fromAddress: '1428 Atlantic Ave,\nBrooklyn, NY 11216',
              toAddress: '151 Newark Ave, Jersey\nCity, NJ 07302',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h(12)),
      child: Text(
        date,
        style: AppTextStyles.h4.copyWith(
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
