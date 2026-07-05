import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums/device_type.dart';

class Dimensions {
  Dimensions._();

  // 🔹 Base design (Figma)
  static const double baseWidth = 390.0;
  static const double baseHeight = 844.0;

  // 🔹 Screen size
  static double get screenWidth => Get.width;
  static double get screenHeight => Get.height;

  // 🔹 Orientation-safe
  static double get shortestSide =>
      screenWidth < screenHeight ? screenWidth : screenHeight;

  static double get longestSide =>
      screenWidth > screenHeight ? screenWidth : screenHeight;

  // 🔹 MediaQuery
  static MediaQueryData? get _mq =>
      Get.context != null ? MediaQuery.of(Get.context!) : null;

  static double get pixelRatio => _mq?.devicePixelRatio ?? 2.0;
  static double get textScale => _mq?.textScaler.scale(1.0) ?? _mq?.textScaleFactor ?? 1.0;

  // 🔹 Device Type Enum (NEW 🔥)
  static DeviceType get deviceType {
    if (isDesktop) return DeviceType.desktop;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  // 🔹 Width scale
  static double w(double value) {
    final scaled = value * (screenWidth / baseWidth);
    return clampSpace(scaled);
  }

  // 🔹 Height scale
  static double h(double value) {
    final scaled = value * (screenHeight / baseHeight);
    return clampSpace(scaled);
  }

  // 🔹 Font scale (improved)
  static double f(double size, {bool respectTextScale = true}) {
    double scaled = size * (shortestSide / baseWidth);

    if (respectTextScale) {
      scaled *= textScale.clamp(0.8, 1.3); // 🔥 FIXED
    }

    return clampFont(scaled);
  }

  // 🔹 Radius
  static double r(double radius) {
    final scaled = radius * (screenWidth / baseWidth);
    return clampSpace(scaled);
  }

  // 🔥 Clean API for Font
  static double fs(
      double mobile, {
        double? tablet,
        double? desktop,
      }) {
    switch (deviceType) {
      case DeviceType.desktop:
        return f(desktop ?? tablet ?? mobile);
      case DeviceType.tablet:
        return f(tablet ?? mobile);
      default:
        return f(mobile);
    }
  }

  // 🔥 Layout size (FIXED: was using f ❌)
  static double rs(
      double mobile, {
        double? tablet,
        double? desktop,
      }) {
    switch (deviceType) {
      case DeviceType.desktop:
        return w(desktop ?? tablet ?? mobile);
      case DeviceType.tablet:
        return w(tablet ?? mobile);
      default:
        return w(mobile);
    }
  }

  // 🔹 Icon size
  static double icon(
      double mobile, {
        double? tablet,
        double? desktop,
      }) {
    return rs(mobile, tablet: tablet, desktop: desktop);
  }

  // 🔹 Padding helpers (FIXED)
  static EdgeInsets pAll(double v) => EdgeInsets.all(w(v));

  static EdgeInsets pSym({double h = 16, double v = 16}) =>
      EdgeInsets.symmetric(horizontal: w(h), vertical: Dimensions.h(v));

  static EdgeInsets pOnly({
    double l = 0,
    double t = 0,
    double r = 0,
    double b = 0,
  }) =>
      EdgeInsets.only(
        left: w(l),
        top: h(t),
        right: w(r),
        bottom: h(b),
      );

  // 🔹 Common paddings
  static EdgeInsets get pSmall => pAll(8);
  static EdgeInsets get pMedium => pAll(16);
  static EdgeInsets get pLarge => pAll(24);

  // 🔹 Gaps
  static SizedBox gapW(double v) => SizedBox(width: w(v));
  static SizedBox gapH(double v) => SizedBox(height: h(v));

  // 🔹 Safe area
  static EdgeInsets get safePadding => _mq?.padding ?? EdgeInsets.zero;

  // 🔹 Breakpoints
  static bool get isMobile => shortestSide < 600;
  static bool get isTablet =>
      shortestSide >= 600 && shortestSide < 1024;
  static bool get isDesktop => shortestSide >= 1024;

  // 🔹 Clamp fonts (UPDATED 🔥)
  static double clampFont(
      double value, {
        double min = 12,
        double max = 40, // increased for desktop
      }) {
    return value.clamp(min, max);
  }

  // 🔹 Clamp spacing
  static double clampSpace(
      double value, {
        double min = 0,
        double max = 2000,
      }) {
    return value.clamp(min, max);
  }
}

