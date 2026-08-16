import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import '../model/my_map_model.dart';

/// Bottom info card shown when a PICKUP marker is tapped on the map.
class PickupInfoCard extends StatelessWidget {
  final MyMapFullDelivery delivery;
  final VoidCallback onClose;

  const PickupInfoCard({
    super.key,
    required this.delivery,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(16),
        vertical: Dimensions.h(16),
      ),
      margin: EdgeInsets.all(Dimensions.w(12)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.w(10),
                  vertical: Dimensions.h(4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(Dimensions.r(20)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: Dimensions.rs(14),
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: Dimensions.w(4)),
                    Text(
                      'PICK-UP',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: Dimensions.fs(10),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (delivery.orderNumber != null)
                Text(
                  '#${delivery.orderNumber}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondaryColor,
                    fontSize: Dimensions.fs(11),
                  ),
                ),
              SizedBox(width: Dimensions.w(8)),
              GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close_rounded,
                  size: Dimensions.rs(20),
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),

          SizedBox(height: Dimensions.h(14)),

          // ── Customer Info ────────────────────────────────────────
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Sender',
            value: delivery.customerName ?? 'Not provided',
            iconColor: AppColors.primaryColor,
          ),
          SizedBox(height: Dimensions.h(8)),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: delivery.customerPhone ?? '—',
            iconColor: AppColors.primaryColor,
          ),
          SizedBox(height: Dimensions.h(8)),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: delivery.pickupAddress ?? 'Not provided',
            iconColor: AppColors.primaryColor,
          ),

          SizedBox(height: Dimensions.h(16)),

          // ── View Details Button ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: Dimensions.h(44),
            child: ElevatedButton(
              onPressed: () {
                if (delivery.id != null) {
                  Get.toNamed(
                    RoutePath.jobDetails,
                    arguments: {'id': delivery.id},
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r(12)),
                ),
                elevation: 0,
              ),
              child: Text(
                'View Job Details',
                style: AppTextStyles.buttonSmall.copyWith(
                  color: AppColors.whiteColor,
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

/// Small icon + label + value row used inside info cards.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: Dimensions.rs(16), color: iconColor),
        SizedBox(width: Dimensions.w(8)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondaryColor,
                  fontSize: Dimensions.fs(10),
                ),
              ),
              SizedBox(height: Dimensions.h(1)),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.fs(12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
