import 'package:flutter/widgets.dart';
import 'package:screen_helper/screen_helper_platform_interface.dart';
import 'package:screen_helper/screen_info_data.dart';

class ScreenInfo extends InheritedWidget {
  final ScreenInfoData? screenInfoData;

  const ScreenInfo(
      {super.key, required this.screenInfoData, required super.child});

  static ScreenInfoData of(BuildContext context) {
    final screenInfo = maybeOf(context);
    assert(screenInfo != null, 'No ScreenInfo found in context');
    return screenInfo!;
  }

  static ScreenInfoData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ScreenInfo>()
        ?.screenInfoData;
  }

  @override
  bool updateShouldNotify(ScreenInfo oldWidget) {
    return oldWidget.screenInfoData != screenInfoData;
  }
}

class ScreenHelperWidget extends StatefulWidget {
  final Widget child;

  const ScreenHelperWidget({
    super.key,
    required this.child,
  });

  @override
  State<ScreenHelperWidget> createState() => _ScreenHelperWidgetState();
}

class _ScreenHelperWidgetState extends State<ScreenHelperWidget>
    with WidgetsBindingObserver {
  ScreenInfoData? _screenInfoData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateScreenInfoData());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _updateScreenInfoData();
  }

  @override
  void didChangeDependencies() {
    _updateScreenInfoData();

    super.didChangeDependencies();
  }

  void _updateScreenInfoData() {
    final dpi = MediaQuery.maybeDevicePixelRatioOf(context);
    if (dpi != null) {
      _fetchAndSetScreenInfo(dpi);
    }
  }

  Future<void> _fetchAndSetScreenInfo(double dpi) async {
    final sizeInInches =
        await ScreenHelperPlatform.instance.getScreenSizeInInches();
    final resolution =
        await ScreenHelperPlatform.instance.getScreenResolution();
    if (sizeInInches != null && resolution != null) {
      setState(() {
        _screenInfoData = ScreenInfoData(
            dpi: dpi,
            screenSizeInInches: sizeInInches,
            screenResolution: resolution);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenInfo(
      screenInfoData: _screenInfoData,
      child: widget.child,
    );
  }
}
