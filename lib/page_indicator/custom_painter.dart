part of 'screen.dart';

class _PageIndicatorWithCustomPainter extends StatelessWidget {
  const _PageIndicatorWithCustomPainter({
    Key? key,
    required this.pagesCount,
    required this.laggingOffset,
    required this.dotOuterRadius,
    required this.dotInnerRadius,
    required this.dotsSeparation,
    required this.pageController,
  }) : super(key: key);

  final int pagesCount;
  final double laggingOffset;
  final double dotOuterRadius;
  final double dotInnerRadius;
  final double dotsSeparation;
  final PageController pageController;
  double get dotOuterDiameter => dotOuterRadius * 2;
  double get totalWidth =>
      pagesCount * dotOuterDiameter + (pagesCount + 1) * dotsSeparation;

  @override
  Widget build(BuildContext context) => Center(
        child: CustomPaint(
          size: Size(
            totalWidth,
            (dotOuterRadius + dotsSeparation) * 2,
          ),
          painter: _PageIndicatorPainter(
            pagesCount: pagesCount,
            laggingOffset: laggingOffset,
            dotOuterRadius: dotOuterRadius,
            dotInnerRadius: dotInnerRadius,
            dotsSeparation: dotsSeparation,
            pageController: pageController,
          ),
        ),
      );
}

class _PageIndicatorPainter extends CustomPainter {
  _PageIndicatorPainter({
    required this.pagesCount,
    required this.laggingOffset,
    required this.dotOuterRadius,
    required this.dotInnerRadius,
    required this.dotsSeparation,
    required this.pageController,
  });

  final int pagesCount;
  final double laggingOffset;
  final double dotOuterRadius;
  final double dotInnerRadius;
  final double dotsSeparation;
  final PageController pageController;

  double get dotOuterDiameter => dotOuterRadius * 2;
  double get dotInnerDiameter => dotInnerRadius * 2;
  double get dotBorderWidth => dotOuterRadius - dotInnerRadius;

  double get pageTransitionValue => pageController.page ?? 0.0;
  int get pageNumber => pageTransitionValue.toInt();
  double get progressBetweenPages => pageTransitionValue % 1.0;

  double get indicatorLeftPosition =>
      dotsSeparation +
      pageNumber * (dotsSeparation + dotOuterDiameter) +
      ((progressBetweenPages - laggingOffset).clamp(0.0, 1.0) /
              (1.0 - laggingOffset)) *
          (dotsSeparation + dotOuterDiameter);
  double get indicatorRightPosition =>
      (pageNumber + 1) * (dotsSeparation + dotOuterDiameter) +
      (progressBetweenPages / (1.0 - laggingOffset)).clamp(0.0, 1.0) *
          (dotsSeparation + dotOuterDiameter) -
      dotBorderWidth * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final dotFillPaint = Paint()..color = Colors.blue.shade200;
    final dotStrokePaint = Paint()
      ..color = Colors.blue.shade800
      ..strokeWidth = dotBorderWidth
      ..style = PaintingStyle.stroke;

    final baseOffset = Offset(
      dotsSeparation + dotInnerRadius,
      dotsSeparation + dotInnerRadius,
    );

    for (int pageIdx = 0; pageIdx < pagesCount; pageIdx++) {
      final offset =
          baseOffset + Offset((dotsSeparation + dotOuterDiameter) * pageIdx, 0);
      canvas.drawCircle(
        offset,
        dotInnerRadius,
        dotFillPaint,
      );
      canvas.drawCircle(
        offset,
        dotInnerRadius,
        dotStrokePaint,
      );
    }

    final top = dotsSeparation;
    final bottom = top + dotInnerDiameter;
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        indicatorLeftPosition,
        top,
        indicatorRightPosition,
        bottom,
      ),
      Radius.circular(dotInnerRadius),
    );

    canvas.drawRRect(
      rRect,
      dotFillPaint..color = Colors.blue,
    );
    canvas.drawRRect(
      rRect,
      dotFillPaint
        ..color = Colors.blue.shade900
        ..strokeWidth = dotBorderWidth
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
