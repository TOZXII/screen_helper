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
    final screenInfo = ScreenInfo.of(context);

    // Use the extension method to convert mm to pixels
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
          "Line length in pixels: ${lineLengthInPixels.toStringAsFixed(2)}",
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
