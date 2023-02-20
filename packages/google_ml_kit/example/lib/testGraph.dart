import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartt extends StatelessWidget {
  const BarChartt({Key? key, required this.values}) : super(key: key);
  final List<int> values;
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

  List<BarChartGroupData> get barGroups => [
        _buildGroupData(0, values[0].toDouble()),
        _buildGroupData(1, values[1].toDouble()),
        _buildGroupData(2, values[2].toDouble()),
        _buildGroupData(3, values[3].toDouble()),
        _buildGroupData(4, values[4].toDouble()),
        _buildGroupData(5, values[5].toDouble()),
        _buildGroupData(6, values[6].toDouble()),
      ];
}

BarChartGroupData _buildGroupData(int x, double y) {
  final currentDay = DateTime.now().weekday == x + 1;
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        width: 25,
        borderRadius: BorderRadius.zero,
        toY: y / 3,
        color: currentDay
            ? const Color.fromRGBO(125, 160, 119, 1)
            : const Color.fromRGBO(242, 242, 242, 1),
      )
    ],
    showingTooltipIndicators: [0],
  );
}
