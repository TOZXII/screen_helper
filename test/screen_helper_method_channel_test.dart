import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_helper/screen_helper_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelScreenHelper platform = MethodChannelScreenHelper();
  const MethodChannel channel = MethodChannel('screen_helper');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getScreenSizeInInches':
            return {'width': 5.5, 'height': 7.0};
          case 'getScreenResolution':
            return {'width': 1080.0, 'height': 1920.0};
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getScreenSizeInInches', () async {
    expect(await platform.getScreenSizeInInches(), {
      'width': 5.5,
      'height': 7.0,
    });
  });

  test('getScreenResolution', () async {
    expect(await platform.getScreenResolution(),
        {'width': 1080.0, 'height': 1920.0});
  });
}
