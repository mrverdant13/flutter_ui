part of 'screen.dart';

class _CustomPainter extends StatefulWidget {
  const _CustomPainter({
    Key? key,
    required this.pagesData,
  }) : super(key: key);

  final Set<_LetterPageData> pagesData;

  @override
  __CustomPainterState createState() => __CustomPainterState();
}

class __CustomPainterState extends State<_CustomPainter>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late int _currentPageIdx;

  @override
  void initState() {
    super.initState();
    _currentPageIdx = 0;
    _pageController = PageController()
      ..addListener(
        () {
          setState(() {
            _currentPageIdx = (_pageController.page ?? 0) ~/ 1;
          });
        },
      );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _safeIdx(int idx) => idx % pagesData.length;
  double get _transitionProgress => (_pageController.page ?? 0.0) % 1;

  _LetterPageData get _currentPageData => widget.pagesData.elementAt(
        _safeIdx(_currentPageIdx),
      );

  int get _nextPageIdx => _safeIdx(_currentPageIdx + 1);
  _LetterPageData get _nextPageData => widget.pagesData.elementAt(
        _safeIdx(_currentPageIdx + 1),
      );

  _LetterPageData get _followingPageData => widget.pagesData.elementAt(
        _safeIdx(_currentPageIdx + 2),
      );

  @override
  Widget build(BuildContext context) => Container(
        color: _currentPageData.primaryColor,
        child: AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) => Stack(
            children: [
              Column(
                children: [
                  Spacer(flex: 5),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final buttonDiameter = constraints.maxHeight / 2;
                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size.infinite,
                              painter: _Painter(
                                progress: _transitionProgress,
                                buttonDiameter: buttonDiameter,
                                screenHeight:
                                    MediaQuery.of(context).size.height,
                                currentBackgroundColor:
                                    _currentPageData.primaryColor,
                                currentButtonColor: _nextPageData.primaryColor,
                                nextButtonColor:
                                    _followingPageData.primaryColor,
                              ),
                            ),
                            if (_transitionProgress == 0.0)
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: _nextPageData.primaryColor,
                                    onPrimary: _nextPageData.accentColor,
                                    fixedSize: Size.square(buttonDiameter),
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {
                                    _pageController.animateToPage(
                                      _nextPageIdx,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.bounceOut,
                                    );
                                  },
                                  child: Icon(Icons.arrow_right),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pagesData.length,
                      itemBuilder: (context, index) {
                        final currentPageData = pagesData.elementAt(index);
                        return Center(
                          child: Text(
                            currentPageData.letter,
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      color: currentPageData.accentColor,
                                    ),
                          ),
                        );
                      },
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      );
}

class _Painter extends CustomPainter {
  const _Painter({
    required this.progress,
    required this.buttonDiameter,
    required this.screenHeight,
    required this.currentButtonColor,
    required this.currentBackgroundColor,
    required this.nextButtonColor,
  });

  final double progress;
  final double buttonDiameter;
  final double screenHeight;
  final Color currentBackgroundColor;
  final Color currentButtonColor;
  final Color nextButtonColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final maxButtonDiameter = screenHeight * 200;
    if (progress >= 0.0 && progress < 0.5) {
      final expandingProgress = Curves.easeInExpo.transform(
        Curves.easeInExpo.transform(
          progress * 2,
        ),
      );
      final currentButtonDiameter =
          expandingProgress * maxButtonDiameter + buttonDiameter;
      final currentButtonCenter = center.translate(
        (currentButtonDiameter - buttonDiameter) / 2,
        0.0,
      );

      final paint = Paint()..color = currentButtonColor;
      canvas.drawCircle(
        currentButtonCenter,
        currentButtonDiameter / 2,
        paint,
      );
    } else {
      final shrinkingProgress = 1 -
          Curves.easeOutExpo.transform(
            Curves.easeOutExpo.transform(
              progress * 2 - 1.0,
            ),
          );
      final currentButtonDiameter =
          shrinkingProgress * maxButtonDiameter + buttonDiameter;
      final currentButtonCenter = center.translate(
        -(currentButtonDiameter - buttonDiameter) / 2 -
            buttonDiameter * shrinkingProgress,
        0.0,
      );

      final paint = Paint()..color = currentButtonColor;
      canvas.drawPaint(paint);
      paint..color = currentBackgroundColor;
      canvas.drawCircle(
        currentButtonCenter,
        currentButtonDiameter / 2,
        paint,
      );

      // TODO: Implement reveal only without page view.
      // final paint = Paint()..color = currentButtonColor;
      // canvas.drawPath(
      //   Path.combine(
      //     PathOperation.difference,
      //     Path()..addRect(Rect.largest),
      //     Path()
      //       ..addOval(
      //         Rect.fromCircle(
      //           center: currentButtonCenter,
      //           radius: currentButtonDiameter / 2,
      //         ),
      //       )
      //       ..close(),
      //   ),
      //   paint,
      // );
    }

    const buttonChangeThreshold = 0.7;
    if (progress > buttonChangeThreshold) {
      final changeProgress = Curves.easeOutBack.transform(
        (progress - buttonChangeThreshold) / (1 - buttonChangeThreshold),
      );
      final changingButtonDiameter = buttonDiameter * changeProgress;
      final paint = Paint()..color = nextButtonColor;
      canvas.drawCircle(
        center,
        changingButtonDiameter / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
