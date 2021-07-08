import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

part 'custom_painter.dart';

class NestPatternScreen extends StatelessWidget {
  const NestPatternScreen({
    Key? key,
  }) : super(key: key);

  static const _logoDiameterFraction = 0.2;
  static const _glowThicknessFraction = 0.02;
  static const _dotsPerRing = 30;
  static const _dotRadiusFraction = 0.005;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Nest Pattern'),
        ),
        body: Center(
          child: _NestCustomPainter(
            childDiameterFraction: _logoDiameterFraction,
            glowThicknessFraction: _glowThicknessFraction,
            dotsPerRing: _dotsPerRing,
            dotRadiusFraction: _dotRadiusFraction,
            glowColor: Colors.green,
            dotsColor: Colors.black54,
            childBuilder: (childDiameter) => Align(
              alignment: Alignment.lerp(
                Alignment.centerLeft,
                Alignment.centerRight,
                0.485,
              )!,
              child: FlutterLogo(
                duration: const Duration(milliseconds: 300),
                size: childDiameter * 0.8,
              ),
            ),
          ),
        ),
      );
}
