import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'candle_data.dart';
part 'candles_chart.dart';

class CandlesChartScree extends StatelessWidget {
  const CandlesChartScree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Candles Chart'),
        ),
        body: Container(
          color: Colors.grey.shade900,
          child: _CandlesChart(
            data: _generateCandlesData(),
            wickColor: Colors.grey.shade800,
            earnWaxColor: Colors.green.shade800,
            loseWaxColor: Colors.red.shade700,
            labelsColor: Colors.white60,
          ),
        ),
      );
}

List<_CandleData> _generateCandlesData() => List<_CandleData>.generate(
      200,
      (_) {
        final r = Random();
        const minVal = 100;
        const maxVal = 200;

        // Open between 500 and 1500.
        final open = r.nextDouble() * (maxVal - minVal) + minVal;

        // Close between 500 and 1500.
        final close = r.nextDouble() * (maxVal - minVal) + minVal;

        // High and low between 500 and 1500.
        final extreme1 = r.nextDouble() * (maxVal - minVal) + minVal;
        final extreme2 = r.nextDouble() * (maxVal - minVal) + minVal;

        return _CandleData(
          open: open,
          close: close,
          high: max(max(max(extreme1, extreme2), open), close),
          low: min(min(min(extreme1, extreme2), open), close),
        );
      },
    );
