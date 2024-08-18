import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_helper_method_channel.dart';

/// The interface that implementations of screen_helper must implement.
abstract class ScreenHelperPlatform extends PlatformInterface {
  ScreenHelperPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenHelperPlatform _instance = MethodChannelScreenHelper();

  static ScreenHelperPlatform get instance => _instance;

  static set instance(ScreenHelperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Returns the screen PPI (Pixels Per Inch) of the device.
  Future<double?> getScreenPPI() {
    throw UnimplementedError('getScreenPPI() has not been implemented.');
  }

  // Returns the screen Diagonal size in inches.
  Future<double?> getScreenDiagonalInInches() {
    throw UnimplementedError(
        'getScreenDiagonalInInches() has not been implemented.');
  }

  //Returns the screen width in inches.
  Future<double?> getScreenWidthInInches() {
    throw UnimplementedError(
        'getScreenWidthInInches() has not been implemented.');
  }

  // Returns the screen width in inches.
  Future<double?> getScreenHeightInInches() {
    throw UnimplementedError(
        'getScreenHeightInInches() has not been implemented.');
  }

  /// Returns the real screen width in pixels.
  Future<int?> getScreenRealWidthInPixels() {
    throw UnimplementedError(
        'getScreenRealWidthInPixels() has not been implemented.');
  }

  /// Returns the real screen height in pixels.
  Future<int?> getScreenRealHeightInPixels() {
    throw UnimplementedError(
        'getScreenRealHeightInPixels() has not been implemented.');
  }

  /// Returns the screen diagonal size in pixels.
  Future<int?> getScreenDiagonalInPixels() {
    throw UnimplementedError(
        'getScreenDiagonalInPixels() has not been implemented.');
  }
}
