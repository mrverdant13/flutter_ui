part of 'screen.dart';

typedef void OnColorSelectedCallback(Color selectedColor);

class _Picker extends StatefulWidget {
  const _Picker({
    Key? key,
    required this.colors,
    required this.showSelected,
    this.onColorSelected,
  }) : super(key: key);

  final List<Color> colors;
  final bool showSelected;
  final OnColorSelectedCallback? onColorSelected;

  @override
  __PickerState createState() => __PickerState();
}

class __PickerState extends State<_Picker> {
  Color selectedColor = Colors.white;

  int get segmentsCount => widget.colors.length * 2 - 1;

  void _selectColor(double x) {
    setState(() {
      final renderBox = context.findRenderObject() as RenderBox;
      final totalPosition =
          (x / renderBox.size.width).clamp(0, 1) * widget.colors.length;
      final actualPosition = totalPosition - 0.5;
      final selectedColorIdx =
          actualPosition.round().clamp(0, widget.colors.length - 1);
      selectedColor = widget.colors[selectedColorIdx];
      widget.onColorSelected?.call(selectedColor);
    });
  }

  @override
  Widget build(BuildContext context) => widget.colors.isEmpty
      ? const Center(
          child: Text('NO COLORS'),
        )
      : GestureDetector(
          onTapDown: (details) => _selectColor(details.localPosition.dx),
          onHorizontalDragUpdate: (details) =>
              _selectColor(details.localPosition.dx),
          child: AspectRatio(
            aspectRatio: segmentsCount / (widget.showSelected ? 2 : 1),
            child: Column(
              children: [
                Expanded(
                  child: ClipPath(
                    clipper: _PickerClipper(
                      lineThicknessFraction: 0.25,
                      colorsCount: widget.colors.length,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ...widget.colors.expand(
                              (color) => [color, color],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.showSelected)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      color: selectedColor,
                    ),
                  ),
              ],
            ),
          ),
        );
}

class _PickerClipper extends CustomClipper<Path> {
  _PickerClipper({
    required this.colorsCount,
    required this.lineThicknessFraction,
  });

  final int colorsCount;
  final double lineThicknessFraction;

  @override
  Path getClip(Size size) {
    //
    // ? Dimensions
    //
    final blobDiameter = size.height;
    final blobRadius = blobDiameter / 2;
    final barThickness = blobDiameter * lineThicknessFraction;
    final blobsSeparation = blobDiameter;
    final barSegmentLength = blobDiameter + blobsSeparation;
    final blobsCentersDistance = blobsSeparation + blobDiameter;
    final tangentCircleRadius =
        ((3 * pow(blobDiameter, 2)) + pow(barThickness, 2)) /
            (4 * (blobDiameter - barThickness));
    final barRawThickness = blobDiameter *
        ((tangentCircleRadius + barThickness / 2) /
            (tangentCircleRadius + blobRadius));
    final remotionCirclesVerticalDistance =
        barThickness / 2 + tangentCircleRadius;

    //
    // ? Critical points.
    //
    final firstBlobCenter = size.centerLeft(Offset(
      blobDiameter / 2,
      0,
    ));
    final firstSegmentCenter = firstBlobCenter.translate(
      barSegmentLength / 2,
      0,
    );

    final path = Path();

    for (var i = 0; i < colorsCount; i++) {
      final curvedSegmentPath = Path();

      if (i < colorsCount - 1) {
        final segmentCenter = firstSegmentCenter.translate(
          i * blobsCentersDistance,
          0,
        );
        final segmentRect = Rect.fromCenter(
          center: segmentCenter,
          width: barSegmentLength,
          height: barRawThickness,
        );
        final segmentPath = Path()..addRect(segmentRect);

        final circleCenter = firstSegmentCenter.translate(
          i * blobsCentersDistance,
          0,
        );
        final circleRect = Rect.fromCircle(
          center: circleCenter,
          radius: tangentCircleRadius,
        );
        final circlesPath = Path()
          ..addOval(circleRect.translate(0, remotionCirclesVerticalDistance))
          ..addOval(circleRect.translate(0, -remotionCirclesVerticalDistance));

        curvedSegmentPath.addPath(
          Path.combine(
            PathOperation.difference,
            segmentPath,
            circlesPath,
          ),
          Offset.zero,
        );
      }

      final blobCenter = firstBlobCenter.translate(blobsCentersDistance * i, 0);
      final blobRect = Rect.fromCircle(
        center: blobCenter,
        radius: blobRadius,
      );
      final blobPath = Path()..addOval(blobRect);

      path.addPath(
        Path.combine(
          PathOperation.union,
          Path.combine(
            PathOperation.union,
            curvedSegmentPath,
            path,
          ),
          blobPath,
        ),
        Offset.zero,
      );
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
