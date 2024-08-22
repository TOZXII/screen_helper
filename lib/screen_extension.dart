import 'package:flutter/widgets.dart';
import 'package:screen_helper/screen_helper_widget.dart';

extension ScreenExtension on BuildContext {
  /// Gets the inches to logical pixels ratio
  double get inchesToLogicalPixelsRatio {
    final screenInfo = ScreenInfo.of(this);
    return screenInfo.ppi / MediaQuery.of(this).devicePixelRatio;
  }

  /// Converts millimeters to pixels
  double mmToPx(double mm) {
    return (mm / 25.4) * inchesToLogicalPixelsRatio;
  }

  /// Converts pixels to millimeters
  double pxToMm(int px) {
    return (px / inchesToLogicalPixelsRatio) * 25.4;
  }

  /// Converts centimeters to pixels
  double cmToPx(double cm) {
    return mmToPx(cm * 10);
  }

  /// Converts pixels to centimeters
  double pxToCm(int px) {
    return pxToMm(px) / 10;
  }

  /// Converts inches to pixels
  double inchesToPx(double inches) {
    return inches * inchesToLogicalPixelsRatio;
  }

  /// Converts pixels to inches
  double pxToInches(int px) {
    return px / inchesToLogicalPixelsRatio;
  }
}
