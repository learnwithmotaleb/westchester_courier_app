import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DevicePreviewWrapper extends StatelessWidget {
  final Widget child;

  const DevicePreviewWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: !kReleaseMode, // production এ auto off
      builder: (context) => child,
    );
  }
}