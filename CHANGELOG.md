## 1.2.3

- Guard widget updates after disposal, coalesce refreshes, and ignore stale
  responses. Add an optional `onError` callback while retaining the last valid
  measurements after failures.
- Fall back to the current Flutter view when no `MediaQuery` is available.
- Refresh Android dimensions and density on every measurement request and report
  physical dimensions as unavailable when density is invalid.
- Correct iPad mini 6 to an 8.3-inch diagonal and report unknown iOS models as
  unavailable instead of returning zero physical dimensions.
- Reject invalid dimensions and ratios; accept integer or double native values.
- Add `devicePixelRatio`, retaining deprecated `dpi` constructor/property aliases,
  and clarify that unit conversions use Flutter logical pixels.
- Compare measurements by numeric value and expose unmodifiable dimension
  snapshots from `ScreenHelperWidget`.
- Add lifecycle, error, conversion, Android, and iOS regression tests and replace
  stale example tests.
- Run package and example verification on pull requests, pushes to main, and
  release tags; keep pub.dev publishing restricted to verified version tags.

## 1.2.2

- Updated the README.md file.

## 1.2.1

- Updated Android Java compatibility targets to Java 11 and aligned the Kotlin
  JVM target when the Kotlin Android plugin is enabled.
- Updated the example Android toolchain to AGP 8.10.1 and Gradle 8.11.1, using
  Flutter's supported example-app minSdk.
- Removed the redundant Android manifest package attribute now supplied by the
  module namespace.
- Isolated the pre-Android 11 display-metrics fallback so its required legacy
  API use no longer emits a package-wide deprecation notice.

## 1.2.0

- Added support to the new iPhones 17

## 1.1.0

- Added support to the new Iphones and Ipads.

## 1.0.1

- Added support to the new Iphones and Ipads.

## 1.0.0

- changed the implementation to use inherited widget. so you can access the screen information from any widget in the widget tree.
- changed method to convert to be an extension method. so you can use it like `context.mmToPx(15)`
- added support to get the screen diagonal in pixels.
- added support to convert pixels to mm.
- added support to convert inches to pixels and pixels to inches.
- added support to convert cm to pixels and pixels to cm.

## 0.0.3

- Updated README.md file.

## 0.0.2

- Updated README.md file.

## 0.0.1

- Added support to get device PPI.
- Added support to get device screen size (width, hight and diagonal). in inches.
- Added support to get device screen resolution (width and hight). in pixels.
- Added support to convert mm to pixels.
