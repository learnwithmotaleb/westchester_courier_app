import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../widget/app_loading.dart';
import '../../../widget/app_empty_state.dart';
import '../controller/my_map_controller.dart';
import '../model/my_map_model.dart';

class MyMapScreen extends StatefulWidget {
  const MyMapScreen({super.key});

  @override
  State<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  late final MyMapController controller;

  @override
  void initState() {
    super.initState();
    // Use Get.put to register the controller
    controller = Get.put(MyMapController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar (Custom for Tab) ──────────────────────────
            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Map',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? SizedBox(
                            width: Dimensions.w(20),
                            height: Dimensions.w(20),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : IconButton(
                            onPressed: controller.loadMyMap,
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: AppColors.primaryColor,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                  ),
                ],
              ),
            ),

            // ── Map + Content ─────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  // ── Google Map ────────────────────────────────
                  Obx(
                    () => GoogleMap(
                      onMapCreated: controller.onMapCreated,
                      initialCameraPosition: controller.cameraPosition.value,
                      markers: controller.markers.toSet(),
                      polylines: controller.polylines.toSet(),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      onTap: (_) => controller.clearSelection(),
                    ),
                  ),

                  // ── Loading & Empty States ──────────────────────
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.currentPoints.isEmpty) {
                      return Container(
                        color: Colors.white.withOpacity(0.8),
                        child: const AppLoading(
                          isFullPage: true,
                          message: 'Loading map...',
                        ),
                      );
                    }
                    if (controller.hasError.value &&
                        controller.currentPoints.isEmpty) {
                      return Container(
                        color: Colors.white.withOpacity(0.8),
                        child: AppEmptyState(
                          icon: Icons.map_outlined,
                          title: 'Could not load map',
                          subtitle: controller.errorMessage.value,
                          action: TextButton(
                            onPressed: controller.loadMyMap,
                            child: const Text('Try Again'),
                          ),
                        ),
                      );
                    }
                    if (controller.currentPoints.isEmpty &&
                        !controller.isLoading.value) {
                      return Container(
                        color: Colors.white.withOpacity(0.8),
                        child:  AppEmptyState(
                          title: 'Not Assign Pickup And Delivery',
                          subtitle:
                              'There are no active points for the selected filter.',
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // ── Toggle Buttons (Bottom Center) ────────────
                  Positioned(
                    bottom: Dimensions.h(24),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Obx(() {
                        // If a delivery is selected, hide toggles
                        if (controller.selectedDelivery.value != null) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(6),
                            vertical: Dimensions.h(6),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackColor.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ToggleButton(
                                label: 'Pickup',
                                color: AppColors.primaryColor,
                                isSelected:
                                    controller.activeFilter.value ==
                                    MapFilter.pickup,
                                onTap: () =>
                                    controller.setFilter(MapFilter.pickup),
                              ),
                              SizedBox(width: Dimensions.w(8)),
                              _ToggleButton(
                                label: 'Delivery',
                                color: AppColors.redColor,
                                isSelected:
                                    controller.activeFilter.value ==
                                    MapFilter.delivery,
                                onTap: () =>
                                    controller.setFilter(MapFilter.delivery),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  // ── Selected Delivery Bottom Sheet ────────────
                  Obx(() {
                    final delivery = controller.selectedDelivery.value;
                    if (delivery == null) return const SizedBox.shrink();
                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _DeliveryBottomCard(
                        delivery: delivery,
                        controller: controller,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Toggle Button Widget
// ─────────────────────────────────────────────────────────────────────────────

class _ToggleButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(16),
          vertical: Dimensions.h(10),
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimensions.w(12),
              height: Dimensions.w(12),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: Dimensions.w(8)),
            Text(
              label,
              style: AppTextStyles.bodyText.copyWith(
                color: isSelected ? color : AppColors.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Delivery Bottom Card (slides up when a marker is tapped)
// ─────────────────────────────────────────────────────────────────────────────

class _DeliveryBottomCard extends StatelessWidget {
  final MyMapFullDelivery delivery;
  final MyMapController controller;

  const _DeliveryBottomCard({required this.delivery, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(16),
        vertical: Dimensions.h(16),
      ),
      margin: EdgeInsets.all(Dimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle/Close button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: controller.clearSelection,
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.greyColor,
                size: 24,
              ),
            ),
          ),

          SizedBox(height: Dimensions.h(8)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pickup Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PICK-UP LOCATION',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textSecondaryColor,
                        fontSize: Dimensions.fs(10),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(6)),
                    Text(
                      delivery.pickupAddress ?? 'Not provided',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontSize: Dimensions.fs(12),
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(12),
                  vertical: Dimensions.h(12),
                ),
                child: Icon(
                  Icons.arrow_right_alt_rounded,
                  color: AppColors.textPrimaryColor,
                  size: Dimensions.rs(24),
                ),
              ),
              // Delivery Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DELIVERY LOCATION',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textSecondaryColor,
                        fontSize: Dimensions.fs(10),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(6)),
                    Text(
                      delivery.dropoffAddress ?? 'Not provided',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontSize: Dimensions.fs(12),
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Distance/Duration Info if available
          Obx(() {
            if (controller.distanceText.value.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: Dimensions.h(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.straighten_rounded,
                      size: Dimensions.rs(14),
                      color: AppColors.textSecondaryColor,
                    ),
                    SizedBox(width: Dimensions.w(4)),
                    Text(
                      controller.distanceText.value,
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fs(12),
                      ),
                    ),
                    SizedBox(width: Dimensions.w(10)),
                    Text(
                      '· ${controller.durationText.value}',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textSecondaryColor,
                        fontSize: Dimensions.fs(11),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          SizedBox(height: Dimensions.h(20)),

          SizedBox(
            width: double.infinity,
            height: Dimensions.h(44),
            child: OutlinedButton(
              onPressed: () {
                if (delivery.id != null) {
                  Get.toNamed(
                    RoutePath.jobDetails,
                    arguments: {'id': delivery.id},
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.dividerColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
              ),
              child: Text(
                'View Details',
                style: AppTextStyles.buttonSmall.copyWith(
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
