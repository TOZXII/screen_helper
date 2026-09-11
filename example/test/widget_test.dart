import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_helper_example/main.dart';

void main() {
  const channel = MethodChannel('screen_helper');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getScreenSizeInInches':
          return {'width': 3.0, 'height': 4.0};
        case 'getScreenResolution':
          return {'width': 900.0, 'height': 1200.0};
        default:
          throw MissingPluginException();
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('loads measurements and updates the ruler', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Screen PPI: 300.00'), findsOneWidget);
    expect(find.text('Screen Diagonal Size (in inches): 5.00'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Line length in logical pixels: 177.17'), findsOneWidget);

    tester.widget<Slider>(find.byType(Slider)).onChanged!(25.4);
    await tester.pump();
    expect(find.text('Line length: 25.4 mm'), findsOneWidget);
    expect(find.text('Line length in logical pixels: 300.00'), findsOneWidget);
    final line = tester.widget<Container>(find.byWidgetPredicate(
      (widget) => widget is Container && widget.color == Colors.black,
    ));
    expect(line.constraints!.maxWidth, closeTo(300, 1e-10));
    expect(tester.takeException(), isNull);
  });
}
