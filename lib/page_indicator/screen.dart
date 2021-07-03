import 'dart:math';

import 'package:flutter/material.dart';

part 'widgets.dart';

class PageIndicatorScreen extends StatefulWidget {
  const PageIndicatorScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PageIndicatorScreenState createState() => _PageIndicatorScreenState();
}

class _PageIndicatorScreenState extends State<PageIndicatorScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  static const _pagesCount = 5;
  static const _laggingOffset = 0.5;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Indicator'),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: List.generate(
                  _pagesCount,
                  (pageIdx) => Center(
                    child: Text(
                      '$pageIdx',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final dotOuterRadius = min(
                  (availableWidth / _pagesCount) * 0.15,
                  15.0,
                );
                final dotInnerRadius = dotOuterRadius * 0.9;
                final dotsSeparation = dotOuterRadius * 2;
                return Container(
                  width: double.infinity,
                  color: Colors.blue.shade300,
                  alignment: Alignment.center,
                  child: _PageIndicator(
                    pagesCount: _pagesCount,
                    laggingOffset: _laggingOffset,
                    dotOuterRadius: dotOuterRadius,
                    dotInnerRadius: dotInnerRadius,
                    dotsSeparation: dotsSeparation,
                    pageController: _pageController,
                  ),
                );
              },
            ),
          ],
        ),
      );
}
