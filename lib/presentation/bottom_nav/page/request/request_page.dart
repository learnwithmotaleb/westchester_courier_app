import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/core/routes/route_path.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String _selectedFilter = 'All Request';
  String _selectedMonth = 'This Month';

  final List<Map<String, dynamic>> _requests = [
    {
      'date': 'July 24, 2026',
      'items': [
        {'accepted': false},
        {'accepted': true},
        {'accepted': true},
        {'accepted': false},
      ],
    },
    {
      'date': 'July 25, 2026',
      'items': [
        {'accepted': false},
        {'accepted': false},
      ],
    },
  ];

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
                    child: Row(
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
                                '4',
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
                                  '2',
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
                    ),
                  ),

                  SizedBox(height: Dimensions.h(12)),

                  // Filters row
                  Row(
                    children: [
                      Expanded(
                        child: _DropdownFilter(
                          value: _selectedFilter,
                          items: const ['All Request', 'Pending', 'Accepted'],
                          onChanged: (v) =>
                              setState(() => _selectedFilter = v!),
                        ),
                      ),
                      SizedBox(width: Dimensions.w(10)),
                      Expanded(
                        child: _DropdownFilter(
                          value: _selectedMonth,
                          items: const ['This Month', 'Last Month', 'All Time'],
                          onChanged: (v) => setState(() => _selectedMonth = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── List ───────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16),
                  vertical: Dimensions.h(12),
                ),
                itemCount: _requests.length,
                itemBuilder: (_, groupIndex) {
                  final group = _requests[groupIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.h(10),
                        ),
                        child: Text(
                          group['date'],
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ...List.generate(
                        (group['items'] as List).length,
                        (i) => Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.h(12)),
                          child: _RequestCard(
                            isAccepted: group['items'][i]['accepted'] as bool,
                            onViewDetails: () => Get.toNamed(
                              RoutePath.jobDetails,
                              arguments: {
                                'isAccepted':
                                    group['items'][i]['accepted'] as bool,
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
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
  final bool isAccepted;
  final VoidCallback? onViewDetails;
  const _RequestCard({required this.isAccepted, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
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
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(6)),
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
          SizedBox(height: Dimensions.h(14)),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isAccepted ? null : () {},
                  child: Container(
                    height: Dimensions.h(38),
                    decoration: BoxDecoration(
                      color: isAccepted
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(Dimensions.r(30)),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1.2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isAccepted ? 'Accepted' : 'Accept',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: isAccepted
                            ? AppColors.whiteColor
                            : AppColors.primaryColor,
                        fontSize: Dimensions.fs(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.w(10)),
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
