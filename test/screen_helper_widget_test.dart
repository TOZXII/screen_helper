import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_helper/screen_helper.dart';
import 'package:screen_helper/screen_helper_platform_interface.dart';

const _size = {'width': 3.0, 'height': 4.0};
const _resolution = {'width': 900.0, 'height': 1200.0};

class _PendingPlatform extends ScreenHelperPlatform {
  final sizes = <Completer<Map<String, double>?>>[];
  final resolutions = <Completer<Map<String, double>?>>[];

  @override
  Future<Map<String, double>?> getScreenSizeInInches() {
    final completer = Completer<Map<String, double>?>();
    sizes.add(completer);
    return completer.future;
  }

  @override
  Future<Map<String, double>?> getScreenResolution() {
    final completer = Completer<Map<String, double>?>();
    resolutions.add(completer);
    return completer.future;
  }

  void complete(
    int index, {
    Map<String, double>? size = _size,
    Map<String, double>? resolution = _resolution,
  }) {
    sizes[index].complete(size);
    resolutions[index].complete(resolution);
  }

  void fail(int index, Object error) {
    sizes[index].completeError(error);
    resolutions[index].complete(_resolution);
  }
}

class _ThrowingPlatform extends ScreenHelperPlatform {
  @override
  Future<Map<String, double>?> getScreenSizeInInches() {
    throw PlatformException(code: 'synchronous-failure');
  }

  @override
  Future<Map<String, double>?> getScreenResolution() async {
    throw PlatformException(code: 'asynchronous-failure');
  }
}

void main() {
  late ScreenHelperPlatform original;
  late _PendingPlatform platform;
  ScreenInfoData? observed;
  late List<Object> errors;
  var builds = 0;

  Widget subject({bool reportErrors = true}) => ScreenHelperWidget(
        onError: reportErrors ? (error, stackTrace) => errors.add(error) : null,
        child: Builder(builder: (context) {
          observed = ScreenInfo.maybeOf(context);
          builds++;
          return const SizedBox();
        }),
      );

  setUp(() {
    original = ScreenHelperPlatform.instance;
    platform = _PendingPlatform();
    ScreenHelperPlatform.instance = platform;
    observed = null;
    errors = [];
    builds = 0;
  });

  tearDown(() => ScreenHelperPlatform.instance = original);

  testWidgets('initializes once above MaterialApp', (tester) async {
    await tester.pumpWidget(ScreenHelperWidget(
      child: MaterialApp(home: Builder(builder: (context) {
        observed = ScreenInfo.maybeOf(context);
        return const SizedBox();
      })),
    ));
    expect(observed, isNull);
    expect(platform.sizes, hasLength(1));
    expect(platform.resolutions, hasLength(1));
    platform.complete(0);
    await tester.pumpAndSettle();
    expect(observed!.ppi, 300);
    expect(platform.sizes, hasLength(1));
  });

  testWidgets('uses the Flutter view when MediaQuery is absent',
      (tester) async {
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      RawView(view: tester.view, child: subject()),
      wrapWithView: false,
    );
    platform.complete(0);
    await tester.pumpAndSettle();
    expect(observed!.devicePixelRatio, 3);
    expect(observed!.ppi, 300);
    tester.view.devicePixelRatio = 4;
    await tester.pumpAndSettle();
    platform.complete(1);
    await tester.pumpAndSettle();
    expect(observed!.devicePixelRatio, 4);
  });

  testWidgets('completion after disposal does not call setState',
      (tester) async {
    await tester.pumpWidget(subject());
    await tester.pumpWidget(const SizedBox());
    platform.complete(0);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(errors, isEmpty);
  });

  testWidgets('failure after disposal does not invoke onError', (tester) async {
    await tester.pumpWidget(subject());
    await tester.pumpWidget(const SizedBox());
    platform.fail(0, PlatformException(code: 'detached'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(errors, isEmpty);
  });

  testWidgets('new metrics win over an older pending response', (tester) async {
    await tester.pumpWidget(subject());
    tester.view.devicePixelRatio = 4;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpAndSettle();
    expect(platform.sizes, hasLength(2));
    platform.complete(1, resolution: {'width': 1200, 'height': 1600});
    await tester.pumpAndSettle();
    expect(observed!.ppi, 400);
    expect(observed!.devicePixelRatio, 4);
    platform.complete(0);
    await tester.pumpAndSettle();
    expect(observed!.ppi, 400);
    expect(observed!.devicePixelRatio, 4);
  });

  testWidgets('ignores failures from superseded requests', (tester) async {
    await tester.pumpWidget(subject());
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();
    platform.complete(1);
    await tester.pumpAndSettle();
    platform.fail(0, PlatformException(code: 'old-request'));
    await tester.pumpAndSettle();
    expect(observed!.ppi, 300);
    expect(errors, isEmpty);
  });

  testWidgets('identical measurements do not rebuild dependents',
      (tester) async {
    await tester.pumpWidget(subject());
    platform.complete(0);
    await tester.pumpAndSettle();
    final previousBuilds = builds;
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();
    platform.complete(1, size: Map.of(_size), resolution: Map.of(_resolution));
    await tester.pumpAndSettle();
    expect(builds, previousBuilds);
  });

  testWidgets('retains data on errors and recovers on a later refresh',
      (tester) async {
    await tester.pumpWidget(subject());
    platform.complete(0);
    await tester.pumpAndSettle();
    final previous = observed;
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();
    final error = PlatformException(code: 'detached');
    platform.fail(1, error);
    await tester.pumpAndSettle();
    expect(observed, same(previous));
    expect(errors, [error]);
    expect(tester.takeException(), isNull);
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();
    platform.complete(2, resolution: {'width': 1200, 'height': 1600});
    await tester.pumpAndSettle();
    expect(observed!.ppi, 400);
  });

  testWidgets('missing plugins are handled without an error callback',
      (tester) async {
    await tester.pumpWidget(subject(reportErrors: false));
    platform.fail(0, MissingPluginException());
    await tester.pumpAndSettle();
    expect(observed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reports errors without waiting for the other native request',
      (tester) async {
    await tester.pumpWidget(subject());
    final error = PlatformException(code: 'unavailable');
    platform.sizes[0].completeError(error);
    await tester.pumpAndSettle();
    expect(errors, [error]);
    expect(observed, isNull);
    platform.resolutions[0]
        .completeError(PlatformException(code: 'late-error'));
    await tester.pumpAndSettle();
    expect(errors, [error]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('handles synchronous and asynchronous platform failures together',
      (tester) async {
    ScreenHelperPlatform.instance = _ThrowingPlatform();
    await tester.pumpWidget(subject());
    await tester.pumpAndSettle();
    expect(errors, hasLength(1));
    expect(errors.single, isA<PlatformException>());
    expect(observed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('coalesces multiple metrics events into one refresh',
      (tester) async {
    await tester.pumpWidget(subject());
    platform.complete(0);
    await tester.pumpAndSettle();
    tester.binding.handleMetricsChanged();
    tester.binding.handleMetricsChanged();
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();
    expect(platform.sizes, hasLength(2));
    expect(platform.resolutions, hasLength(2));
    platform.complete(1);
    await tester.pumpAndSettle();
  });

  for (final value in [null, 0.0, -1.0, double.nan, double.infinity]) {
    testWidgets('rejects unavailable or invalid dimensions: $value',
        (tester) async {
      await tester.pumpWidget(subject());
      platform.complete(0,
          size: value == null ? null : {'width': value, 'height': 4});
      await tester.pumpAndSettle();
      expect(observed, isNull);
      expect(errors, hasLength(1));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('unavailable resolution retains the previous data',
      (tester) async {
    await tester.pumpWidget(subject());
    platform.complete(0);
    await tester.pumpAndSettle();
    final previous = observed;
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();
    platform.complete(1, resolution: null);
    await tester.pumpAndSettle();
    expect(observed, same(previous));
    expect(errors, hasLength(1));
  });

  testWidgets('published dimensions are snapshots of the platform maps',
      (tester) async {
    await tester.pumpWidget(subject());
    final size = Map.of(_size);
    platform.complete(0, size: size);
    await tester.pumpAndSettle();
    size['width'] = 99;
    expect(observed!.screenWidthInInches, 3);
    expect(
        () => observed!.screenResolution['width'] = 99, throwsUnsupportedError);
  });
}
