import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/presentation/job_history/controller/job_history_controller.dart';
import 'package:westchester/presentation/job_history/model/job_history_model.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_loading.dart';
import 'package:westchester/widget/app_empty_state.dart';
import '../widget/job_history_stat_card.dart';
import '../widget/job_history_card.dart';

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const AppLoading(isFullPage: true);
        }

        return RefreshIndicator(
          onRefresh: controller.fetchHistory,
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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

                // ── Stat Card ─────────────────────────────────────────────
                Obx(() {
                  final s = controller.summary.value;
                  return JobHistoryStatCard(
                    month: '',
                    filter: controller.selectedFilter.value,
                    assigned: s?.totalAssigned ?? 0,
                    delivery: s?.totalDelivery ?? 0,
                    canceled: s?.totalCanceled ?? 0,
                    onFilterChanged: (value) =>
                        controller.selectedFilter.value = value,
                  );
                }),

                SizedBox(height: Dimensions.h(24)),

                // ── History List ──────────────────────────────────────────
                Obx(() {
                  if (controller.historyList.isEmpty) {
                    return SizedBox(
                      height: 300,
                      child: AppEmptyState(
                        icon: Icons.history_rounded,
                        title: 'No History Found',
                        subtitle: 'Your job history will appear here once you complete deliveries.',
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.historyList.map((Data group) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateHeader(group.date ?? ''),
                          ...((group.jobs ?? []).map((job) => JobHistoryCard(
                                jobId: job.orderNumber ?? '-',
                                assignDate: _formatDate(job.assignDate),
                                status: _formatStatus(job.status),
                                fromAddress: job.pickupAddress ?? '-',
                                toAddress: job.dropoffAddress ?? '-',
                              ))),
                          SizedBox(height: Dimensions.h(8)),
                        ],
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        );
      }),
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

  /// Converts ISO date string to readable format e.g. "August 5, 2026"
  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '-';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  /// Converts status like "DELIVERED" → "Delivered"
  String _formatStatus(String? status) {
    if (status == null || status.isEmpty) return '-';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}
