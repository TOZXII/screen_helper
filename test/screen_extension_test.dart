import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_helper/screen_helper.dart';

void main() {
  for (final ratio in [1.0, 2.0, 3.0]) {
    testWidgets('physical-unit round trips with pixel ratio $ratio',
        (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(devicePixelRatio: ratio),
        child: ScreenInfo(
          screenInfoData: ScreenInfoData(
            screenSizeInInches: const {'width': 3, 'height': 4},
            screenResolution: const {'width': 900, 'height': 1200},
            devicePixelRatio: ratio,
          ),
          child: Builder(builder: (context) {
            final pixelsPerInch = (300 / ratio).round();
            expect(context.inchesToPx(1), closeTo(pixelsPerInch, 1e-10));
            expect(context.mmToPx(25.4), closeTo(pixelsPerInch, 1e-10));
            expect(context.cmToPx(2.54), closeTo(pixelsPerInch, 1e-10));
            expect(context.pxToInches(pixelsPerInch), closeTo(1, 1e-10));
            expect(context.pxToMm(pixelsPerInch), closeTo(25.4, 1e-10));
            expect(context.pxToCm(pixelsPerInch), closeTo(2.54, 1e-10));
            expect(context.mmToPx(context.pxToMm(42)), closeTo(42, 1e-10));
            expect(context.cmToPx(context.pxToCm(42)), closeTo(42, 1e-10));
            expect(
                context.inchesToPx(context.pxToInches(42)), closeTo(42, 1e-10));
            expect(context.mmToPx(0), 0);
            return const SizedBox();
          }),
        ),
      ));
    });
  }

  testWidgets('converts without MediaQuery using the stored pixel ratio',
      (tester) async {
    await tester.pumpWidget(
        RawView(
          view: tester.view,
          child: ScreenInfo(
            screenInfoData: const ScreenInfoData(
              screenSizeInInches: {'width': 3, 'height': 4},
              screenResolution: {'width': 900, 'height': 1200},
              devicePixelRatio: 3,
            ),
            child: Builder(builder: (context) {
              expect(MediaQuery.maybeOf(context), isNull);
              expect(context.inchesToPx(1), 100);
              return const SizedBox();
            }),
          ),
        ),
        wrapWithView: false);
  });
}
