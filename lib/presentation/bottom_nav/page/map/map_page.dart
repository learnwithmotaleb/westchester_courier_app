import 'package:flutter/material.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
              child: Stack(
                children: [
                  // Map placeholder
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFFE8EFF6),
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: Dimensions.rs(56),
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(height: Dimensions.h(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(16),
                            vertical: Dimensions.h(8),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(20)),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.blackColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'Map view available with API key',
                            style: AppTextStyles.bodyText.copyWith(
                              color: AppColors.textSecondaryColor,
                              fontSize: Dimensions.fs(12),
                            ),
                          ),
                        ),
                      ],
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

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.06)
      ..strokeWidth = 1;

    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
