import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'custom_painter.dart';
part 'mock_data.dart';

class CircleRevealTransitionScreen extends StatelessWidget {
  const CircleRevealTransitionScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Circle Reveal Transition'),
        ),
        body: const _CustomPainter(
          pagesData: pagesData,
        ),
      );
}
