part of 'screen.dart';

typedef void OnColorSelectedCallback(Color selectedColor);

class _NestCustomPainter extends StatelessWidget {
  const _NestCustomPainter({
    Key? key,
    required this.childDiameterFraction,
    required this.glowThicknessFraction,
    required this.dotRadiusFraction,
    required this.dotsPerRing,
    required this.glowColor,
    required this.dotsColor,
    required this.childBuilder,
  }) : super(key: key);

  final double childDiameterFraction;
  final double glowThicknessFraction;
  final double dotRadiusFraction;
  final int dotsPerRing;
  final Color glowColor;
  final Color dotsColor;
  final Widget Function(double childDiameter) childBuilder;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final childDiameter =
                constraints.biggest.shortestSide * childDiameterFraction;
            final glowThickness =
                constraints.biggest.shortestSide * glowThicknessFraction;
            final dotRadius =
                constraints.biggest.shortestSide * dotRadiusFraction;

            return _PatternPaint(
              logoDiameter: childDiameter,
              glowThickness: glowThickness,
              dotsPerRing: dotsPerRing,
              dotRadius: dotRadius,
              dotsColor: dotsColor,
              glowColor: glowColor,
              child: childBuilder(childDiameter),
            );
          },
        ),
      );
}

class _PatternPaint extends StatefulWidget {
  const _PatternPaint({
    Key? key,
    required this.logoDiameter,
    required this.glowThickness,
    required this.dotsPerRing,
    required this.dotRadius,
    required this.dotsColor,
    required this.glowColor,
    required this.child,
  }) : super(key: key);

  final double logoDiameter;
  final double glowThickness;
  final int dotsPerRing;
  final double dotRadius;
  final Color dotsColor;
  final Color glowColor;
  final Widget child;

  @override
  __PatternPaintState createState() => __PatternPaintState();
}

class __PatternPaintState extends State<_PatternPaint>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addStatusListener(
        (status) {
          switch (status) {
            case AnimationStatus.completed:
              _animationController.reverse();
              break;
            case AnimationStatus.dismissed:
              _animationController.forward();
              break;
            default:
              break;
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

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        child: widget.child,
        builder: (context, child) => CustomPaint(
          painter: _PatternPainter(
            logoRadius: widget.logoDiameter / 2,
            glowThickness: widget.glowThickness,
            glowColor: widget.glowColor.withOpacity(_animationController.value),
            dotsPerRing: widget.dotsPerRing,
            dotRadius: widget.dotRadius,
            dotColor: widget.dotsColor,
          ),
          child: child,
        ),
      );
}

class _PatternPainter extends CustomPainter {
  const _PatternPainter({
    required this.logoRadius,
    required this.glowThickness,
    required this.glowColor,
    required this.dotsPerRing,
    required this.dotRadius,
    required this.dotColor,
  });

  final double logoRadius;
  final double glowThickness;
  final Color glowColor;
  final int dotsPerRing;
  final double dotRadius;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    _avoidLogoCircle(
      canvas: canvas,
      availableArea: size,
    );

    _drawGlow(
      canvas: canvas,
      availableArea: size,
    );

    _drawDotsPattern(
      canvas: canvas,
      availableArea: size,
    );
  }

  void _avoidLogoCircle({
    required Canvas canvas,
    required Size availableArea,
  }) {
    final center = availableArea.center(Offset.zero);
    final path = Path.combine(
      PathOperation.difference,
      Path()
        ..addRect(
          Rect.fromCenter(
            center: center,
            height: availableArea.height,
            width: availableArea.width,
          ),
        ),
      Path()
        ..addOval(
          Rect.fromCircle(
            center: center,
            radius: logoRadius,
          ),
        ),
    );
    canvas.clipPath(path);
  }

  void _drawDotsPattern({
    required Canvas canvas,
    required Size availableArea,
  }) {
    final globalCenter = availableArea.center(Offset.zero);
    final angleDelta = 2 * pi / dotsPerRing;

    final firstRingRadius = logoRadius + glowThickness + dotRadius * 2;
    final lastRingRadius = firstRingRadius +
        ((availableArea.shortestSide / 2 - firstRingRadius) ~/
                (dotRadius * 2)) *
            dotRadius *
            2;

    final paint = Paint()..color = dotColor;

    for (double r = firstRingRadius; r < lastRingRadius; r += dotRadius * 3) {
      final dotCenter = globalCenter.translate(0, -r);
      final relativeRingProgress =
          (lastRingRadius - r) / (lastRingRadius - firstRingRadius);
      for (int i = 0; i < dotsPerRing; i++) {
        canvas.drawCircle(
          dotCenter,
          dotRadius,
          paint,
        );
        canvas.rotateAround(
          radians: angleDelta,
          pivotOffset: globalCenter,
        );
      }
      canvas.rotateAround(
        radians: angleDelta / 2,
        pivotOffset: globalCenter,
      );

      paint.color = dotColor.withOpacity(
        Curves.easeIn.transform(
          dotColor.opacity * relativeRingProgress,
        ),
      );
    }
  }

  void _drawGlow({
    required Canvas canvas,
    required Size availableArea,
  }) {
    final globalCenter = availableArea.center(Offset.zero);

    final paint = Paint()
      ..color = glowColor
      ..imageFilter = ImageFilter.blur(
        sigmaX: glowThickness,
        sigmaY: glowThickness,
        tileMode: TileMode.decal,
      );

    canvas.drawCircle(
      globalCenter,
      logoRadius + glowThickness / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_PatternPainter oldDelegate) => false;
}

extension _RotableCanvas on Canvas {
  void rotateAround({
    required double radians,
    required Offset pivotOffset,
  }) {
    translate(pivotOffset.dx, pivotOffset.dy);
    rotate(radians);
    translate(-pivotOffset.dx, -pivotOffset.dy);
  }
}
