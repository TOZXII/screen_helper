import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_helper_platform_interface.dart';

/// An implementation of [ScreenHelperPlatform] that uses method channels.
class MethodChannelScreenHelper extends ScreenHelperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_helper');

  /// Fetches the screen size in inches (width and height).
  @override
  Future<Map<String, double>?> getScreenSizeInInches() async {
    final Map<dynamic, dynamic>? result = await methodChannel
        .invokeMethod<Map<dynamic, dynamic>>('getScreenSizeInInches');
    if (result != null) {
      return {
        'width': result['width'] as double,
        'height': result['height'] as double,
      };
    }
    return null;
  }

  /// Fetches the screen resolution in pixels (width and height).
  @override
  Future<Map<String, double>?> getScreenResolution() async {
    final Map<dynamic, dynamic>? result = await methodChannel
        .invokeMethod<Map<dynamic, dynamic>>('getScreenResolution');
    if (result != null) {
      return {
        'width': result['width'],
        'height': result['height'],
      };
    }
    return null;
  }
}
