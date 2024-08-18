import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_helper_platform_interface.dart';

/// An implementation of [ScreenHelperPlatform] that uses method channels.
class MethodChannelScreenHelper extends ScreenHelperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_helper');

  /// Fetches the screen's PPI (Pixels Per Inch).
  @override
  Future<double?> getScreenPPI() async {
    final screenPPI = await methodChannel.invokeMethod<double>('getScreenPPI');

    return screenPPI;
  }

  /// Fetches the screen's diagonal size in inches.
  @override
  Future<double?> getScreenDiagonalInInches() async {
    final screenDiagonalInInches = await methodChannel
        .invokeMethod<double>('getScreenDiagonalSizeInInches');

    return screenDiagonalInInches;
  }

  /// Fetches the screen's width size in inches.
  @override
  Future<double?> getScreenWidthInInches() async {
    final screenWidthInInches =
        await methodChannel.invokeMethod<double>('getScreenWidthSizeInInches');

    if (screenWidthInInches != null) {
      return double.parse(screenWidthInInches.toStringAsFixed(3));
    }

    return null;
  }

  /// Fetches the screen's height size in inches.
  @override
  Future<double?> getScreenHeightInInches() async {
    final screenHeightInInches =
        await methodChannel.invokeMethod<double>('getScreenHeightSizeInInches');

    if (screenHeightInInches != null) {
      return double.parse(screenHeightInInches.toStringAsFixed(3));
    }

    return null;
  }

  /// Fetches the screen's real width in pixels.
  @override
  Future<int?> getScreenRealWidthInPixels() async {
    final screenRealWidthInPixels =
        await methodChannel.invokeMethod<int>('getScreenRealWidthInPixels');

    return screenRealWidthInPixels;
  }

  /// Fetches the screen's real height in pixels.
  @override
  Future<int?> getScreenRealHeightInPixels() async {
    final screenRealHeightInPixels =
        await methodChannel.invokeMethod<int>('getScreenRealHeightInPixels');

    return screenRealHeightInPixels;
  }

  /// Fetches the screen's diagonal size in pixels.
  @override
  Future<int?> getScreenDiagonalInPixels() async {
    final screenDiagonalInPixels =
        await methodChannel.invokeMethod<int?>('screenDiagonalSizeInPixels');

    return screenDiagonalInPixels;
  }
}
