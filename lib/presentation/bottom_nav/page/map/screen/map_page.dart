import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/presentation/bottom_nav/page/map/controller/open_map_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final OpenMapController _controller;
  late final Map<String, dynamic> _args;
  late final bool _isJobDetailsMap;
  late final String? _pickupAddress;
  late final String? _deliveryAddress;

  @override
  void initState() {
    super.initState();
    // Always delete old instance and create a fresh one
    Get.delete<OpenMapController>(force: true);
    _controller = Get.put(OpenMapController());

    _args = (Get.arguments as Map<String, dynamic>?) ?? {};
    _isJobDetailsMap = _args['isJobDetailsMap'] == true;
    _pickupAddress = _args['pickupAddress'] as String?;
    _deliveryAddress = _args['deliveryAddress'] as String?;

    // Pass args into controller
    _controller.init(args: _args);
  }

  @override
  void dispose() {
    Get.delete<OpenMapController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final pickup = _controller.pickupLatLng.value;
          final delivery = _controller.deliveryLatLng.value;

          final CameraPosition initialPos;
          if (pickup != null && delivery != null) {
            initialPos = CameraPosition(
              target: LatLng(
                (pickup.latitude + delivery.latitude) / 2,
                (pickup.longitude + delivery.longitude) / 2,
              ),
              zoom: 11,
            );
          } else {
            initialPos = const CameraPosition(
              target: LatLng(41.033986, -73.762910),
              zoom: 12,
            );
          }

          return Column(
            children: [
              // ── App Bar ────────────────────────────────────────────
              Container(
                color: AppColors.whiteColor,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(20),
                  vertical: Dimensions.h(16),
                ),
                child: Row(
                  children: [
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
                    Text(
                      'Map',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Map Area ───────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    // Google Map — reactive to markers & polylines
                    Obx(() {
                      final currentMarkers = _controller.markers.toSet();
                      final currentPolylines = _controller.polylines.toSet();

                      return GoogleMap(
                        initialCameraPosition: initialPos,
                        onMapCreated: (mapCtrl) {
                          _controller.onMapCreated(mapCtrl);
                        },
                        markers: currentMarkers,
                        polylines: currentPolylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                      );
                    }),

                    // Legend overlay
                    Positioned(
                      bottom: Dimensions.h(20),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Obx(() {
                          final dist = _controller.distanceText.value;
                          final dur = _controller.durationText.value;
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.w(20),
                              vertical: Dimensions.h(12),
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
                                const _LegendItem(
                                  color: AppColors.primaryColor,
                                  label: 'Pickup',
                                ),
                                SizedBox(width: Dimensions.w(16)),
                                const _LegendItem(
                                  color: AppColors.redColor,
                                  label: 'Delivery',
                                ),
                                if (dist.isNotEmpty) ...[
                                  SizedBox(width: Dimensions.w(16)),
                                  Container(
                                    width: 1,
                                    height: Dimensions.h(18),
                                    color: AppColors.dividerColor,
                                  ),
                                  SizedBox(width: Dimensions.w(16)),
                                  Icon(
                                    Icons.straighten_rounded,
                                    size: Dimensions.rs(14),
                                    color: AppColors.textSecondaryColor,
                                  ),
                                  SizedBox(width: Dimensions.w(4)),
                                  Text(
                                    dist,
                                    style: AppTextStyles.bodyText.copyWith(
                                      color: AppColors.textPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimensions.fs(12),
                                    ),
                                  ),
                                ],
                                if (dur.isNotEmpty) ...[
                                  SizedBox(width: Dimensions.w(10)),
                                  Text(
                                    '· $dur',
                                    style: AppTextStyles.bodyText.copyWith(
                                      color: AppColors.textSecondaryColor,
                                      fontSize: Dimensions.fs(11),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: _isJobDetailsMap
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
                      pickupAddress: _pickupAddress ?? '',
                      deliveryAddress: _deliveryAddress ?? '',
                    ),
                  ),
                );
              },
              icon: Center(
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.whiteColor,
                  size: Dimensions.rs(24),
                ),
              ),
              label: const Text(''),
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
                      'PICK-UP LOCATION',
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
              // Arrow
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

  @override
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
