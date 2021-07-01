import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TextScrollerScreen extends StatelessWidget {
  const TextScrollerScreen({
    Key? key,
  }) : super(key: key);

  static const List<String> _labels = [
    'gjl',
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
        appBar: AppBar(
          title: const Text('Text Scroller'),
        ),
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Widgets',
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 1,
                  ),
                  Divider(),
                  Container(
                    color: Colors.red,
                    child: _WidgetsOnly(
                      labels: _labels,
                      fontSize: _fontSize,
                      direction: _LabelDirection.topDown,
                    ),
                  ),
                  Divider(),
                  Container(
                    color: Colors.red,
                    child: _WidgetsOnly(
                      labels: _labels,
                      fontSize: _fontSize,
                      direction: _LabelDirection.bottomUp,
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Custom Painter',
                    style: Theme.of(context).textTheme.headline2,
                    maxLines: 1,
                  ),
                  Divider(),
                  Container(
                    color: Colors.red,
                    child: _CustomPainterOnly(
                      labels: _labels,
                      fontSize: _fontSize,
                      direction: _LabelDirection.topDown,
                    ),
                  ),
                  Divider(),
                  Container(
                    color: Colors.red,
                    child: _CustomPainterOnly(
                      labels: _labels,
                      fontSize: _fontSize,
                      direction: _LabelDirection.bottomUp,
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      );
}

enum _LabelDirection {
  topDown,
  bottomUp,
}

class _WidgetsOnly extends StatefulWidget {
  const _WidgetsOnly({
    Key? key,
    required this.labels,
    this.textColor = Colors.black,
    this.fontSize = 16.0,
    this.duration = const Duration(seconds: 2),
    this.idleTimeFraction = 0.5,
    this.direction = _LabelDirection.topDown,
  })  : assert(idleTimeFraction >= 0.0 && idleTimeFraction <= 1.0),
        super(key: key);

  final List<String> labels;
  final Color textColor;
  final double fontSize;
  final double idleTimeFraction;
  final Duration duration;
  final _LabelDirection direction;

  @override
  _WidgetsOnlyState createState() => _WidgetsOnlyState();
}

class _WidgetsOnlyState extends State<_WidgetsOnly>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Curve _awaiterCurve;

  @override
  void initState() {
    super.initState();
    _awaiterCurve = Interval(widget.idleTimeFraction, 1.0);
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _updateLabelIdx();
            _animationController.forward(from: 0.0);
          }
        },
      )
      ..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _activeLabelIdx = 0;
  int get _nextLabelIdx => _secureIdx(_activeLabelIdx + 1);
  int _secureIdx(int initialIdx) => initialIdx % widget.labels.length;
  void _updateLabelIdx() => setState(() {
        _activeLabelIdx++;
        _activeLabelIdx = _secureIdx(_activeLabelIdx);
      });

  Offset _offset({
    required bool isActive,
  }) {
    final offsetMagnitude = _awaiterCurve.transform(_animationController.value);
    final activeAdditionalOffset = isActive ? 0.0 : 1.0;
    switch (widget.direction) {
      case _LabelDirection.topDown:
        return Offset(0.0, offsetMagnitude - activeAdditionalOffset);
      case _LabelDirection.bottomUp:
        return Offset(0.0, -offsetMagnitude + activeAdditionalOffset);
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: ClipRect(
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                widget.textColor,
                widget.textColor,
                Colors.transparent,
              ],
              stops: [
                0,
                0.15,
                0.85,
                1,
              ],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              children: [
                _Label(
                  color: widget.textColor,
                  label: widget.labels[_activeLabelIdx],
                  offset: _offset(isActive: true),
                  fontSize: widget.fontSize,
                ),
                _Label(
                  color: widget.textColor,
                  label: widget.labels[_nextLabelIdx],
                  offset: _offset(isActive: false),
                  fontSize: widget.fontSize,
                ),
              ],
            ),
          ),
        ),
      );
}

class _Label extends StatelessWidget {
  const _Label({
    Key? key,
    required this.color,
    required this.label,
    required this.offset,
    required this.fontSize,
  }) : super(key: key);

  final String label;
  final Color color;
  final Offset offset;
  final double fontSize;

  @override
  Widget build(BuildContext context) => FractionalTranslation(
        translation: offset,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
          ),
        ),
      );
}

class _CustomPainterOnly extends StatefulWidget {
  const _CustomPainterOnly({
    Key? key,
    required this.labels,
    this.textColor = Colors.black,
    this.fontSize = 16.0,
    this.duration = const Duration(seconds: 2),
    this.idleTimeFraction = 0.5,
    this.direction = _LabelDirection.topDown,
  })  : assert(idleTimeFraction >= 0.0 && idleTimeFraction <= 1.0),
        super(key: key);

  final List<String> labels;
  final Color textColor;
  final double fontSize;
  final double idleTimeFraction;
  final Duration duration;
  final _LabelDirection direction;

  @override
  _CustomPainterOnlyState createState() => _CustomPainterOnlyState();
}

class _CustomPainterOnlyState extends State<_CustomPainterOnly>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Curve _awaiterCurve;

  @override
  void initState() {
    super.initState();
    _awaiterCurve = Interval(widget.idleTimeFraction, 1.0);
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _updateLabelIdx();
            _animationController.forward(from: 0.0);
          }
        },
      )
      ..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _activeLabelIdx = 0;
  int _secureIdx(int initialIdx) => initialIdx % widget.labels.length;
  int get _nextLabelIdx => _secureIdx(_activeLabelIdx + 1);
  void _updateLabelIdx() => setState(() {
        _activeLabelIdx++;
        _activeLabelIdx = _secureIdx(_activeLabelIdx);
      });

  @override
  Widget build(BuildContext context) => Center(
        child: CustomPaint(
          size: Size.fromHeight(widget.fontSize * 1.32),
          painter: _TextScrollerPainter(
            fontSize: widget.fontSize,
            activeLabel: widget.labels[_activeLabelIdx],
            nextLabel: widget.labels[_nextLabelIdx],
            progress: _awaiterCurve.transform(_animationController.value),
            direction: widget.direction,
            textColor: widget.textColor,
          ),
        ),
      );
}

class _TextScrollerPainter extends CustomPainter {
  _TextScrollerPainter({
    required this.activeLabel,
    required this.nextLabel,
    required this.fontSize,
    required this.progress,
    required this.direction,
    required this.textColor,
  }) : gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            textColor,
            textColor,
            Colors.transparent,
          ],
          stops: [
            0,
            0.15,
            0.85,
            1,
          ],
        );

  final String activeLabel;
  final String nextLabel;
  final double fontSize;
  final double progress;
  final _LabelDirection direction;
  final Color textColor;
  final LinearGradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final fadeShader = gradient.createShader(
      Rect.fromLTWH(.0, .0, size.width, size.height),
    );
    final fadePaint = Paint()..shader = fadeShader;

    late final ui.Paragraph topLine;
    late final ui.Paragraph bottomLine;
    late final double offset;

    switch (direction) {
      case _LabelDirection.topDown:
        topLine = _buildLine(activeLabel, size, fadePaint);
        bottomLine = _buildLine(nextLabel, size, fadePaint);
        offset = progress - 1.0;
        break;
      case _LabelDirection.bottomUp:
        topLine = _buildLine(nextLabel, size, fadePaint);
        bottomLine = _buildLine(activeLabel, size, fadePaint);
        offset = -progress;
        break;
    }

    final topLineHeight = topLine.height;
    final bottomLineHeight = bottomLine.height;

    final topAdjustmentOffset = (size.height - topLineHeight) / 2;
    final bottomAdjustmentOffset = (size.height - bottomLineHeight) / 2;
    final topAnimationOffset = topLineHeight * (offset + 1.0);
    final bottomAnimationOffset = bottomLineHeight * offset;

    canvas.drawParagraph(
      topLine,
      Offset(0.0, topAdjustmentOffset + topAnimationOffset),
    );
    canvas.drawParagraph(
      bottomLine,
      Offset(0.0, bottomAdjustmentOffset + bottomAnimationOffset),
    );
  }

  ui.Paragraph _buildLine(
    String label,
    Size size,
    Paint fadePaint,
  ) {
    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontSize: fontSize,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    )
      ..pushStyle(ui.TextStyle(
        foreground: fadePaint,
      ))
      ..addText(label);
    return paragraphBuilder.build()
      ..layout(
        ui.ParagraphConstraints(
          width: size.width,
        ),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
