part of 'screen.dart';

class _Blinker extends StatefulWidget {
  const _Blinker({
    Key? key,
    required this.child,
    this.controller,
  }) : super(key: key);

  final Widget child;
  final _BlinkerController? controller;

  @override
  __BlinkerState createState() => __BlinkerState();
}

class __BlinkerState extends State<_Blinker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late bool _visible;
  void _toggleVisibility() {
    setState(() => _visible ^= true);
  }

  @override
  void initState() {
    super.initState();
    _visible = true;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    widget.controller?.addListener(_reset);
    _animationController
      ..addStatusListener((status) {
        if (_animationController.isCompleted) {
          _toggleVisibility();
          _animationController.reverse();
        } else if (_animationController.isDismissed) {
          _toggleVisibility();
          _animationController.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_Blinker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_reset);
    }
    widget.controller?.addListener(_reset);
  }

  void _reset() {
    _animationController.forward(from: 0);
    _visible = true;
  }

  @override
  Widget build(BuildContext context) => Visibility(
        visible: _visible,
        child: widget.child,
      );
}

class _BlinkerController extends ChangeNotifier {
  void reset() {
    notifyListeners();
  }
}
