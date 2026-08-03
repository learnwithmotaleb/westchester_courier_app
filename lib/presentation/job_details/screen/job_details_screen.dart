import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/presentation/bottom_nav/page/map/map_page.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/widget/app_alert.dart';
import 'package:westchester/core/routes/route_path.dart';
import '../controller/job_details_controller.dart';
import '../widget/job_detail_info_row.dart';

class JobDetailsScreen extends GetView<JobDetailsController> {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: CommonAppBar(
        title: 'Job Details',
        showBack: true,
        backgroundColor: AppColors.whiteColor,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(16),
                  vertical: Dimensions.h(16),
                ),
                child: Column(
                  children: [
                    // Stepper progress indicator
                    Obx(
                      () =>
                          _StepperWidget(currentStep: controller.rxStep.value),
                    ),

                    SizedBox(height: Dimensions.h(20)),

                    // Parcel Details
                    _SectionCard(
                      title: 'PARCEL DETAILS',
                      color: AppColors.primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JobDetailInfoRow(
                            label: 'ITEMS count',
                            value: '3 Items',
                            icon: Icons.inventory_2_outlined,
                          ),
                          Divider(color: AppColors.dividerColor, height: 1),
                          JobDetailInfoRow(
                            label: 'WEIGHT',
                            value: '12.4 Kilograms',
                            icon: Icons.scale_outlined,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.h(12)),

                    // Pickup Location Section
                    _SectionCard(
                      title: 'PIC-UP LOCATION',
                      color: AppColors.primaryColor,
                      child: Column(
                        children: [
                          JobDetailInfoRow(
                            label: 'NAME',
                            value: 'Heights Fitness JC Downtown',
                            icon: Icons.business_outlined,
                          ),
                          Divider(color: AppColors.dividerColor, height: 1),
                          JobDetailInfoRow(
                            label: 'ADDRESS',
                            value: '151 Newark Ave, Jersey City, NJ 07302',
                            icon: Icons.location_on_outlined,
                          ),
                          Divider(color: AppColors.dividerColor, height: 1),
                          JobDetailInfoRow(
                            label: 'PHONE',
                            value: '(671) 555-0110',
                            icon: Icons.phone_outlined,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.h(12)),

                    // Delivery Location Section
                    _SectionCard(
                      title: 'DELIVERY LOCATION',
                      color: AppColors.redColor,
                      child: Column(
                        children: [
                          JobDetailInfoRow(
                            label: 'NAME',
                            value: 'Midnight Tint',
                            icon: Icons.business_outlined,
                          ),
                          Divider(color: AppColors.dividerColor, height: 1),
                          JobDetailInfoRow(
                            label: 'ADDRESS',
                            value: '1426 Atlantic Ave, Brooklyn, NY 11216',
                            icon: Icons.location_on_outlined,
                          ),
                          Divider(color: AppColors.dividerColor, height: 1),
                          JobDetailInfoRow(
                            label: 'PHONE',
                            value: '(252) 555-0126',
                            icon: Icons.phone_outlined,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.h(16)),

                    // ── Real Google Map ──────────────────────────────────
                    Obx(() {
                      final isLoading = controller.isMapLoading.value;
                      final pickup = controller.pickupLatLng.value;
                      final delivery = controller.deliveryLatLng.value;

                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const MapPage(),
                            arguments: {
                              'isJobDetailsMap': true,
                              'pickup': pickup,
                              'delivery': delivery,
                              'pickupAddress':
                                  JobDetailsController.pickupAddress,
                              'deliveryAddress':
                                  JobDetailsController.deliveryAddress,
                              'markers': controller.markers.toList(),
                              'polylines': controller.polylines.toList(),
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.r(12)),
                          child: SizedBox(
                            width: double.infinity,
                            height: Dimensions.h(180),
                            child: Stack(
                              children: [
                                // Loading shimmer
                                if (isLoading)
                                  Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                else
                                  GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        (pickup.latitude + delivery.latitude) /
                                            2,
                                        (pickup.longitude +
                                                delivery.longitude) /
                                            2,
                                      ),
                                      zoom: 10,
                                    ),
                                    onMapCreated: controller.onMapCreated,
                                    markers: controller.markers,
                                    polylines: controller.polylines,
                                    zoomControlsEnabled: false,
                                    myLocationButtonEnabled: false,
                                    scrollGesturesEnabled: true,
                                    zoomGesturesEnabled: true,
                                    rotateGesturesEnabled: false,
                                    tiltGesturesEnabled: false,
                                  ),

                                // Fullscreen button
                                Positioned(
                                  top: Dimensions.h(10),
                                  right: Dimensions.w(10),
                                  child: Container(
                                    padding: EdgeInsets.all(Dimensions.w(6)),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.r(6),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.blackColor
                                              .withOpacity(0.12),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.fullscreen_rounded,
                                      size: Dimensions.rs(18),
                                      color: AppColors.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom action buttons depending on current steps
            Padding(
              padding: EdgeInsets.fromLTRB(
                Dimensions.w(16),
                Dimensions.h(8),
                Dimensions.w(16),
                Dimensions.h(16),
              ),
              child: Obx(() {
                final step = controller.rxStep.value;

                if (step == 0) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AppAlerts.actionConfirm(
                                  title: 'Confirmation',
                                  message:
                                      'Are you sure you want to reject the Delivery Request?',
                                  confirmLabel: 'Reject',
                                  onConfirm: () => Get.back(),
                                );
                              },
                              child: Container(
                                height: Dimensions.h(48),
                                decoration: BoxDecoration(
                                  color: AppColors.redColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.r(12),
                                  ),
                                  border: Border.all(
                                    color: AppColors.redColor,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Reject Request',
                                  style: AppTextStyles.buttonSmall.copyWith(
                                    color: AppColors.redColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.h(8)),
                      _ReportIssueButton(),
                      SizedBox(height: Dimensions.h(8)),
                      AppButton(
                        label: 'Accept Request',
                        onPressed: controller.acceptRequest,
                        backgroundColor: AppColors.successColor,
                        borderSideColor: AppColors.successColor,
                      ),
                    ],
                  );
                } else if (step == 1) {
                  return Column(
                    children: [
                      _ReportIssueButton(),
                      SizedBox(height: Dimensions.h(8)),
                      AppButton(
                        label: 'Arrive at Pickup',
                        onPressed: controller.arriveAtPickup,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ],
                  );
                } else if (step == 2) {
                  return Column(
                    children: [
                      _ReportIssueButton(),
                      SizedBox(height: Dimensions.h(8)),
                      AppButton(
                        label: 'Confirm Pickup',
                        onPressed: controller.confirmPickup,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ],
                  );
                } else if (step == 3) {
                  return Column(
                    children: [
                      _ReportIssueButton(),
                      SizedBox(height: Dimensions.h(8)),
                      AppButton(
                        label: 'Arrive at Delivery',
                        onPressed: controller.arriveAtDelivery,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ],
                  );
                } else if (step == 4) {
                  return Column(
                    children: [
                      _ReportIssueButton(),
                      SizedBox(height: Dimensions.h(8)),
                      AppButton(
                        label: 'Complete Delivery',
                        onPressed: () => Get.toNamed(RoutePath.deliveryProof),
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ],
                  );
                } else {
                  return AppButton(
                    label: 'Job Completed',
                    onPressed: () => Get.back(),
                    backgroundColor: AppColors.successColor,
                    borderSideColor: AppColors.successColor,
                    leadingIcon: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportIssueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(RoutePath.reportIssue),
      child: Container(
        width: double.infinity,
        height: Dimensions.h(48),
        decoration: BoxDecoration(
          color: AppColors.lightGreyColor,
          borderRadius: BorderRadius.circular(Dimensions.r(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.textPrimaryColor,
              size: Dimensions.rs(18),
            ),
            SizedBox(width: Dimensions.w(8)),
            Text(
              'Report Issue',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperWidget extends StatelessWidget {
  final int currentStep;
  const _StepperWidget({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Assigned', 'At Pickup', 'In Transit', 'At Drop', 'Done'];
    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            // Step 0: all dots grey, all lines grey
            // Step 1: 1st dot green.
            // Step 2: 1st and 2nd dots green. Line 1 green.
            // Step 3: 1st, 2nd, 3rd dots green. Line 1, 2 green.
            // Step 4: 1st, 2nd, 3rd, 4th dots green. Line 1, 2, 3 green.
            // Step 5: all 5 dots green. All lines green.
            final isDotGreen = currentStep > 0 && index <= currentStep - 1;
            final isNextDotGreen =
                currentStep > 0 && (index + 1) <= currentStep - 1;
            final isLineGreen = isDotGreen && isNextDotGreen;

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: Dimensions.w(14),
                    height: Dimensions.w(14),
                    decoration: BoxDecoration(
                      color: isDotGreen
                          ? AppColors.successColor
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2.5,
                        color: isLineGreen
                            ? AppColors.successColor
                            : Colors.grey[300],
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: Dimensions.h(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isActive = currentStep > 0 && index <= currentStep - 1;
            return Expanded(
              child: Text(
                steps[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.fs(9),
                  color: isActive
                      ? AppColors.textPrimaryColor
                      : AppColors.textSecondaryColor.withOpacity(0.5),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.w(16),
              vertical: Dimensions.h(10),
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.07),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.r(12)),
                topRight: Radius.circular(Dimensions.r(12)),
              ),
            ),
            child: Text(
              title,
              style: AppTextStyles.overline.copyWith(
                color: color,
                fontSize: Dimensions.fs(10),
                letterSpacing: 0.8,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.w(16),
              vertical: Dimensions.h(4),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
