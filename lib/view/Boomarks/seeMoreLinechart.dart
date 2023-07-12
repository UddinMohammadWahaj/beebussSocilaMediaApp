import 'package:bizbultest/models/Analytics/SeeMoreAllData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineChartWithData extends StatelessWidget {
  final double lCminX, lCmaxX, lCminY, lCmaxY;
  final String Function(double) lCgetTitlesY;
  final String Function(double) lCgetTitlesX;
  // final List<GraphData> graphData;
  final List<LineChartBarData> lineBarsData;

  LineChartWithData({
    required this.lCminX,
    required this.lCmaxX,
    required this.lCminY,
    required this.lCmaxY,
    required this.lCgetTitlesY,
    // @required this.graphData,
    required this.lCgetTitlesX,
    required this.lineBarsData,
  });

  @override
  Widget build(BuildContext context) {
    print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
    print(lCminX);
    print(lCmaxX);
    print(lCminY);
    print(lCmaxY);
    lineBarsData.forEach((element) {
      print(1);
    });

    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: lCminX,
        maxX: lCmaxX,
        minY: lCminY,
        maxY: lCmaxY,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.7),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(
          getTitles: lCgetTitlesY,
        ),
      );

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        reservedSize: 30,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        rotateAngle: 0,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        getTitles: lCgetTitlesX,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );
}

class LineChart1 extends StatelessWidget {
  const LineChart1({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: bottomTitles,
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        reservedSize: 30,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'SEPT';
            case 7:
              return 'OCT';
            case 12:
              return 'DEC';
          }
          return '';
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xff4af699)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xffaa4cfc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false, colors: [
          const Color(0x00aa4cfc),
        ]),
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        colors: const [Color(0xff27b6fc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        colors: const [Color(0x444af699)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        colors: const [Color(0x99aa4cfc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors: [
            const Color(0x33aa4cfc),
          ],
        ),
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        colors: const [Color(0x4427b6fc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}

class BarChart1 extends StatefulWidget {
  final double? lCminX, lCmaxX, lCminY, lCmaxY;
  final Function(double)? lCgetTitlesY;
  final Function(double)? lCgetTitlesX;
  final List<GraphData>? graphData;

  const BarChart1({
    Key? key,
    this.lCminX,
    this.lCmaxX,
    this.lCminY,
    this.lCmaxY,
    this.lCgetTitlesY,
    this.lCgetTitlesX,
    this.graphData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChart1State();
}

class BarChart1State extends State<BarChart1> {
  late double lCminX, lCmaxX, lCminY, lCmaxY;
  late Function(double) lCgetTitlesY;
  late Function(double) lCgetTitlesX;
  late List<GraphData> graphData;
  List<int> exercisestateDataYpointList = [];

  final Color barBackgroundColor = const Color(0xffc1e5fd);
  int touchedIndex = -1;

  @override
  void initState() {
    this.lCminX = widget.lCminX!;
    this.lCmaxX = widget.lCmaxX!;
    this.lCminY = widget.lCminY!;
    this.lCmaxY = widget.lCmaxY!;
    this.graphData = widget.graphData!;
    print(lCminX);
    print(lCmaxX);
    exercisestateDataYpointList =
        printpoints((lCmaxY % 2) == 0 ? 4 : 5, lCminY, lCmaxY);
    super.initState();
  }

  List<int> printpoints(int nop, double startNum, double endNum) {
    List<int> numList = [];
    var qnop = nop - 1;
    var exnum = endNum - startNum;
    for (var i = 0; i < nop; i++) {
      var finalnum = ((exnum / qnop) * i) + startNum;
      numList.add(finalnum.round());
    }
    print("numList  :-> $numList");
    return numList;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      mainBarData(),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.blue,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          // borderSide: isTouched ? BorderSide(color: Colors.yellow, width: 1) : BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: lCmaxY,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(lCmaxX.toInt(), (i) {
        return makeGroupData(
          i,
          graphData[i].value!.toDouble(),
          isTouched: i == touchedIndex,
        );
      });

  BarChartData mainBarData() {
    return BarChartData(
      maxY: lCmaxY,
      minY: lCminY,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String itemName = graphData[group.x.toInt()].platform!;

              return BarTooltipItem(
                itemName + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y).toString(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex!;
          });
        },
      ),
      alignment: BarChartAlignment.center,
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: false,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            return graphData[value.toInt()].platform!;
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            if (exercisestateDataYpointList.contains(value)) {
              return value.toInt().toString();
            } else {
              return '';
            }
            return value.toString();
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      groupsSpace: 10,
      gridData: FlGridData(
        show: false,
      ),
    );
  }
}
