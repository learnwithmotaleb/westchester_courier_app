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
    // Initialize GoogleMapServices
    final mapServices = Get.put(GoogleMapServices());

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
                  Text(
                    'Map',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primaryColor,
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
                    return GoogleMap(
                      initialCameraPosition: mapServices.initialCameraPosition.value,
                      onMapCreated: mapServices.onMapCreated,
                      markers: mapServices.markers,
                      polylines: mapServices.polylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                    );
                  }),

                  // Floating Action Buttons for testing map services (optional, can be removed)
                  Positioned(
                    top: Dimensions.h(20),
                    right: Dimensions.w(20),
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: 'add_marker_btn',
                          mini: true,
                          backgroundColor: AppColors.whiteColor,
                          onPressed: () {
                            mapServices.addMarker(
                              id: 'test_pickup',
                              position: const LatLng(41.033986, -73.762910),
                              title: 'Pickup Location',
                              hue: BitmapDescriptor.hueBlue,
                            );
                            mapServices.animateCameraTo(const LatLng(41.033986, -73.762910));
                          },
                          child: Icon(Icons.add_location_alt, color: AppColors.primaryColor),
                        ),
                        SizedBox(height: Dimensions.h(10)),
                        FloatingActionButton(
                          heroTag: 'clear_marker_btn',
                          mini: true,
                          backgroundColor: AppColors.whiteColor,
                          onPressed: mapServices.clearMarkers,
                          child: Icon(Icons.clear, color: AppColors.redColor),
                        ),
                      ],
                    ),
                  ),

                  // Legend at bottom center
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
                          borderRadius: BorderRadius.circular(Dimensions.r(30)),
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
                            _LegendItem(
                              color: AppColors.primaryColor,
                              label: 'Pickup',
                            ),
                            SizedBox(width: Dimensions.w(20)),
                            _LegendItem(
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
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Dimensions.w(12),
          height: Dimensions.w(12),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
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
