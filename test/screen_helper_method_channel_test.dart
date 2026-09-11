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

  test('accepts integer and double dimensions from native channels', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            channel, (_) async => {'width': 3, 'height': 4.5});
    expect(
        await platform.getScreenSizeInInches(), {'width': 3.0, 'height': 4.5});
    expect(await platform.getScreenResolution(), {'width': 3.0, 'height': 4.5});
  });

  test('preserves unavailable native measurements', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
    expect(await platform.getScreenSizeInInches(), isNull);
    expect(await platform.getScreenResolution(), isNull);
  });

  test('propagates native errors for the widget to handle', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'unavailable');
    });
    await expectLater(
        platform.getScreenSizeInInches(), throwsA(isA<PlatformException>()));
    await expectLater(
        platform.getScreenResolution(), throwsA(isA<PlatformException>()));
  });

  test('rejects malformed channel dimensions', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => {'width': 'unknown'});
    await expectLater(
        platform.getScreenSizeInInches(), throwsA(isA<TypeError>()));
    await expectLater(
        platform.getScreenResolution(), throwsA(isA<TypeError>()));
  });
}
