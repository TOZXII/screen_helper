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

  /// Returns the screen size in inches (width and height).
  Future<Map<String, double>?> getScreenSizeInInches() {
    throw UnimplementedError(
        'getScreenSizeInInches() has not been implemented.');
  }

  /// Returns the screen resolution in pixels (width and height).
  Future<Map<String, double>?> getScreenResolution() {
    throw UnimplementedError('getScreenResolution() has not been implemented.');
  }
}
