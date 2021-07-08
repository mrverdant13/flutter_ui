part of 'screen.dart';

class _CandlesChart extends StatelessWidget {
  const _CandlesChart({
    Key? key,
    required this.data,
    required this.wickColor,
    required this.earnWaxColor,
    required this.loseWaxColor,
    required this.labelsColor,
  }) : super(key: key);

  final List<_CandleData> data;
  final Color wickColor;
  final Color earnWaxColor;
  final Color loseWaxColor;
  final Color labelsColor;

  double _getCandleHeight({
    required _CandleData candleData,
    required double availableHeight,
  }) =>
      candleData.wick * availableHeight / data.maxDelta;

  double _getCandleFractionalOffset({
    required _CandleData candleData,
  }) =>
      (data.maxValue - candleData.high) / candleData.wick;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final labelsCount = constraints.maxHeight ~/ 50;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    labelsCount,
                    (index) {
                      final delta = (data.maxDelta * index) / (labelsCount - 1);
                      final value = data.maxValue - delta;
                      return Text(
                        value.toStringAsFixed(2),
                        style: TextStyle(color: labelsColor),
                      );
                    },
                  ),
                ),
                SizedBox.fromSize(
                  size: Size.square(20),
                ),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final candleFractionalOffset = _getCandleFractionalOffset(
                        candleData: data[index],
                      );
                      final candleHeight = _getCandleHeight(
                        candleData: data[index],
                        availableHeight: constraints.maxHeight,
                      );
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FractionalTranslation(
                            translation: Offset(
                              0,
                              candleFractionalOffset,
                            ),
                            child: _Candle(
                              data: data[index],
                              height: candleHeight,
                              width: 20.0,
                              earnWaxColor: earnWaxColor,
                              loseWaxColor: loseWaxColor,
                              wickColor: wickColor,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class _Candle extends StatelessWidget {
  const _Candle({
    Key? key,
    required this.data,
    required this.height,
    required this.width,
    required this.wickColor,
    required this.earnWaxColor,
    required this.loseWaxColor,
  }) : super(key: key);

  final _CandleData data;
  final double height;
  final double width;
  final Color wickColor;
  final Color earnWaxColor;
  final Color loseWaxColor;

  bool get _isEarn => data.close > data.open;
  double get _waxHeight => (data.wax * height) / data.wick;
  double get _waxFractionalOffset =>
      (data.high - max(data.open, data.close)) / data.wax;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: '''
High: ${data.high}
Low: ${data.low}

Open: ${data.open}
Close: ${data.close}''',
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: height,
              width: width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width),
                color: wickColor,
              ),
            ),
            FractionalTranslation(
              translation: Offset(0, _waxFractionalOffset),
              child: Container(
                height: _waxHeight,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width / 3),
                  color: _isEarn ? earnWaxColor : loseWaxColor,
                ),
              ),
            ),
          ],
        ),
      );
}
