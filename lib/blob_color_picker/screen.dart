import 'dart:math';

import 'package:flutter/material.dart';

part 'widget.dart';

class BlobColorPickerScreen extends StatelessWidget {
  const BlobColorPickerScreen({
    Key? key,
  }) : super(key: key);

  static final colors = <Color>[
    Colors.blue.shade200,
    Colors.red.shade300,
    Colors.yellow.shade300,
    Colors.black54,
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Circle Reveal Transition'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: _Picker(
              colors: colors,
              showSelected: true,
              // onColorSelected: (_selectedColor) {
              //   selectedColor = _selectedColor;
              // },
            ),
          ),
        ),
      );
}
