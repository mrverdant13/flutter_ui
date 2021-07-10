import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedFlipCardScreen extends StatelessWidget {
  const AnimatedFlipCardScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Animated Flip Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
              maxWidth: 500,
            ),
            child: FittedBox(
              child: _FlipMessages(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FlipMessages extends StatefulWidget {
  const _FlipMessages({Key? key}) : super(key: key);

  @override
  __FlipMessagesState createState() => __FlipMessagesState();
}

class __FlipMessagesState extends State<_FlipMessages> {
  late int _idx;
  late Timer _timer;

  static const _messages = [
    'Flutter',
    'Dash',
    'It\'s all widgets!',
  ];
  static const _messageChangePeriod = Duration(milliseconds: 2000);
  static const _flipDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    _idx = 0;

    _timer = Timer.periodic(
      _messageChangePeriod,
      (timer) {
        _idx = (_idx + 1) % _messages.length;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _currentLetter => _messages[_idx];

  @override
  Widget build(BuildContext context) => _AnimatedFlip(
        duration: _flipDuration * 0.5,
        child: Card(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _currentLetter,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}

class _AnimatedFlip extends ImplicitlyAnimatedWidget {
  const _AnimatedFlip({
    Key? key,
    required this.child,
    Curve curve = Curves.bounceOut,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  final Widget child;

  @override
  _AnimatedFlipState createState() => _AnimatedFlipState();
}

class _AnimatedFlipState extends ImplicitlyAnimatedWidgetState<_AnimatedFlip> {
  Tween<double>? _flip;
  late Animation<double> _flipAnimation;
  late Widget _oldChild;

  @override
  void initState() {
    super.initState();
    _flip = Tween(begin: 0, end: 0);
    _flipAnimation = animation.drive(_flip!);
    _oldChild = widget.child;
  }

  @override
  void didUpdateWidget(covariant _AnimatedFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      _flip = Tween(begin: 1, end: 0);
      _oldChild = oldWidget.child;
    }
  }

  @override
  void didUpdateTweens() {
    super.didUpdateTweens();
    _flipAnimation = animation.drive(_flip!);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _flip = visitor(
      _flip,
      1.0,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  bool get _showNewChild => _flipAnimation.value > 0.5;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, _) => Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(pi * _flipAnimation.value - pi * (_showNewChild ? 1 : 0)),
          alignment: FractionalOffset.center,
          child: _showNewChild ? widget.child : _oldChild,
        ),
      );
}
