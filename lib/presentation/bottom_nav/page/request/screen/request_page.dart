import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/presentation/bottom_nav/page/request/controller/request_controller.dart';
import 'package:westchester/presentation/bottom_nav/page/request/model/request_model.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final RequestController controller = Get.put(RequestController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.fetchRequests(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header with stat card ───────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.whiteColor,
              padding: EdgeInsets.fromLTRB(
                Dimensions.w(16),
                Dimensions.h(16),
                Dimensions.w(16),
                Dimensions.h(12),
              ),
              child: Column(
                children: [
                  // Stat card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.h(16),
                      horizontal: Dimensions.w(16),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(Dimensions.r(12)),
                    ),
                    child: Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pending Request',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondaryColor,
                                  ),
                                ),
                                SizedBox(height: Dimensions.h(6)),
                                Text(
                                  '${controller.pendingCount.value}',
                                  style: AppTextStyles.displayNumberSmall
                                      .copyWith(
                                        color: AppColors.textPrimaryColor,
                                        fontSize: Dimensions.fs(28),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: Dimensions.h(40),
                            color: AppColors.greyColor.withOpacity(0.3),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimensions.w(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Accepted',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondaryColor,
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.h(6)),
                                  Text(
                                    '${controller.acceptedCount.value}',
                                    style: AppTextStyles.displayNumberSmall
                                        .copyWith(
                                          color: AppColors.textPrimaryColor,
                                          fontSize: Dimensions.fs(28),
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  SizedBox(height: Dimensions.h(12)),

                  // Filters row
                  Obx(() {
                    // Map display strings to API values
                    String filterDisplay = 'All Request';
                    if (controller.selectedType.value == 'pending')
                      filterDisplay = 'Pending';
                    if (controller.selectedType.value == 'accepted')
                      filterDisplay = 'Accepted';

                    String monthDisplay = 'This Month';
                    final currentMonth = DateTime.now().month;
                    if (controller.selectedMonth.value == currentMonth - 1) {
                      monthDisplay = 'Last Month';
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: _DropdownFilter(
                            value: filterDisplay,
                            items: const ['All Request', 'Pending', 'Accepted'],
                            onChanged: (v) {
                              if (v == 'All Request')
                                controller.updateTypeFilter('all');
                              if (v == 'Pending')
                                controller.updateTypeFilter('pending');
                              if (v == 'Accepted')
                                controller.updateTypeFilter('accepted');
                            },
                          ),
                        ),
                        SizedBox(width: Dimensions.w(10)),
                        Expanded(
                          child: _DropdownFilter(
                            value: monthDisplay,
                            items: const ['This Month', 'Last Month'],
                            onChanged: (v) {
                              final now = DateTime.now();
                              if (v == 'This Month') {
                                controller.updateMonthFilter(
                                  now.month,
                                  now.year,
                                );
                              } else if (v == 'Last Month') {
                                var m = now.month - 1;
                                var y = now.year;
                                if (m == 0) {
                                  m = 12;
                                  y--;
                                }
                                controller.updateMonthFilter(m, y);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // ── List ───────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.requestsList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.requestsList.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: Dimensions.h(400),
                        alignment: Alignment.center,
                        child: Text(
                          'No requests found',
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.textSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final keys = controller.groupedRequests.keys.toList();

                return RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.w(16),
                      vertical: Dimensions.h(12),
                    ),
                    itemCount: keys.length + 1,
                    itemBuilder: (_, index) {
                      if (index == keys.length) {
                        return Obx(() {
                          if (controller.isFetchingMore.value) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.h(20),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        });
                      }

                      final dateStr = keys[index];
                      final items = controller.groupedRequests[dateStr]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.h(10),
                            ),
                            child: Text(
                              dateStr,
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          ...List.generate(items.length, (i) {
                            final request = items[i];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: Dimensions.h(12),
                              ),
                              child: _RequestCard(
                                request: request,
                                onAccept: () =>
                                    controller.acceptRequest(request.sId ?? ''),
                                onReject: () =>
                                    controller.rejectRequest(request.sId ?? ''),
                                onViewDetails: () => Get.toNamed(
                                  RoutePath.jobDetails,
                                  arguments: {
                                    'id': request.sId,
                                    'isAccepted': request.isAccepted ?? false,
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dropdown Filter ──────────────────────────────────────────────────────
class _DropdownFilter extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownFilter({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(12)),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(Dimensions.r(30)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textPrimaryColor,
            size: Dimensions.rs(18),
          ),
          style: AppTextStyles.bodyText.copyWith(
            color: AppColors.textPrimaryColor,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── Request Card ─────────────────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final Data request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onViewDetails;

  const _RequestCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Show Accept/Reject only if UNASSIGNED or ASSIGNED (and not already accepted)
    // Actually typically if it is assigned to this driver it's ASSIGNED.
    final bool showAcceptReject =
        request.status == 'ASSIGNED' || request.status == 'UNASSIGNED';
    final bool isAccepted = request.isAccepted == true;

    return Container(
      padding: EdgeInsets.all(Dimensions.w(14)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(12)),
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
          // Header info
          Row(
            children: [
              Text(
                request.orderNumber ?? '#N/A',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(12)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pick-up
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PICK-UP LOCATION',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.greyColor,
                        fontSize: Dimensions.fs(9),
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(6)),
                    Text(
                      request.pickupAddress ?? 'Unknown Address',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontSize: Dimensions.fs(12),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimensions.h(12)),
                child: Icon(
                  Icons.arrow_forward,
                  size: Dimensions.rs(16),
                  color: AppColors.textPrimaryColor,
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
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(6)),
                    Text(
                      request.dropoffAddress ?? 'Unknown Address',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontSize: Dimensions.fs(12),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.h(14)),
          Row(
            children: [
              if (showAcceptReject && !isAccepted) ...[
                // Accept Button
                Expanded(
                  child: GestureDetector(
                    onTap: onAccept,
                    child: Container(
                      height: Dimensions.h(38),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.r(30)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Accept',
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: Dimensions.fs(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.w(10)),
                // Reject Button
                Expanded(
                  child: GestureDetector(
                    onTap: onReject,
                    child: Container(
                      height: Dimensions.h(38),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(Dimensions.r(30)),
                        border: Border.all(
                          color: AppColors.redColor,
                          width: 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Reject',
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: AppColors.redColor,
                          fontSize: Dimensions.fs(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.w(10)),
              ] else if (isAccepted) ...[
                // Accepted — same filled style as Accept for consistency
                Expanded(
                  child: Container(
                    height: Dimensions.h(38),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.r(30)),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.whiteColor,
                          size: Dimensions.rs(14),
                        ),
                        SizedBox(width: Dimensions.w(4)),
                        Text(
                          'Accepted',
                          style: AppTextStyles.buttonSmall.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: Dimensions.fs(13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.w(10)),
              ],

              // View Details Button (Always visible)
              Expanded(
                child: GestureDetector(
                  onTap: onViewDetails,
                  child: Container(
                    height: Dimensions.h(38),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(Dimensions.r(30)),
                      border: Border.all(
                        color: AppColors.greyColor.withOpacity(0.35),
                        width: 1.2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'View Details',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.fs(13),
                      ),
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
