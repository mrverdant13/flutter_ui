import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Text Scroller'),
        ),
        body: Column(
          children: [
            Expanded(
              child: _WidgetsOnly(
                labels: _labels,
                fontSize: 95.0,
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
