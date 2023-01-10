import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartt extends StatelessWidget {
  const BarChartt();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Po';
        break;
      case 1:
        text = 'Ut';
        break;
      case 2:
        text = 'St';
        break;
      case 3:
        text = 'Št';
        break;
      case 4:
        text = 'Pia';
        break;
      case 5:
        text = 'So';
        break;
      case 6:
        text = 'Ne';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.lightBlueAccent,
          Colors.greenAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        _buildGroupData(0, 15, false),
        _buildGroupData(1, 12, false),
        _buildGroupData(2, 15, false),
        _buildGroupData(3, 15, false),
        _buildGroupData(4, 21, false),
        _buildGroupData(5, 4, false),
        _buildGroupData(6, 8, true),
      ];
}

BarChartGroupData _buildGroupData(int x, double y, bool currentDay) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        width: 25,
        borderRadius: BorderRadius.zero,
        toY: y,
        color: currentDay
            ? Color.fromRGBO(125, 160, 119, 1)
            : Color.fromRGBO(242, 242, 242, 1),
      )
    ],
    showingTooltipIndicators: [0],
  );
}

class BarChartSample3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: const BarChartt(),
      ),
    );
  }
}
