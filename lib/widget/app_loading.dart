import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final bool isFullPage;

  const AppLoading({
    super.key,
    this.message,
    this.size = 35,
    this.color,
    this.isFullPage = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: GradientCircularProgressIndicator(
            radius: size / 2,
            gradientColors: [
              (color ?? AppColors.primaryColor).withOpacity(0.1),
              (color ?? AppColors.primaryColor),
            ],
            strokeWidth: size / 10 + 1,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: AppTextStyles.caption.copyWith(color: AppColors.darkGreyColor),
          ),
        ]
      ],
    );

    return isFullPage ? Center(child: content) : content;
  }
}

class GradientCircularProgressIndicator extends StatefulWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  const GradientCircularProgressIndicator({
    super.key,
    required this.radius,
    required this.gradientColors,
    this.strokeWidth = 4.0,
  });

  @override
  State<GradientCircularProgressIndicator> createState() =>
      _GradientCircularProgressIndicatorState();
}

class _GradientCircularProgressIndicatorState
    extends State<GradientCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: Size(widget.radius * 2, widget.radius * 2),
        painter: _GradientCircularProgressPainter(
          radius: widget.radius,
          gradientColors: widget.gradientColors,
          strokeWidth: widget.strokeWidth,
        ),
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  _GradientCircularProgressPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromCircle(center: Offset(center, center), radius: radius - strokeWidth / 2);

    paint.shader = SweepGradient(
      colors: gradientColors,
      stops: const [0.0, 1.0],
      transform: const GradientRotation(-math.pi / 2),
    ).createShader(rect);

    canvas.drawArc(rect, 0, 2 * math.pi * 0.9, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
