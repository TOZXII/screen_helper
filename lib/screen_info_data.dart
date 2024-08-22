import 'dart:math';

class ScreenInfoData {
  const ScreenInfoData({
    required this.screenSizeInInches,
    required this.screenResolution,
    required this.dpi,
  });

  /// The screen size in inches (width and height).
  final Map<String, double> screenSizeInInches;

  /// The screen resolution in pixels (width and height).
  final Map<String, double> screenResolution;

  /// The screen's DPI (Dots Per Inch).
  final double dpi;

  /// Device PPI
  double get ppi {
    return _calculateDiagonalInPixels() / _calculateScreenDiagonalInInches();
  }

  /// Returns the screen width in inches.
  double get screenWidthInInches => screenSizeInInches['width']!;

  /// Returns the screen height in inches.
  double get screenHeightInInches => screenSizeInInches['height']!;

  /// Returns the screen diagonal size in inches.
  double get screenDiagonalInInches => _calculateScreenDiagonalInInches();

  /// Returns the screen width in pixels.
  double get screenWidthInPixels => screenResolution['width']!;

  /// Returns the screen height in pixels.
  double get screenHeightInPixels => screenResolution['height']!;

  /// Returns the screen's aspect ratio.
  double get screenAspectRatio => screenWidthInPixels / screenHeightInPixels;

  double _calculateDiagonalInPixels() {
    return sqrt(pow(screenWidthInPixels, 2) + pow(screenHeightInPixels, 2));
  }

  double _calculateScreenDiagonalInInches() {
    return sqrt(pow(screenSizeInInches['width']!, 2) +
        pow(screenSizeInInches['height']!, 2));
  }

  /// Compares two ScreenInfoData objects for equality.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenInfoData &&
          runtimeType == other.runtimeType &&
          screenSizeInInches == other.screenSizeInInches &&
          screenResolution == other.screenResolution &&
          dpi == other.dpi;

  /// Returns a hash code for the ScreenInfoData object.
  @override
  int get hashCode => Object.hash(screenSizeInInches, screenResolution, dpi);
}
