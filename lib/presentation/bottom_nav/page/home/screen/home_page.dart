import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/presentation/bottom_nav/page/home/controller/home_controller.dart';
import 'package:westchester/presentation/bottom_nav/page/home/model/my_delivery_model.dart';
import 'package:westchester/presentation/bottom_nav/page/map/screen/map_page.dart';
import 'package:westchester/presentation/notification/controller/notification_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final notifController = Get.put(NotificationController(), permanent: true);

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
                  IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryColor,
                      size: Dimensions.rs(24),
                    ),
                    onPressed: () {},
                  ),
                  Obx(() {
                    return Badge(
                      isLabelVisible: notifController.unreadCount.value > 0,
                      label: Text(notifController.unreadCount.value.toString()),
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primaryColor,
                          size: Dimensions.rs(24),
                        ),
                        onPressed: () {
                          Get.toNamed(RoutePath.notification);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(16),
                    vertical: Dimensions.h(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Stats Card ──────────────────────────────────
                      Obx(() {
                        final isLoading = controller.isLoading.value;
                        final hasError = controller.hasError.value;

                        return Container(
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
                            borderRadius: BorderRadius.circular(
                              Dimensions.r(14),
                            ),
                          ),
                          child: isLoading
                              ? _StatsShimmer()
                              : hasError
                              ? _StatsError(onRetry: controller.fetchStats)
                              : Row(
                                  children: [
                                    _StatItem(
                                      label: 'Pending Task',
                                      value: controller.pendingTask,
                                    ),
                                    Container(
                                      height: Dimensions.h(40),
                                      width: 1,
                                      color: AppColors.whiteColor.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                    _StatItem(
                                      label: 'Completed Task',
                                      value: controller.completedTask,
                                    ),
                                  ],
                                ),
                        );
                      }),

                      SizedBox(height: Dimensions.h(20)),

                      // ── Section Title ───────────────────────────────
                      Text(
                        "Your Tasks",
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: Dimensions.h(12)),

                      // ── Task List ───────────────────────────────────
                      Obx(() {
                        if (controller.isDeliveriesLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        }

                        if (controller.hasDeliveriesError.value) {
                          return Center(
                            child: Text(
                              'Failed to load deliveries.',
                              style: AppTextStyles.bodyText,
                            ),
                          );
                        }

                        if (controller.deliveriesList.isEmpty) {
                          return Center(
                            child: Text(
                              'No tasks found.',
                              style: AppTextStyles.bodyText,
                            ),
                          );
                        }

                        return Column(
                          children: controller.deliveriesList
                              .map(
                                (data) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Dimensions.h(12),
                                  ),
                                  child: _TaskCard(data: data),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats Loading Shimmer ────────────────────────────────────────────────────
class _StatsShimmer extends StatefulWidget {
  @override
  State<_StatsShimmer> createState() => _StatsShimmerState();
}

class _StatsShimmerState extends State<_StatsShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.25,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _shimmerBox({required double w, required double h}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: _anim.value),
          borderRadius: BorderRadius.circular(Dimensions.r(6)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _shimmerBox(w: Dimensions.w(80), h: Dimensions.h(12)),
              SizedBox(height: Dimensions.h(8)),
              _shimmerBox(w: Dimensions.w(50), h: Dimensions.h(28)),
            ],
          ),
        ),
        Container(
          height: Dimensions.h(40),
          width: 1,
          color: AppColors.whiteColor.withValues(alpha: 0.3),
        ),
        Expanded(
          child: Column(
            children: [
              _shimmerBox(w: Dimensions.w(90), h: Dimensions.h(12)),
              SizedBox(height: Dimensions.h(8)),
              _shimmerBox(w: Dimensions.w(50), h: Dimensions.h(28)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Stats Error State ────────────────────────────────────────────────────────
class _StatsError extends StatelessWidget {
  final VoidCallback onRetry;
  const _StatsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off_rounded,
          color: AppColors.whiteColor.withValues(alpha: 0.7),
          size: Dimensions.rs(18),
        ),
        SizedBox(width: Dimensions.w(8)),
        Text(
          'Failed to load',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.whiteColor.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(width: Dimensions.w(12)),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.w(12),
              vertical: Dimensions.h(6),
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.r(20)),
              border: Border.all(
                color: AppColors.whiteColor.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              'Retry',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
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
              color: AppColors.whiteColor.withValues(alpha: 0.8),
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
  final DeliveryData data;
  const _TaskCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.w(14)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
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
                      data.pickupAddress ?? 'Unknown',
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
                      data.dropoffAddress ?? 'Unknown',
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
          SizedBox(height: Dimensions.h(12)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const MapPage(),
                      arguments: {'id': data.id ?? ''},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(6)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.h(8)),
                    elevation: 0,
                  ),
                  child: Text('Open Map', style: AppTextStyles.buttonSmall),
                ),
              ),
              SizedBox(width: Dimensions.w(10)),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed(
                      RoutePath.jobDetails,
                      arguments: {'isAccepted': true},
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r(6)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.h(8)),
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
