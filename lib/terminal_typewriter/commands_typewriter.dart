part of 'screen.dart';

class _CommandsTypewriter extends StatefulWidget {
  const _CommandsTypewriter({
    Key? key,
    required this.prefix,
    required this.commands,
    required this.cursor,
    required this.prefixStyle,
    required this.commandStyle,
    required this.minTypingLag,
    required this.maxTypingLag,
    required this.showDuration,
  }) : super(key: key);

  final String prefix;
  final Iterable<String> commands;
  final Widget cursor;

  final TextStyle prefixStyle;
  final TextStyle commandStyle;

  final Duration minTypingLag;
  final Duration maxTypingLag;
  final Duration showDuration;

  @override
  __CommandsTypewriterState createState() => __CommandsTypewriterState();
}

class __CommandsTypewriterState extends State<_CommandsTypewriter> {
  late int _commandIdx;
  late int _commandCharIdx;
  late String _typedCommandFragment;
  late TextDirection _direction;
  late Duration Function() _typingLag;
  late _BlinkerController _blinkerController;

  @override
  void initState() {
    super.initState();
    _commandIdx = 0;
    _commandCharIdx = 0;
    _typedCommandFragment = '';
    _direction = TextDirection.ltr;
    _typingLag = () => _randomTypingLag;
    _blinkerController = _BlinkerController();
    _typeCommand();
  }

  String get _currentCommand => widget.commands.elementAt(
        _commandIdx,
      );
  String get _nextCommand => widget.commands.elementAt(
        (_commandIdx + 1) % widget.commands.length,
      );

  Future<void> _typeCommand() async {
    await Future.delayed(_typingLag());
    if (!mounted) return;

    _typedCommandFragment = _currentCommand.substring(0, _commandCharIdx);
    setState(() {});
    _blinkerController.reset();

    if (_typedCommandFragment == _currentCommand) {
      await Future.delayed(widget.showDuration);
      if (!mounted) return;
    }

    _updateIdxs();

    _typeCommand();
  }

  void _updateIdxs() {
    switch (_direction) {
      case TextDirection.ltr:
        _commandCharIdx++;
        if (_commandCharIdx >= _currentCommand.length) {
          _direction = TextDirection.rtl;
          _typingLag = () => widget.minTypingLag;
        }
        break;
      case TextDirection.rtl:
        _commandCharIdx--;
        if (_commandCharIdx <= 0 ||
            _nextCommand.startsWith(_typedCommandFragment)) {
          _direction = TextDirection.ltr;
          _typingLag = () => _randomTypingLag;
          _commandIdx++;
          if (_commandIdx >= widget.commands.length) {
            _commandIdx = 0;
          }
        }
        break;
    }
  }

  Duration get _randomTypingLag => lerpDuration(
        widget.minTypingLag,
        widget.maxTypingLag,
        Random().nextDouble(),
      );

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(
          text: widget.prefix,
          style: widget.prefixStyle,
          children: [
            TextSpan(
              text: _typedCommandFragment,
              style: widget.commandStyle,
            ),
            WidgetSpan(
              child: _Blinker(
                controller: _blinkerController,
                child: widget.cursor,
              ),
              alignment: PlaceholderAlignment.middle,
            ),
          ],
        ),
      );
}
