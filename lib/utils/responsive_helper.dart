import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1025;

  // Screen size helpers
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < desktopMinWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  // Responsive values
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(
      responsive(context, mobile: 16.0, tablet: 24.0, desktop: 32.0),
    );
  }

  // Responsive card width
  static double getCardWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 300.0,
      desktop: 320.0,
    );
  }

  // Responsive grid columns
  static int getGridColumns(BuildContext context) {
    return responsive(context, mobile: 2, tablet: 3, desktop: 4);
  }

  // Responsive text size
  static double getTextSize(BuildContext context, double baseSize) {
    return responsive(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.1,
      desktop: baseSize * 1.2,
    );
  }

  // Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Check if keyboard is open
  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  // Get screen orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  // Check if in landscape mode
  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }

  // Get responsive max width for content
  static double getMaxContentWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 800.0,
      desktop: 1200.0,
    );
  }

  // Responsive font sizes
  static TextStyle responsiveTextStyle(
    BuildContext context, {
    double mobileSize = 14,
    double? tabletSize,
    double? desktopSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    final size = responsive(
      context,
      mobile: mobileSize,
      tablet: tabletSize ?? mobileSize * 1.1,
      desktop: desktopSize ?? mobileSize * 1.2,
    );

    return TextStyle(fontSize: size, fontWeight: fontWeight, color: color);
  }

  // Responsive button size
  static Size getButtonSize(BuildContext context) {
    return Size(
      responsive(
        context,
        mobile: double.infinity,
        tablet: 200.0,
        desktop: 220.0,
      ),
      responsive(context, mobile: 48.0, tablet: 52.0, desktop: 56.0),
    );
  }

  // Get responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsive(
        context,
        mobile: 16.0,
        tablet: 32.0,
        desktop: 48.0,
      ),
      vertical: responsive(context, mobile: 8.0, tablet: 12.0, desktop: 16.0),
    );
  }

  // Get responsive icon size
  static double getIconSize(BuildContext context, {double baseSize = 24.0}) {
    return responsive(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.2,
      desktop: baseSize * 1.4,
    );
  }
}
