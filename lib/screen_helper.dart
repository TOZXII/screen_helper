import 'package:flutter/widgets.dart';

import 'screen_helper_platform_interface.dart';

class ScreenHelper {
  /// Fetches the screen's PPI (Pixels Per Inch).
  static Future<double?> getScreenPPI() async {
    return await ScreenHelperPlatform.instance.getScreenPPI();
  }

  /// Fetches the screen's diagonal size in inches.
  static Future<double?> getScreenDiagonalInInches() async {
    return await ScreenHelperPlatform.instance.getScreenDiagonalInInches();
  }

  /// Fetches the screen's width size in inches.
  static Future<double?> getScreenWidthInInches() async {
    return await ScreenHelperPlatform.instance.getScreenWidthInInches();
  }

  /// Fetches the screen's height size in inches.
  static Future<double?> getScreenHeightInInches() async {
    return await ScreenHelperPlatform.instance.getScreenHeightInInches();
  }

  /// Fetches the screen's real width in pixels.
  static Future<int?> getScreenRealWidthInPixels() async {
    return await ScreenHelperPlatform.instance.getScreenRealWidthInPixels();
  }

  /// Fetches the screen's real height in pixels.
  static Future<int?> getScreenRealHeightInPixels() async {
    return await ScreenHelperPlatform.instance.getScreenRealHeightInPixels();
  }

  /// Fetches the screen's diagonal size in pixels.
  static Future<int?> getScreenDiagonalInPixels() async {
    return await ScreenHelperPlatform.instance.getScreenDiagonalInPixels();
  }

  /// This is  a function to convert mm to pixels
  ///
  /// It will help if you want to draw something on the screen with a specific size in mm
  /// [NOTE this function must be called inside a [build method] as the widget tree is fully built]
  ///  or it can be called in after the first frame is rendered using [WidgetsBinding.instance.addPostFrameCallback]
  static Future<double?> mmToPixels(double mm, BuildContext context) async {
    // Get the screen's pixel density (DPI)
    double dpi = MediaQuery.of(context).devicePixelRatio;
    final double? ppi = await getScreenPPI();

    double mmToInches = mm / 25.4;
    double lengthInPixels = mmToInches * (ppi ?? 164) / dpi;
    return double.parse(lengthInPixels.toStringAsFixed(3));
  }
}
