import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import '../model/my_map_model.dart';

/// Bottom info card shown when a DELIVERY marker is tapped on the map.
class DeliveryInfoCard extends StatelessWidget {
  final MyMapFullDelivery delivery;
  final VoidCallback onClose;

  const DeliveryInfoCard({
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
                  color: AppColors.redColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(Dimensions.r(20)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping_rounded,
                      size: Dimensions.rs(14),
                      color: AppColors.redColor,
                    ),
                    SizedBox(width: Dimensions.w(4)),
                    Text(
                      'DELIVERY',
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.redColor,
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

          // ── Route: Pickup → Delivery ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pickup side
              Expanded(
                child: _LocationColumn(
                  icon: Icons.trip_origin_rounded,
                  iconColor: AppColors.primaryColor,
                  label: 'FROM',
                  address: delivery.pickupAddress ?? 'Not provided',
                  name: delivery.customerName,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimensions.h(18)),
                child: Icon(
                  Icons.arrow_right_alt_rounded,
                  color: AppColors.textSecondaryColor,
                  size: Dimensions.rs(22),
                ),
              ),
              // Delivery side
              Expanded(
                child: _LocationColumn(
                  icon: Icons.location_on_rounded,
                  iconColor: AppColors.redColor,
                  label: 'TO',
                  address: delivery.dropoffAddress ?? 'Not provided',
                  name: delivery.receiverName,
                  textAlign: TextAlign.right,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),

          SizedBox(height: Dimensions.h(16)),

          // ── Receiver Info ────────────────────────────────────────
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Receiver Phone',
            value: delivery.receiverPhone ?? '—',
            iconColor: AppColors.redColor,
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
                backgroundColor: AppColors.redColor,
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

// ─── Location Column ────────────────────────────────────────────────────────

class _LocationColumn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;
  final String? name;
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;

  const _LocationColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.address,
    this.name,
    this.textAlign = TextAlign.left,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisAlignment: crossAxisAlignment == CrossAxisAlignment.end
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Icon(icon, size: Dimensions.rs(12), color: iconColor),
            SizedBox(width: Dimensions.w(4)),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: iconColor,
                fontSize: Dimensions.fs(10),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.h(4)),
        if (name != null)
          Text(
            name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fs(12),
            ),
          ),
        SizedBox(height: Dimensions.h(2)),
        Text(
          address,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondaryColor,
            fontSize: Dimensions.fs(11),
          ),
        ),
      ],
    );
  }
}

// ─── Info Row ────────────────────────────────────────────────────────────────

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
