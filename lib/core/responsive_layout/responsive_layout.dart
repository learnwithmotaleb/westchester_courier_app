import 'package:flutter/material.dart';

import '../enums/device_type.dart';
import 'dimensions.dart';

// ─────────────────────────────────────────────
// 🔹 ResponsiveLayout — swap entire widget trees
// ─────────────────────────────────────────────
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use shortestSide so breakpoints are orientation-safe
        // (matches Dimensions.isMobile / isTablet / isDesktop)
        final shortest = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        if (shortest >= 1024) return desktop ?? tablet ?? mobile;
        if (shortest >= 600) return tablet ?? mobile;
        return mobile;
      },
    );
  }
}

// ─────────────────────────────────────────────
// 🔹 ResponsiveBuilder — inline responsive values
// ─────────────────────────────────────────────
/// Use this when you need different *values* per device without swapping
/// entire widget trees.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, device) => Padding(
///     padding: EdgeInsets.all(device.isMobile ? 12 : 24),
///     child: child,
///   ),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceInfo device) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final info = DeviceInfo._fromConstraints(constraints);
        return builder(context, info);
      },
    );
  }
}

// ─────────────────────────────────────────────
// 🔹 DeviceInfo — passed into ResponsiveBuilder
// ─────────────────────────────────────────────
class DeviceInfo {
  final DeviceType type;
  final double shortestSide;
  final double longestSide;

  const DeviceInfo._({
    required this.type,
    required this.shortestSide,
    required this.longestSide,
  });

  factory DeviceInfo._fromConstraints(BoxConstraints constraints) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final shortest = w < h ? w : h;
    final longest = w > h ? w : h;

    DeviceType type;
    if (shortest >= 1024) {
      type = DeviceType.desktop;
    } else if (shortest >= 600) {
      type = DeviceType.tablet;
    } else {
      type = DeviceType.mobile;
    }

    return DeviceInfo._(type: type, shortestSide: shortest, longestSide: longest);
  }

  bool get isMobile => type == DeviceType.mobile;
  bool get isTablet => type == DeviceType.tablet;
  bool get isDesktop => type == DeviceType.desktop;

  /// Returns the right value for the current device, with fallback chain:
  /// desktop → tablet → mobile.
  T resolve<T>(T mobile, {T? tablet, T? desktop}) {
    switch (type) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      default:
        return mobile;
    }
  }
}

// ─────────────────────────────────────────────
// 🔹 BuildContext extension for quick device checks
// ─────────────────────────────────────────────
extension ResponsiveContext on BuildContext {
  double get _shortest {
    final mq = MediaQuery.of(this);
    final w = mq.size.width;
    final h = mq.size.height;
    return w < h ? w : h;
  }

  DeviceType get deviceType {
    final s = _shortest;
    if (s >= 1024) return DeviceType.desktop;
    if (s >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Resolve a value per device directly from context.
  T responsive<T>(T mobile, {T? tablet, T? desktop}) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      default:
        return mobile;
    }
  }
}
