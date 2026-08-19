import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? laptop;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobile,
    this.tablet,
    this.laptop,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);

    if (deviceType == DeviceType.mobile && mobile != null) return mobile!;
    if (deviceType == DeviceType.tablet && tablet != null) return tablet!;
    if (deviceType == DeviceType.laptop && laptop != null) return laptop!;
    if (deviceType == DeviceType.desktop && desktop != null) return desktop!;

    return builder(context, deviceType);
  }
}
