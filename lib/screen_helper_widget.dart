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

  /// Called when measurements are unavailable, invalid, or fail to load.
  ///
  /// The last valid data remains available through [ScreenInfo.maybeOf].
  /// Before the first successful measurement, that method returns null.
  final void Function(Object error, StackTrace stackTrace)? onError;

  const ScreenHelperWidget({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  State<ScreenHelperWidget> createState() => _ScreenHelperWidgetState();
}

class _ScreenHelperWidgetState extends State<ScreenHelperWidget>
    with WidgetsBindingObserver {
  ScreenInfoData? _screenInfoData;
  int _requestId = 0;
  bool _updateScheduled = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _scheduleUpdate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleUpdate();
  }

  void _scheduleUpdate() {
    // Invalidate pending results immediately, including while a new frame is
    // still waiting to update MediaQuery after a metrics change.
    _requestId++;
    if (_updateScheduled) return;
    _updateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScheduled = false;
      if (!mounted) return;
      _fetchAndSetScreenInfo(_requestId);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> _fetchAndSetScreenInfo(int requestId) async {
    try {
      final devicePixelRatio = MediaQuery.maybeDevicePixelRatioOf(context) ??
          View.of(context).devicePixelRatio;
      final platform = ScreenHelperPlatform.instance;
      final measurements = await Future.wait([
        Future.sync(platform.getScreenSizeInInches),
        Future.sync(platform.getScreenResolution),
      ], eagerError: true);
      if (!mounted || requestId != _requestId) return;

      final sizeInInches = measurements[0];
      final resolution = measurements[1];
      if (sizeInInches == null || resolution == null) {
        throw StateError('Screen measurements are unavailable.');
      }
      final next = ScreenInfoData(
        devicePixelRatio: devicePixelRatio,
        screenSizeInInches: Map.unmodifiable(sizeInInches),
        screenResolution: Map.unmodifiable(resolution),
      );
      // Validate before publishing data to widgets or performing conversions.
      final ppi = next.ppi;
      if (!ppi.isFinite || ppi <= 0 || next.devicePixelRatio <= 0) {
        throw StateError('Screen measurements must be positive and finite.');
      }
      if (next != _screenInfoData) {
        setState(() => _screenInfoData = next);
      }
    } catch (error, stackTrace) {
      if (!mounted || requestId != _requestId) return;
      widget.onError?.call(error, stackTrace);
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
