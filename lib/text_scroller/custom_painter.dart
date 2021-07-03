part of 'screen.dart';

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
