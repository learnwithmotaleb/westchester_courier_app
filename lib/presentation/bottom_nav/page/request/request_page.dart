import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';

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
            // ── Header ─────────────────────────────────────────────
            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(16),
              ),
              child: Row(
                children: [
                  _StatBadge(label: 'Pending Request', value: '4'),
                  SizedBox(width: Dimensions.w(12)),
                  _StatBadge(label: 'Accepted', value: '2'),
                ],
              ),
            ),

            // ── Filters ────────────────────────────────────────────
            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.only(
                left: Dimensions.w(16),
                right: Dimensions.w(16),
                bottom: Dimensions.h(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _DropdownFilter(
                      value: _selectedFilter,
                      items: const ['All Request', 'Pending', 'Accepted'],
                      onChanged: (v) => setState(() => _selectedFilter = v!),
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
            ),

            const Divider(height: 1, color: AppColors.dividerColor),

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
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.h(10)),
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
                          padding:
                              EdgeInsets.only(bottom: Dimensions.h(12)),
                          child: _RequestCard(
                            isAccepted:
                                group['items'][i]['accepted'] as bool,
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

// ── Stat Badge ───────────────────────────────────────────────────────────
class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.h(12),
          horizontal: Dimensions.w(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.lightGreyColor,
          borderRadius: BorderRadius.circular(Dimensions.r(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              style: AppTextStyles.displayNumberSmall.copyWith(
                color: AppColors.textPrimaryColor,
                fontSize: Dimensions.fs(28),
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
  const _DropdownFilter(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w(10)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(Dimensions.r(8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.primaryColor),
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
  const _RequestCard({required this.isAccepted});

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
                  onPressed: isAccepted ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAccepted
                        ? AppColors.primaryColor
                        : AppColors.whiteColor,
                    foregroundColor: isAccepted
                        ? AppColors.whiteColor
                        : AppColors.primaryColor,
                    side: BorderSide(
                      color: isAccepted
                          ? AppColors.primaryColor
                          : AppColors.borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(6)),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: Dimensions.h(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    isAccepted ? 'Accepted' : 'Accept',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: isAccepted
                          ? AppColors.whiteColor
                          : AppColors.primaryColor,
                    ),
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
