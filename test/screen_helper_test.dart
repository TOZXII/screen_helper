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

  tearDown(() => ScreenHelperPlatform.instance = initialPlatform);

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
      devicePixelRatio: 2.0,
    );

    expect(screenInfoData.screenWidthInInches, 5.5);
    expect(screenInfoData.screenHeightInInches, 7.0);
    expect(screenInfoData.screenWidthInPixels, 1080);
    expect(screenInfoData.screenHeightInPixels, 1920);
    expect(screenInfoData.screenAspectRatio, closeTo(0.5625, 0.0001));
    expect(screenInfoData.screenDiagonalInInches, closeTo(8.9, 0.1));
    expect(screenInfoData.ppi, closeTo(247, 1.0));
  });

  test('legacy dpi constructor and getter match devicePixelRatio', () {
    const legacy = ScreenInfoData(
      screenSizeInInches: {'width': 3, 'height': 4},
      screenResolution: {'width': 900, 'height': 1200},
      // ignore: deprecated_member_use_from_same_package
      dpi: 3,
    );
    const current = ScreenInfoData(
      screenSizeInInches: {'width': 3, 'height': 4},
      screenResolution: {'width': 900, 'height': 1200},
      devicePixelRatio: 3,
    );
    expect(legacy.devicePixelRatio, 3);
    // ignore: deprecated_member_use_from_same_package
    expect(current.dpi, 3);
    expect(legacy, current);
    expect(legacy.hashCode, current.hashCode);
  });

  test('requires exactly one pixel ratio argument', () {
    expect(
        () => ScreenInfoData(
              screenSizeInInches: const {'width': 3, 'height': 4},
              screenResolution: const {'width': 900, 'height': 1200},
            ),
        throwsAssertionError);
    expect(
        () => ScreenInfoData(
              screenSizeInInches: const {'width': 3, 'height': 4},
              screenResolution: const {'width': 900, 'height': 1200},
              devicePixelRatio: 3,
              // ignore: deprecated_member_use_from_same_package
              dpi: 3,
            ),
        throwsAssertionError);
  });

  test('compares independent maps by numeric dimensions', () {
    // Avoid const canonicalization so this exercises value equality.
    // ignore: prefer_const_constructors
    final first = ScreenInfoData(
      screenSizeInInches: {'width': 3, 'height': 4},
      screenResolution: {'width': 900, 'height': 1200},
      devicePixelRatio: 3,
    );
    // ignore: prefer_const_constructors
    final second = ScreenInfoData(
      screenSizeInInches: {'height': 4, 'width': 3},
      screenResolution: {'height': 1200, 'width': 900},
      devicePixelRatio: 3,
    );
    expect(identical(first.screenResolution, second.screenResolution), isFalse);
    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(
        first,
        isNot(const ScreenInfoData(
          screenSizeInInches: {'width': 3, 'height': 4},
          screenResolution: {'width': 1200, 'height': 900},
          devicePixelRatio: 3,
        )));
  });

  for (final value in [0.0, -1.0, double.nan, double.infinity]) {
    test('rejects invalid dimensions and ratios: $value', () {
      final invalidSize = ScreenInfoData(
        screenSizeInInches: {'width': value, 'height': 4},
        screenResolution: const {'width': 900, 'height': 1200},
        devicePixelRatio: 3,
      );
      expect(() => invalidSize.ppi, throwsArgumentError);
      final invalidResolution = ScreenInfoData(
        screenSizeInInches: const {'width': 3, 'height': 4},
        screenResolution: {'width': 900, 'height': value},
        devicePixelRatio: 3,
      );
      expect(() => invalidResolution.ppi, throwsArgumentError);
      final invalidRatio = ScreenInfoData(
        screenSizeInInches: const {'width': 3, 'height': 4},
        screenResolution: const {'width': 900, 'height': 1200},
        devicePixelRatio: value,
      );
      expect(() => invalidRatio.devicePixelRatio, throwsArgumentError);
    });
  }

  test('rejects missing dimension keys before calculating PPI', () {
    const data = ScreenInfoData(
      screenSizeInInches: {'height': 4},
      screenResolution: {'width': 900, 'height': 1200},
      devicePixelRatio: 3,
    );
    expect(() => data.ppi, throwsArgumentError);
  });
}
