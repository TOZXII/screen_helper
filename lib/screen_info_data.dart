import 'dart:math';

class ScreenInfoData {
  /// Supply exactly one of [devicePixelRatio] or the legacy [dpi] argument.
  /// Dimension maps must contain positive, finite width and height values and
  /// must not be mutated after construction.
  const ScreenInfoData({
    required this.screenSizeInInches,
    required this.screenResolution,
    double? devicePixelRatio,
    @Deprecated('Use devicePixelRatio instead. This value is a ratio, not DPI.')
    double? dpi,
  })  : assert(
          (devicePixelRatio == null) != (dpi == null),
          'Supply exactly one of devicePixelRatio or dpi.',
        ),
        _devicePixelRatio = devicePixelRatio,
        _legacyDpi = dpi;

  final double? _devicePixelRatio;
  final double? _legacyDpi;

  /// The screen size in inches (width and height).
  final Map<String, double> screenSizeInInches;

  /// The screen resolution in pixels (width and height).
  final Map<String, double> screenResolution;

  /// The number of physical pixels per Flutter logical pixel.
  double get devicePixelRatio {
    if ((_devicePixelRatio == null) == (_legacyDpi == null)) {
      throw ArgumentError('Supply exactly one of devicePixelRatio or dpi.');
    }
    return _positiveFinite(_devicePixelRatio ?? _legacyDpi, 'devicePixelRatio');
  }

  /// Legacy name for [devicePixelRatio]. This value is a ratio, not DPI.
  @Deprecated('Use devicePixelRatio instead. This value is a ratio, not DPI.')
  double get dpi => devicePixelRatio;

  /// Device PPI
  double get ppi {
    return _calculateDiagonalInPixels() / _calculateScreenDiagonalInInches();
  }

  /// Returns the screen width in inches.
  double get screenWidthInInches =>
      _positiveFinite(screenSizeInInches['width'], 'screen width in inches');

  /// Returns the screen height in inches.
  double get screenHeightInInches =>
      _positiveFinite(screenSizeInInches['height'], 'screen height in inches');

  /// Returns the screen diagonal size in inches.
  double get screenDiagonalInInches => _calculateScreenDiagonalInInches();

  /// Returns the screen width in pixels.
  double get screenWidthInPixels => _positiveFinite(
      screenResolution['width'], 'screen width in physical pixels');

  /// Returns the screen height in pixels.
  double get screenHeightInPixels => _positiveFinite(
      screenResolution['height'], 'screen height in physical pixels');

  /// Returns the screen's aspect ratio.
  double get screenAspectRatio => screenWidthInPixels / screenHeightInPixels;

  double _calculateDiagonalInPixels() {
    return sqrt(pow(screenWidthInPixels, 2) + pow(screenHeightInPixels, 2));
  }

  double _calculateScreenDiagonalInInches() {
    return sqrt(pow(screenWidthInInches, 2) + pow(screenHeightInInches, 2));
  }

  static double _positiveFinite(double? value, String name) {
    if (value == null || !value.isFinite || value <= 0) {
      throw ArgumentError.value(value, name, 'Must be positive and finite.');
    }
    return value;
  }

  /// Compares two ScreenInfoData objects for equality.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenInfoData &&
          runtimeType == other.runtimeType &&
          screenWidthInInches == other.screenWidthInInches &&
          screenHeightInInches == other.screenHeightInInches &&
          screenWidthInPixels == other.screenWidthInPixels &&
          screenHeightInPixels == other.screenHeightInPixels &&
          devicePixelRatio == other.devicePixelRatio;

  /// Returns a hash code for the ScreenInfoData object.
  @override
  int get hashCode => Object.hash(
        runtimeType,
        screenWidthInInches,
        screenHeightInInches,
        screenWidthInPixels,
        screenHeightInPixels,
        devicePixelRatio,
      );
}
