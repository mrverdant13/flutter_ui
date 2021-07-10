import 'package:flutter/material.dart';

import 'animated_flipped_card/screen.dart';
import 'blob_color_picker/screen.dart';
import 'candles_chart/screen.dart';
import 'circle_reveal_transition/screen.dart';
import 'nest_pattern/screen.dart';
import 'page_indicator/screen.dart';
import 'terminal_typewriter/screen.dart';
import 'text_scroller/screen.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter UI',
        home: _Home(),
      );
}

class _Home extends StatelessWidget {
  const _Home({
    Key? key,
  }) : super(key: key);

  static const _routes = {
    'Text Scroller': const TextScrollerScreen(),
    'Page Indicator': const PageIndicatorScreen(),
    'Circle Reveal Transition': const CircleRevealTransitionScreen(),
    'Blob Color Picker': const BlobColorPickerScreen(),
    'Nest Pattern': const NestPatternScreen(),
    'Candles Chart': const CandlesChartScree(),
    'Terminal Typewriter': const TerminalTypewriterScreen(),
    'Animated Flip Card': const AnimatedFlipCardScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI samples'),
      ),
      body: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        childAspectRatio: 3,
        padding: const EdgeInsets.all(30.0),
        children: [
          ..._routes.keys.map(
            (routeName) => TextButton(
              child: Text(
                routeName,
                textAlign: TextAlign.center,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _routes[routeName]!,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
