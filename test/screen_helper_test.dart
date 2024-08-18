import 'package:flutter_test/flutter_test.dart';
import 'package:screen_helper/screen_helper.dart';
import 'package:screen_helper/screen_helper_platform_interface.dart';
import 'package:screen_helper/screen_helper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenHelperPlatform
    with MockPlatformInterfaceMixin
    implements ScreenHelperPlatform {
  @override
  Future<double?> getScreenPPI() => Future.value(42);

  @override
  Future<double?> getScreenDiagonalInInches() {
    throw UnimplementedError();
  }

  @override
  Future<double?> getScreenWidthInInches() {
    throw UnimplementedError();
  }

  @override
  Future<double?> getScreenHeightInInches() {
    throw UnimplementedError();
  }

  @override
  Future<int?> getScreenRealWidthInPixels() {
    throw UnimplementedError();
  }

  @override
  Future<int?> getScreenRealHeightInPixels() {
    throw UnimplementedError();
  }

  @override
  Future<int?> getScreenDiagonalInPixels() {
    throw UnimplementedError();
  }
}

void main() {
  final ScreenHelperPlatform initialPlatform = ScreenHelperPlatform.instance;

  test('$MethodChannelScreenHelper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenHelper>());
  });

  test('getScreenPPI', () async {
    MockScreenHelperPlatform fakePlatform = MockScreenHelperPlatform();
    ScreenHelperPlatform.instance = fakePlatform;

    expect(await ScreenHelper.getScreenPPI(), 42);
  });
}
