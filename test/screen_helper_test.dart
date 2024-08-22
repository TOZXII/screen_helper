import 'package:flutter_test/flutter_test.dart';
import 'package:screen_helper/screen_helper.dart';
import 'package:screen_helper/screen_helper_platform_interface.dart';
import 'package:screen_helper/screen_helper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenHelperPlatform
    with MockPlatformInterfaceMixin
    implements ScreenHelperPlatform {
  @override
  Future<Map<String, double>?> getScreenSizeInInches() async {
    return {
      'width': 5.5,
      'height': 7.0,
    };
  }

  @override
  Future<Map<String, double>?> getScreenResolution() async {
    return {'width': 1080, 'height': 1920};
  }
}

void main() {
  final ScreenHelperPlatform initialPlatform = ScreenHelperPlatform.instance;

  test('$MethodChannelScreenHelper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenHelper>());
  });

  test('getScreenSizeInInches', () async {
    MockScreenHelperPlatform fakePlatform = MockScreenHelperPlatform();
    ScreenHelperPlatform.instance = fakePlatform;

    expect(await fakePlatform.getScreenSizeInInches(),
        {'width': 5.5, 'height': 7.0});
  });

  test('getScreenResolution', () async {
    MockScreenHelperPlatform fakePlatform = MockScreenHelperPlatform();
    ScreenHelperPlatform.instance = fakePlatform;

    expect(await fakePlatform.getScreenResolution(),
        {'width': 1080, 'height': 1920});
  });

  test('ScreenInfoData calculations', () {
    const screenInfoData = ScreenInfoData(
      screenSizeInInches: {'width': 5.5, 'height': 7.0},
      screenResolution: {'width': 1080, 'height': 1920},
      dpi: 2.0,
    );

    expect(screenInfoData.screenWidthInInches, 5.5);
    expect(screenInfoData.screenHeightInInches, 7.0);
    expect(screenInfoData.screenWidthInPixels, 1080);
    expect(screenInfoData.screenHeightInPixels, 1920);
    expect(screenInfoData.screenAspectRatio, closeTo(0.5625, 0.0001));
    expect(screenInfoData.screenDiagonalInInches, closeTo(8.9, 0.1));
    expect(screenInfoData.ppi, closeTo(247, 1.0));
  });
}
