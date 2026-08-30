import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../core/responsive_layout/dimensions.dart';
import '../../../widget/app_loading.dart';
import '../../../widget/app_empty_state.dart';
import '../controller/my_map_controller.dart';
import '../model/my_map_model.dart';
import '../widget/pickup_widget.dart';
import '../widget/delivery_widget.dart';

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
                  Obx(() => GoogleMap(
                    onMapCreated: controller.onMapCreated,
                    initialCameraPosition: controller.cameraPosition.value,
                    markers: controller.markers.toSet(),
                    polylines: controller.polylines.toSet(),
                    // ── Location ─────────────────────────────────
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    // ── UI Controls ───────────────────────────
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: true,
                    compassEnabled: true,
                    // ── Gestures ───────────────────────────────
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    // ── Map Features ──────────────────────────
                    trafficEnabled: true,
                    buildingsEnabled: true,
                    indoorViewEnabled: true,
                    onTap: (_) => controller.clearSelection(),
                  )),

                  // ── Zoom + My Location FAB (Right Side) ──────
                  Positioned(
                    top: Dimensions.h(16),
                    right: Dimensions.w(16),
                    child: Column(
                      children: [
                        // My Location button
                        _MapControlButton(
                          icon: Icons.my_location_rounded,
                          onTap: controller.goToMyLocation,
                          tooltip: 'My Location',
                        ),
                        SizedBox(height: Dimensions.h(8)),
                        // Zoom In
                        _MapControlButton(
                          icon: Icons.add_rounded,
                          onTap: controller.zoomIn,
                          tooltip: 'Zoom In',
                        ),
                        SizedBox(height: Dimensions.h(4)),
                        // Zoom Out
                        _MapControlButton(
                          icon: Icons.remove_rounded,
                          onTap: controller.zoomOut,
                          tooltip: 'Zoom Out',
                        ),
                      ],
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
                        child: AppEmptyState(
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
                                label: 'All',
                                color: AppColors.textPrimaryColor,
                                isSelected:
                                    controller.activeFilter.value ==
                                    MapFilter.all,
                                onTap: () =>
                                    controller.setFilter(MapFilter.all),
                              ),
                              SizedBox(width: Dimensions.w(8)),
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

                  // ── Selected Delivery Bottom Sheet ──────────
                  Obx(() {
                    final delivery = controller.selectedDelivery.value;
                    if (delivery == null) return const SizedBox.shrink();

                    final isPickupFilter =
                        controller.activeFilter.value == MapFilter.pickup;

                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: isPickupFilter
                          ? PickupInfoCard(
                              delivery: delivery,
                              onClose: controller.clearSelection,
                            )
                          : DeliveryInfoCard(
                              delivery: delivery,
                              onClose: controller.clearSelection,
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
//  Map Control Button (Zoom / My Location)
// ─────────────────────────────────────────────────────────────────────────────

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Dimensions.w(40),
          height: Dimensions.w(40),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(Dimensions.r(10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: Dimensions.rs(20),
            color: AppColors.textPrimaryColor,
          ),
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
