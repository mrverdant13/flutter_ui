part of 'screen.dart';

@immutable
class _CandleData {
  const _CandleData({
    required this.open,
    required this.close,
    required this.high,
    required this.low,
  });

  final double open;
  final double close;
  final double high;
  final double low;

  double get wick => high - low;
  double get wax => (open - close).abs();
}

extension _CandlesData on List<_CandleData> {
  double get maxValue => fold<double>(
        0,
        (previousValue, candleData) => max(previousValue, candleData.high),
      );

  double get minValue => fold<double>(
        maxValue,
        (previousValue, candleData) => min(previousValue, candleData.low),
      );

  double get maxDelta => maxValue - minValue;
}
