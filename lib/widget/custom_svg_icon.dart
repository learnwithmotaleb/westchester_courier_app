import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/responsive_layout/dimensions.dart';

class CustomSvgIcon extends StatelessWidget {
  final String icon;
  final double? size;
  final Color? color;
  final BlendMode? blendMode;

  const CustomSvgIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.blendMode,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: size ?? Dimensions.rs(24),
      height: size ?? Dimensions.rs(24),
      colorFilter: color != null
          ? ColorFilter.mode(color!, blendMode ?? BlendMode.srcIn)
          : null,
    );
  }
}
