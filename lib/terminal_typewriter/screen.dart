import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'blinker.dart';
part 'commands_typewriter.dart';
part 'terminal_window.dart';

class TerminalTypewriterScreen extends StatelessWidget {
  const TerminalTypewriterScreen({Key? key}) : super(key: key);

  static final _terminalBackgroundColor = Colors.grey.shade900.withOpacity(0.8);
  static final _terminalTitleBarColor = Color.lerp(
    Colors.green,
    Colors.black,
    0.6,
  )!;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Candles Chart'),
        ),
        backgroundColor: Colors.grey.shade800,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: 500,
              ),
              child: _TerminalWindow(
                backgroundColor: _terminalBackgroundColor,
                titleBarColor: _terminalTitleBarColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: FractionalTranslation(
                          translation: Offset(-0.05, 0),
                          child: FlutterLogo(),
                        ),
                      ),
                    ),
                    Text(
                      'Flutter Terminal',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: const _TerminalContent(),
              ),
            ),
          ),
        ),
      );
}

class _TerminalContent extends StatelessWidget {
  const _TerminalContent({
    Key? key,
  }) : super(key: key);

  static const _prefix = '\$ ';
  static const _prefixStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static const _commands = [
    'flutter create my_flutter_app',
    'flutter run',
    'flutter test',
    'flutter build apk',
    'flutter build ios',
    'flutter build web',
  ];
  static const _commandStyle = TextStyle(
    color: Colors.white60,
    fontWeight: FontWeight.bold,
  );
  static const _minTypingLag = Duration(milliseconds: 30);
  static const _maxTypingLag = Duration(milliseconds: 300);
  static const _showDuration = Duration(milliseconds: 2000);
  static final r = Random();
  static final _cursorString = r.nextBool() ? '|' : '_';
  static const _cursorStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text.rich(
          TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'karlo@mrverdat13 ',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              TextSpan(
                text: 'MINGW64 ',
                style: TextStyle(
                  color: Colors.purpleAccent,
                ),
              ),
              TextSpan(
                text: '/flutterverse ',
                style: TextStyle(
                  color: Colors.yellow,
                ),
              ),
              TextSpan(
                text: '(stable)',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        _CommandsTypewriter(
          prefix: _prefix,
          commands: _commands,
          cursor: Text(
            _cursorString,
            style: _cursorStyle,
          ),
          prefixStyle: _prefixStyle,
          commandStyle: _commandStyle,
          minTypingLag: _minTypingLag,
          maxTypingLag: _maxTypingLag,
          showDuration: _showDuration,
        ),
      ],
    );
  }
}
