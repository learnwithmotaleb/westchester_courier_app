import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/service/google_map_services.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mapServices = Get.put(GoogleMapServices());

    // Check if opened from Job Details screen
    final args = Get.arguments as Map<String, dynamic>?;
    final bool isJobDetailsMap = args?['isJobDetailsMap'] == true;
    final LatLng? pickup = args?['pickup'] as LatLng?;
    final LatLng? delivery = args?['delivery'] as LatLng?;
    final String? pickupAddress = args?['pickupAddress'] as String?;
    final String? deliveryAddress = args?['deliveryAddress'] as String?;
    final List<Marker>? passedMarkers = args?['markers'] as List<Marker>?;
    final List<Polyline>? passedPolylines =
        args?['polylines'] as List<Polyline>?;

    CameraPosition initialPos = mapServices.initialCameraPosition.value;
    if (isJobDetailsMap && pickup != null && delivery != null) {
      initialPos = CameraPosition(
        target: LatLng(
          (pickup.latitude + delivery.latitude) / 2,
          (pickup.longitude + delivery.longitude) / 2,
        ),
        zoom: 10,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(20),
                vertical: Dimensions.h(16),
              ),
              child: Row(
                children: [
                  if (isJobDetailsMap) ...[
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.only(right: Dimensions.w(16)),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    'Map',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Map Area
            Expanded(
              child: Stack(
                children: [
                  // Actual Google Map
                  Obx(() {
                    // Read observables unconditionally to register them with Obx
                    final currentMarkers = mapServices.markers.toSet();
                    final currentPolylines = mapServices.polylines.toSet();

                    return GoogleMap(
                      initialCameraPosition: initialPos,
                      onMapCreated: (controller) {
                        mapServices.onMapCreated(controller);
                        if (isJobDetailsMap &&
                            pickup != null &&
                            delivery != null) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            controller.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                LatLngBounds(
                                  southwest: LatLng(
                                    pickup.latitude < delivery.latitude
                                        ? pickup.latitude
                                        : delivery.latitude,
                                    pickup.longitude < delivery.longitude
                                        ? pickup.longitude
                                        : delivery.longitude,
                                  ),
                                  northeast: LatLng(
                                    pickup.latitude > delivery.latitude
                                        ? pickup.latitude
                                        : delivery.latitude,
                                    pickup.longitude > delivery.longitude
                                        ? pickup.longitude
                                        : delivery.longitude,
                                  ),
                                ),
                                50,
                              ),
                            );
                          });
                        }
                      },
                      markers: isJobDetailsMap && passedMarkers != null
                          ? passedMarkers.toSet()
                          : currentMarkers,
                      polylines: isJobDetailsMap && passedPolylines != null
                          ? passedPolylines.toSet()
                          : currentPolylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                    );
                  }),

                  // Bottom Overlay
                  if (!isJobDetailsMap)
                    Positioned(
                      bottom: Dimensions.h(20),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(20),
                            vertical: Dimensions.h(10),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(
                              Dimensions.r(30),
                            ),
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
                              const _LegendItem(
                                color: AppColors.primaryColor,
                                label: 'Pickup',
                              ),
                              SizedBox(width: Dimensions.w(20)),
                              const _LegendItem(
                                color: AppColors.redColor,
                                label: 'Delivery',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isJobDetailsMap
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      left: Dimensions.w(20),
                      right: Dimensions.w(20),
                      bottom: Dimensions.h(20),
                    ),
                    child: _JobDetailsBottomCard(
                      pickupAddress: pickupAddress ?? '',
                      deliveryAddress: deliveryAddress ?? '',
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.info_outline_rounded,
                color: AppColors.whiteColor,
                size: Dimensions.rs(10),
              ),
              label: Text(
                'Show'
              ),
            )
          : null,
    );
  }
}

class _JobDetailsBottomCard extends StatelessWidget {
  final String pickupAddress;
  final String deliveryAddress;

  const _JobDetailsBottomCard({
    required this.pickupAddress,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(16),
        vertical: Dimensions.h(16),
      ),
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
          Row(
            children: [
              // Pickup Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PIC-UP LOCATION',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textSecondaryColor,
                        fontSize: Dimensions.fs(10),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: Dimensions.h(6)),
                    Text(
                      pickupAddress,
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
              // Arrow Indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w(12)),
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
                      deliveryAddress,
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
          SizedBox(height: Dimensions.h(20)),
          // View Details Button
          SizedBox(
            width: double.infinity,
            height: Dimensions.h(44),
            child: OutlinedButton(
              onPressed: () {
                Get.back(); // close bottom sheet
                Get.back(); // close map page
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

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Dimensions.w(12),
          height: Dimensions.w(12),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: Dimensions.w(6)),
        Text(
          label,
          style: AppTextStyles.bodyText.copyWith(
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
