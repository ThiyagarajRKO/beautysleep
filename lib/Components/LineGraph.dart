import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../ModelResponse/OuraApiResponse.dart';

class LineChartWidget extends StatelessWidget {

  final List<OuraApiResponse> StressList;
  final List<LineChartBarData> linesChart;

  const LineChartWidget({super.key, required this.StressList,  required this.linesChart});

  @override
  Widget build(BuildContext context){

    List<FlSpot> recoveryHigh = [];
    List<FlSpot> stressHigh = [];

    for (int i = 0; i < StressList.length; i++) {
      final contributors = StressList[i];
      recoveryHigh
          .add(FlSpot(i.toDouble(), contributors.recoveryHigh!.toDouble()));
      stressHigh
          .add(FlSpot(i.toDouble(), contributors.stressHigh!.toDouble()));
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height / 2,
      child: LineChart(
        LineChartData(
          lineBarsData: linesChart,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final day = value.toInt() + 1;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(day == 1 ? 'Day $day' : day.toString(),
                        style: const TextStyle(color: Colors.black)),
                  );
                },
                interval: 1,
                reservedSize: 40,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50, // try increase
                getTitlesWidget: (value, meta) {
                  final left = value.toInt();
                  print(left);
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(left == 0 ? 'Ratio $left' : left.toString(),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black)),
                  );
                },
                interval: 1000,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
        ),
      ),
    );

  }
}
