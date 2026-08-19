import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop, largeDesktop }

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.largeDesktop,
  });

  static const double mobileMax = 600;
  static const double tabletMax = 900;
  static const double desktopMax = 1200;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMax) return DeviceType.mobile;
    if (width < tabletMax) return DeviceType.tablet;
    if (width < desktopMax) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  static bool isMobile(BuildContext context) => getDeviceType(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) => getDeviceType(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop || getDeviceType(context) == DeviceType.largeDesktop;
  static bool isLargeDesktop(BuildContext context) => getDeviceType(context) == DeviceType.largeDesktop;

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop;
    }
  }
}
