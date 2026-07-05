import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg extends StatelessWidget {
  final String path;
  final double size;
  final Color? color;

  const AppSvg({
    super.key,
    required this.path,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter:
          color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
    );
  }
}
