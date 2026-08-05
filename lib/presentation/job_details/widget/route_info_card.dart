// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:westchester/utils/app_colors/app_colors.dart';
// import 'package:westchester/utils/app_text_style/app_text_style.dart';
// import 'package:westchester/core/responsive_layout/dimensions.dart';
// import '../controller/job_details_controller.dart';
//
// /// Courier-style Route Info Card
// ///
// /// Displays distance, Google traffic ETA, and a vehicle selector (Bike/Car/Truck)
// /// with per-vehicle estimated time and delivery fare.
// class RouteInfoCard extends GetView<JobDetailsController> {
//   const RouteInfoCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isLoading = controller.isMapLoading.value;
//       final distanceKm = controller.distanceKm.value;
//       final distanceStr = controller.distanceText.value;
//       final etaStr = controller.etaText.value;
//       final hasData = distanceKm > 0;
//
//       return Container(
//         decoration: BoxDecoration(
//           color: AppColors.whiteColor,
//           borderRadius: BorderRadius.circular(Dimensions.r(16)),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primaryColor.withOpacity(0.06),
//               blurRadius: 16,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header: Distance & Traffic ETA ───────────────────────
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(
//                 horizontal: Dimensions.w(16),
//                 vertical: Dimensions.h(14),
//               ),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primaryColor,
//                     AppColors.primaryColor.withOpacity(0.80),
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(Dimensions.r(16)),
//                   topRight: Radius.circular(Dimensions.r(16)),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     'ROUTE INFO',
//                     style: AppTextStyles.overline.copyWith(
//                       color: AppColors.whiteColor.withOpacity(0.85),
//                       fontSize: Dimensions.fs(10),
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                   const Spacer(),
//                   // Traffic indicator dot
//                   Container(
//                     width: Dimensions.w(8),
//                     height: Dimensions.w(8),
//                     decoration: BoxDecoration(
//                       color: hasData
//                           ? AppColors.successColor
//                           : AppColors.warningColor,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   SizedBox(width: Dimensions.w(6)),
//                   Text(
//                     hasData ? 'Live Data' : 'Loading...',
//                     style: AppTextStyles.overline.copyWith(
//                       color: AppColors.whiteColor.withOpacity(0.75),
//                       fontSize: Dimensions.fs(10),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: EdgeInsets.all(Dimensions.w(16)),
//               child: isLoading
//                   ? _LoadingShimmer()
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ── Distance & ETA Row ──────────────────────────────
//                         Row(
//                           children: [
//                             _StatBox(
//                               icon: Icons.route_rounded,
//                               iconColor: AppColors.primaryColor,
//                               label: 'DISTANCE',
//                               value: hasData
//                                   ? (distanceStr.isNotEmpty
//                                       ? distanceStr
//                                       : '${distanceKm.toStringAsFixed(1)} km')
//                                   : '—',
//                             ),
//                             SizedBox(width: Dimensions.w(12)),
//                             _StatBox(
//                               icon: Icons.traffic_rounded,
//                               iconColor: AppColors.warningColor,
//                               label: 'ETA (w/ Traffic)',
//                               value: etaStr.isNotEmpty ? etaStr : '—',
//                             ),
//                           ],
//                         ),
//
//                         SizedBox(height: Dimensions.h(16)),
//
//                         // ── Vehicle Selector ────────────────────────────────
//                         Text(
//                           'SELECT VEHICLE',
//                           style: AppTextStyles.overline.copyWith(
//                             color: AppColors.textSecondaryColor,
//                             fontSize: Dimensions.fs(10),
//                             letterSpacing: 0.8,
//                           ),
//                         ),
//                         SizedBox(height: Dimensions.h(8)),
//
//                         Obx(
//                           () => Row(
//                             children: kVehicleOptions.map((v) {
//                               final isSelected =
//                                   controller.selectedVehicle.value == v.key;
//                               return Expanded(
//                                 child: GestureDetector(
//                                   onTap: () =>
//                                       controller.selectVehicle(v.key),
//                                   child: AnimatedContainer(
//                                     duration: const Duration(milliseconds: 200),
//                                     margin: EdgeInsets.only(
//                                       right: v == kVehicleOptions.last
//                                           ? 0
//                                           : Dimensions.w(8),
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: Dimensions.h(10),
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: isSelected
//                                           ? AppColors.primaryColor
//                                           : AppColors.scaffoldBgColor,
//                                       borderRadius: BorderRadius.circular(
//                                           Dimensions.r(12)),
//                                       border: Border.all(
//                                         color: isSelected
//                                             ? AppColors.primaryColor
//                                             : AppColors.dividerColor,
//                                         width: 1.5,
//                                       ),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           v.emoji,
//                                           style: TextStyle(
//                                               fontSize: Dimensions.fs(20)),
//                                         ),
//                                         SizedBox(height: Dimensions.h(4)),
//                                         Text(
//                                           v.label,
//                                           style:
//                                               AppTextStyles.bodyText.copyWith(
//                                             fontSize: Dimensions.fs(11),
//                                             fontWeight: FontWeight.w600,
//                                             color: isSelected
//                                                 ? AppColors.whiteColor
//                                                 : AppColors.textPrimaryColor,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//
//                         SizedBox(height: Dimensions.h(14)),
//
//                         // ── Selected Vehicle ETA + Fare ─────────────────────
//                         Obx(() {
//                           final vehicle =
//                               controller.selectedVehicleOption;
//                           final etaMins =
//                               controller.vehicleEtaMinutes;
//                           final fare = controller.vehicleFare;
//
//                           return Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: Dimensions.w(16),
//                               vertical: Dimensions.h(12),
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                                   AppColors.primaryColor.withOpacity(0.05),
//                               borderRadius:
//                                   BorderRadius.circular(Dimensions.r(12)),
//                               border: Border.all(
//                                 color:
//                                     AppColors.primaryColor.withOpacity(0.15),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 // ETA
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'ESTIMATED TIME',
//                                         style:
//                                             AppTextStyles.overline.copyWith(
//                                           color:
//                                               AppColors.textSecondaryColor,
//                                           fontSize: Dimensions.fs(9),
//                                           letterSpacing: 0.6,
//                                         ),
//                                       ),
//                                       SizedBox(height: Dimensions.h(4)),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.access_time_rounded,
//                                             size: Dimensions.rs(14),
//                                             color: AppColors.primaryColor,
//                                           ),
//                                           SizedBox(width: Dimensions.w(4)),
//                                           Text(
//                                             hasData
//                                                 ? '~${etaMins.toStringAsFixed(0)} min'
//                                                 : '—',
//                                             style: AppTextStyles.h4.copyWith(
//                                               color: AppColors
//                                                   .textPrimaryColor,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Text(
//                                         '${vehicle.label} @ ${vehicle.speedKmh.toInt()} km/h',
//                                         style:
//                                             AppTextStyles.caption.copyWith(
//                                           color:
//                                               AppColors.textSecondaryColor,
//                                           fontSize: Dimensions.fs(10),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//
//                                 // Divider
//                                 Container(
//                                   width: 1,
//                                   height: Dimensions.h(44),
//                                   color: AppColors.dividerColor,
//                                 ),
//
//                                 SizedBox(width: Dimensions.w(16)),
//
//                                 // Fare
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'DELIVERY FARE',
//                                         style:
//                                             AppTextStyles.overline.copyWith(
//                                           color:
//                                               AppColors.textSecondaryColor,
//                                           fontSize: Dimensions.fs(9),
//                                           letterSpacing: 0.6,
//                                         ),
//                                       ),
//                                       SizedBox(height: Dimensions.h(4)),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.attach_money_rounded,
//                                             size: Dimensions.rs(14),
//                                             color: AppColors.successColor,
//                                           ),
//                                           Text(
//                                             hasData
//                                                 ? '~\$${fare.toStringAsFixed(2)}'
//                                                 : '—',
//                                             style: AppTextStyles.h4.copyWith(
//                                               color: AppColors
//                                                   .textPrimaryColor,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Text(
//                                         '\$${vehicle.baseFare.toStringAsFixed(0)} base + \$${vehicle.perKmRate.toStringAsFixed(2)}/km',
//                                         style:
//                                             AppTextStyles.caption.copyWith(
//                                           color:
//                                               AppColors.textSecondaryColor,
//                                           fontSize: Dimensions.fs(10),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
// // ─── Stat Box ─────────────────────────────────────────────────────────────────
// class _StatBox extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String label;
//   final String value;
//
//   const _StatBox({
//     required this.icon,
//     required this.iconColor,
//     required this.label,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: Dimensions.w(12),
//           vertical: Dimensions.h(10),
//         ),
//         decoration: BoxDecoration(
//           color: AppColors.scaffoldBgColor,
//           borderRadius: BorderRadius.circular(Dimensions.r(12)),
//           border: Border.all(color: AppColors.dividerColor),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(Dimensions.w(6)),
//               decoration: BoxDecoration(
//                 color: iconColor.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(Dimensions.r(8)),
//               ),
//               child: Icon(icon, size: Dimensions.rs(16), color: iconColor),
//             ),
//             SizedBox(width: Dimensions.w(10)),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: AppTextStyles.overline.copyWith(
//                       color: AppColors.textSecondaryColor,
//                       fontSize: Dimensions.fs(9),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   SizedBox(height: Dimensions.h(2)),
//                   Text(
//                     value,
//                     style: AppTextStyles.bodyText.copyWith(
//                       color: AppColors.textPrimaryColor,
//                       fontWeight: FontWeight.w700,
//                       fontSize: Dimensions.fs(13),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ─── Loading Shimmer ──────────────────────────────────────────────────────────
// class _LoadingShimmer extends StatefulWidget {
//   @override
//   State<_LoadingShimmer> createState() => _LoadingShimmerState();
// }
//
// class _LoadingShimmerState extends State<_LoadingShimmer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1100),
//     )..repeat(reverse: true);
//     _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
//       CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => Opacity(
//         opacity: _anim.value,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 _ShimmerBox(width: double.infinity, height: Dimensions.h(52)),
//                 SizedBox(width: Dimensions.w(12)),
//                 _ShimmerBox(width: double.infinity, height: Dimensions.h(52)),
//               ],
//             ),
//             SizedBox(height: Dimensions.h(16)),
//             _ShimmerBox(
//                 width: double.infinity, height: Dimensions.h(80)),
//             SizedBox(height: Dimensions.h(12)),
//             _ShimmerBox(
//                 width: double.infinity, height: Dimensions.h(80)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ShimmerBox extends StatelessWidget {
//   final double width;
//   final double height;
//   const _ShimmerBox({required this.width, required this.height});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         height: height,
//         decoration: BoxDecoration(
//           color: AppColors.shimmerBaseColor,
//           borderRadius: BorderRadius.circular(Dimensions.r(10)),
//         ),
//       ),
//     );
//   }
// }
