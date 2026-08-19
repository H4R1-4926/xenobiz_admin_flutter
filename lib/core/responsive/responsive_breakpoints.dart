import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, laptop, desktop }

class ResponsiveBreakpoints {
  static const double mobileMax = 767.0;
  static const double tabletMax = 1023.0;
  static const double laptopMax = 1439.0;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= mobileMax) return DeviceType.mobile;
    if (width <= tabletMax) return DeviceType.tablet;
    if (width <= laptopMax) return DeviceType.laptop;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > mobileMax && w <= tabletMax;
  }

  static bool isLaptop(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > tabletMax && w <= laptopMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > laptopMax;

  static bool isMobileOrTablet(BuildContext context) =>
      MediaQuery.of(context).size.width <= tabletMax;
}
