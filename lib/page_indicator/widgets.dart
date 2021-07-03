part of 'screen.dart';

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
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
  double get dotBorderWidth => dotOuterRadius - dotInnerRadius;
  double get totalWidth =>
      pagesCount * dotOuterDiameter + (pagesCount + 1) * dotsSeparation;

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
          (dotsSeparation + dotOuterDiameter);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: (dotOuterRadius + dotsSeparation) * 2,
        width: totalWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                _Separator(side: dotsSeparation),
                ...List.generate(
                  pagesCount,
                  (pageIdx) => GestureDetector(
                    onTap: () => pageController.animateToPage(
                      pageIdx,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                    ),
                    child: _PageDot(
                      indicatorBorderWidth: dotBorderWidth,
                      indicatorOuterDiameter: dotOuterDiameter,
                      fillColor: Colors.blue.shade200,
                      borderColor: Colors.blue.shade800,
                    ),
                  ),
                ).expand(
                  (indicatorDot) => [
                    indicatorDot,
                    _Separator(side: dotsSeparation),
                  ],
                ),
              ],
            ),
            AnimatedBuilder(
              animation: pageController,
              builder: (context, child) => Positioned(
                left: indicatorLeftPosition,
                width: indicatorRightPosition - indicatorLeftPosition,
                child: _ActivePageDot(
                  borderRadius: dotOuterRadius,
                  borderWidth: dotBorderWidth,
                  fillColor: Colors.blue,
                  borderColor: Colors.blue.shade900,
                ),
              ),
            ),
          ],
        ),
      );
}

class _Separator extends StatelessWidget {
  const _Separator({
    Key? key,
    required this.side,
  }) : super(key: key);

  final double side;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: side,
        width: side,
      );
}

class _PageDot extends StatelessWidget {
  const _PageDot({
    Key? key,
    required this.indicatorBorderWidth,
    required this.indicatorOuterDiameter,
    required this.fillColor,
    required this.borderColor,
  }) : super(key: key);

  final double indicatorBorderWidth;
  final double indicatorOuterDiameter;
  final Color fillColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: ShapeDecoration(
          color: fillColor,
          shape: CircleBorder(
            side: BorderSide(
              width: indicatorBorderWidth,
              color: borderColor,
            ),
          ),
        ),
        child: SizedBox(
          width: indicatorOuterDiameter,
          height: indicatorOuterDiameter,
        ),
      );
}

class _ActivePageDot extends StatelessWidget {
  const _ActivePageDot({
    Key? key,
    required this.borderRadius,
    required this.borderWidth,
    required this.fillColor,
    required this.borderColor,
  }) : super(key: key);

  final double borderRadius;
  final double borderWidth;
  final Color fillColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: fillColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
        ),
      ),
      child: SizedBox(
        height: borderRadius * 2,
      ),
    );
  }
}
