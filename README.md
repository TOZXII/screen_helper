
![Pub Version](https://img.shields.io/pub/v/screen_helper?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/TOZXII/screen_helper?style=plastic)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/TOZXII/screen_helper?style=plastic&label=Github%20Issues)
![GitHub repo size](https://img.shields.io/github/repo-size/TOZXII/screen_helper?style=plastic)



# screen_helper:


####  A package that provides essential tools for Flutter developers to access device screen details, including PPI, screen size in inches, resolution in pixels, and conversion from millimeters to pixels.

## Table of Contents
- [Features](#-features)
- [Getting Started](#-getting-Started)
- [Usage](#-usage)
- [Example](#-example)


## Features
- Get screen PPI (Pixels Per Inch).
- Get screen width and height and diagonal size in pixels.
- Get screen width and height and diagonal size in inches.
- Convert millimeters to pixels.

<img alt="App example" src="https://i.imgur.com/LpcK2jq.png" />

## Getting Started
In your flutter project add the dependency:

```yaml
dependencies:
  screen_helper: ^0.0.2
```

## Usage
```dart
import 'package:screen_helper/screen_helper.dart';
```

### Get screen PPI (Pixels Per Inch)
```dart
double? ppi = ScreenHelper.getScreenPPI();
```

### Get screen width and height and diagonal size in pixels
```dart
double? screenWidth = ScreenHelper.getScreenRealWidthInPixels();
double? screenHeight = ScreenHelper.getScreenRealHeightInPixels();
double? screenDiagonal = ScreenHelper.getScreenDiagonalInPixels();
```

### Get screen width and height and diagonal size in inches
```dart
double? screenWidthInches = ScreenHelper.getScreenWidthInInches();
double? screenHeightInches = ScreenHelper.getScreenHeightInInches();
double? screenDiagonalInches = ScreenHelper.getScreenDiagonalInInches();
```

### Convert millimeters to pixels
```dart
double? millimeters = 10;
double? pixels;
ScreenHelper.mmToPixels(millimeters).then((value) {
  pixels = value;
});
```
> [!IMPORTANT]
> The function `mmToPixels` must be called inside a build method as the widget tree is fully built or it can be called in after the first frame is rendered using `WidgetsBinding.instance.addPostFrameCallback`.


## Example
```dart
import 'package:flutter/material.dart';
import 'package:screen_helper/screen_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double? _screenPPI;
  double? _screenDiagonalInInches;
  double? _screenWidthInInches;
  double? _screenHeightInInches;
  int? _screenRealWidthInPixels;
  int? _screenRealHeightInPixels;
  int? _screenDiagonalInPixels;

  double? _lineLengthInPixels;

  @override
  void initState() {
    super.initState();
    _fetchScreenData();
  }

  Future<void> _fetchScreenData() async {
    // Fetch all screen data asynchronously
    final double? ppi = await ScreenHelper.getScreenPPI();
    final double? diagonalInches =
        await ScreenHelper.getScreenDiagonalInInches();
    final double? widthInches = await ScreenHelper.getScreenWidthInInches();
    final double? heightInches = await ScreenHelper.getScreenHeightInInches();
    final int? widthPixels = await ScreenHelper.getScreenRealWidthInPixels();
    final int? heightPixels = await ScreenHelper.getScreenRealHeightInPixels();
    final int? diagonalPixels = await ScreenHelper.getScreenDiagonalInPixels();

    // Update the state with the fetched data
    setState(() {
      _screenPPI = ppi;
      _screenDiagonalInInches = diagonalInches;
      _screenWidthInInches = widthInches;
      _screenHeightInInches = heightInches;
      _screenRealWidthInPixels = widthPixels;
      _screenRealHeightInPixels = heightPixels;
      _screenDiagonalInPixels = diagonalPixels;
    });
  }

  @override
  Widget build(BuildContext context) {
    // function mmToPixels must be called inside a build method as the widget tree is fully built
    // or it can be called in after the first frame is rendered using WidgetsBinding.instance.addPostFrameCallback
    ScreenHelper.mmToPixels(15, context).then((value) {
      setState(() {
        _lineLengthInPixels = value;
      });
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Screen Helper Example App'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Screen PPI: $_screenPPI',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Screen Diagonal Size (in inches): $_screenDiagonalInInches',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Screen Width (in inches): $_screenWidthInInches',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Screen Height (in inches): $_screenHeightInInches',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Screen Real Width (in pixels): $_screenRealWidthInPixels',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Screen Real Height (in pixels): $_screenRealHeightInPixels',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Screen Diagonal Size (in pixels): $_screenDiagonalInPixels',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  "line length 15mm",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "line length in pixels: $_lineLengthInPixels",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                if (_lineLengthInPixels != null)
                  Center(
                    child: Container(
                      width: _lineLengthInPixels,
                      height: 2.0,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


