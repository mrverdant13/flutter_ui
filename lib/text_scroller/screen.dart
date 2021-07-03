import 'dart:ui' as ui;

import 'package:flutter/material.dart';

part 'widgets.dart';
part 'custom_painter.dart';

enum _LabelDirection {
  topDown,
  bottomUp,
}

class TextScrollerScreen extends StatelessWidget {
  const TextScrollerScreen({
    Key? key,
  }) : super(key: key);

  static const List<String> _labels = [
    'Flutter',
    'Dart',
    'Android',
    'iOS',
    'Fuchsia',
    'Windows',
    'MacOS',
    'Linux',
    'Web'
  ];

  static const _fontSize = 85.0;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.blue.shade300,
        appBar: AppBar(
          title: const Text('Text Scroller'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isHorizontal = constraints.maxWidth > 1100;
            return Center(
              child: SingleChildScrollView(
                child: Flex(
                  direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: isHorizontal
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Widgets',
                              style: Theme.of(context).textTheme.headline2,
                              maxLines: 1,
                            ),
                            Divider(),
                            _WidgetsOnly(
                              labels: _labels,
                              fontSize: _fontSize,
                              direction: _LabelDirection.topDown,
                            ),
                            Divider(),
                            _WidgetsOnly(
                              labels: _labels,
                              fontSize: _fontSize,
                              direction: _LabelDirection.bottomUp,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Custom Painter',
                              style: Theme.of(context).textTheme.headline2,
                              maxLines: 1,
                            ),
                            Divider(),
                            _CustomPainterOnly(
                              labels: _labels,
                              fontSize: _fontSize,
                              direction: _LabelDirection.topDown,
                            ),
                            Divider(),
                            _CustomPainterOnly(
                              labels: _labels,
                              fontSize: _fontSize,
                              direction: _LabelDirection.bottomUp,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
