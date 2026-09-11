![Pub Version](https://img.shields.io/pub/v/screen_helper?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/TOZXII/screen_helper?style=plastic)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/TOZXII/screen_helper?style=plastic&label=Github%20Issues)
![GitHub repo size](https://img.shields.io/github/repo-size/TOZXII/screen_helper?style=plastic)

# screen_helper:

#### A package that provides essential tools for Flutter developers to access device screen details, including PPI, screen size in inches, resolution in pixels, and conversion from millimeters to pixels.

## Table of Contents

- [Features](#-features)
- [Getting Started](#-getting-Started)
- [Usage](#-usage)
- [Example](#-example)

## Features

- Get screen PPI (Pixels Per Inch).
- Get screen width and height and diagonal size in pixels.
- Get screen width and height and diagonal size in inches.
- Convert millimeters to pixels and vice versa.
- Convert inches to pixels and vice versa.
- Convert centimeters to pixels and vice versa.

<img alt="App example" src="https://i.imgur.com/ksFQKLx.png" />

## Getting Started

In your flutter project add the dependency:

```yaml
dependencies:
  screen_helper: ^1.2.2
```

## Usage

Wrap your app with `ScreenHelperWidget` to provide screen information to all descendant widgets:

The wrapper can sit above `MaterialApp`. Measurements load asynchronously and
refresh when screen metrics change.

```dart
import 'package:screen_helper/screen_helper.dart';
```

```dart
void main() {
  runApp(
    /// Wrap your app with ScreenHelperWidget to provide screen information
    /// to all descendant widgets
    ScreenHelperWidget(
      child: const MyApp(),
    ),
  );
}


```

### Access screen information

To get screen information, use `ScreenInfo.maybeOf(context)`

```dart
final screenInfo = ScreenInfo.maybeOf(context);
```

This returns `null` until a valid measurement is available. Check for `null`
before reading the fields. Use `ScreenInfo.of(context)` only once data is ready.

You can handle unavailable measurements and platform errors through `onError`:

```dart
ScreenHelperWidget(
  onError: (error, stackTrace) {
    debugPrint('Screen measurements unavailable: $error');
  },
  child: const MyApp(),
)
```

A failed refresh preserves the last valid data. If the first request fails,
`ScreenInfo.maybeOf(context)` remains `null`; use `onError` to show an appropriate
fallback in your app. Unknown iOS models report unavailable physical dimensions
instead of zero dimensions or infinite PPI. Android measurements with invalid
physical density are also unavailable.

Screen resolution is measured in **physical pixels**. Conversion methods such
as `mmToPx` use **Flutter logical pixels**, suitable for widget widths and
heights. `devicePixelRatio` is the number of physical pixels per logical pixel;
it is not a density in dots per inch. The old `dpi` property and constructor
argument remain available as deprecated aliases.

When constructing `ScreenInfoData`, supply exactly one of `devicePixelRatio` or
the legacy `dpi` argument. Dimensions and ratios must be positive and finite.
Treat dimension maps as immutable; data supplied by the wrapper uses unmodifiable
snapshots and compares dimensions by value.

Physical sizes are estimates based on Android's reported display density or the
iOS model's listed diagonal. Android 11 and later report current window bounds;
older Android versions report display metrics, and iOS reports native display
bounds. In split-screen mode, the reported Android window size can therefore
differ from the full display size.

#### available data:

```dart
/// Get screen size in inches {width: , height: }
final Map<String, double> screenSizeInInches = screenInfo.screenSizeInInches;

/// Get screen resolution in pixels {width: , height: }
final Map<String, double> screenResolution = screenInfo.screenResolution;
/// Get physical pixels per Flutter logical pixel
final double devicePixelRatio = screenInfo.devicePixelRatio;

/// Get screen pixel per inch
final double ppi = screenInfo.ppi;

/// Get screen width in inches
final double screenWidthInInches = screenInfo.screenWidthInInches;

/// Get screen height in inches
final double screenHeightInInches = screenInfo.screenHeightInInches;

/// Get screen diagonal size in inches
final double screenDiagonalInInches = screenInfo.screenDiagonalInInches;

/// Get screen width in pixels
final double screenWidthInPixels = screenInfo.screenWidthInPixels;

/// Get screen height in pixels
final double screenHeightInPixels = screenInfo.screenHeightInPixels;

/// Get screen aspect ratio
final double screenAspectRatio = screenInfo.screenAspectRatio;
```

#### Convert from one unit to another

Once screen data is available, use the extension methods on `BuildContext`:

```dart
// Convert physical units to Flutter logical pixels.
final double fromMm = context.mmToPx(25.4);
final double fromCm = context.cmToPx(2.54);
final double fromInches = context.inchesToPx(1.0);

// Convert integer Flutter logical pixels to physical units.
final double inMm = context.pxToMm(100);
final double inCm = context.pxToCm(100);
final double inInches = context.pxToInches(100);
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:screen_helper/screen_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap your app with ScreenHelperWidget to provide screen information
    // to all descendant widgets
    return ScreenHelperWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Screen Helper Example App'),
          ),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ScreenInfoDisplay(),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenInfoDisplay extends StatefulWidget {
  const ScreenInfoDisplay({super.key});

  @override
  State<ScreenInfoDisplay> createState() => _ScreenInfoDisplayState();
}

class _ScreenInfoDisplayState extends State<ScreenInfoDisplay> {
  double _lineLengthMm = 15.0;

  @override
  Widget build(BuildContext context) {
    // Access screen information using ScreenInfo.of(context)
    final screenInfo = ScreenInfo.maybeOf(context);
    if (screenInfo == null) {
      return const CircularProgressIndicator();
    }

    // Flutter layout dimensions use logical pixels.
    final lineLengthInPixels = context.mmToPx(_lineLengthMm);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Display various screen properties
        Text(
          'Screen PPI: ${screenInfo.ppi.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Screen Diagonal Size (in inches): ${screenInfo.screenDiagonalInInches.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Screen Width (in inches): ${screenInfo.screenWidthInInches.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Screen Height (in inches): ${screenInfo.screenHeightInInches.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Screen Real Width (in pixels): ${screenInfo.screenWidthInPixels.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Screen Real Height (in pixels): ${screenInfo.screenHeightInPixels.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          "Line length: ${_lineLengthMm.toStringAsFixed(1)} mm",
          style: const TextStyle(fontSize: 16),
        ),
        Slider(
          value: _lineLengthMm,
          min: 1,
          max: 100,
          divisions: 99,
          label: _lineLengthMm.round().toString(),
          onChanged: (double value) {
            setState(() {
              _lineLengthMm = value;
            });
          },
        ),
        const SizedBox(height: 10),
        Text(
          "Line length in logical pixels: ${lineLengthInPixels.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        // Display a line with the converted length
        Center(
          child: Container(
            width: lineLengthInPixels,
            height: 2.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

```

## Contributing

We welcome contributions to the `screen_helper` package! If you'd like to contribute, here are some guidelines to help you get started:

### How to Contribute

1. **Fork the Repository:**

- Start by forking the [GitHub repository](https://github.com/TOZXII/screen_helper) and creating a new branch for your feature or bug fix.

2. **Clone Your Fork:**

- Clone your forked repository to your local machine.
  ```sh
  git clone https://github.com/your-username/screen_helper.git
  cd screen_helper
  ```

3. **Create a Branch:**

- Create a new branch for your feature or bug fix.
  ```sh
  git checkout -b feature/your-feature-name
  ```

4. **Make Changes:**

- Make your changes in your branch. Ensure your code follows the existing style and conventions used in the project.

5. **Test Your Changes:**

- Test your changes thoroughly. If you've added new features or fixed bugs, include tests where appropriate.

6. **Commit and Push:**

- Commit your changes with a clear commit message.
  ```sh
  git add .
  git commit -m "Description of the changes you made"
  git push origin feature/your-feature-name
  ```

7. **Submit a Pull Request:**

- Open a pull request from your branch on GitHub. Provide a clear description of what you've done and reference any related issues.
