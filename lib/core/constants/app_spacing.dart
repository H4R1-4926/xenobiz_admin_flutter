import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  static const EdgeInsets pagePadding = EdgeInsets.all(24.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets dialogPadding = EdgeInsets.all(24.0);
}

class AppRadius {
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 14.0;
  static const double badge = 999.0;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(sm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(md);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(lg);
  static final BorderRadius borderRadiusBadge = BorderRadius.circular(badge);
}
