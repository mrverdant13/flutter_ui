import 'package:flutter/material.dart';

import 'text_scroller/screen.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter UI',
        home: _Home(),
      );
}

class _Home extends StatelessWidget {
  const _Home({
    Key? key,
  }) : super(key: key);

  static const _routes = {
    'Text Scroller': const TextScrollerScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI samples'),
      ),
      body: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
        childAspectRatio: 2,
        padding: const EdgeInsets.all(30.0),
        children: [
          ..._routes.keys.map(
            (routeName) => ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _routes[routeName]!,
                  ),
                );
              },
              child: Text(
                routeName,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
