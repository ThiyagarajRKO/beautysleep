import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../ModelResponse/HeartRateResponse.dart';
import '../Utilis/theme.dart';

class HeartRatelinegraph extends StatelessWidget {
  final List<HeartRateData> HeartRateList;
  final List<LineChartBarData> linesChart;

  const HeartRatelinegraph(
      {super.key, required this.HeartRateList, required this.linesChart});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        const SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: width * 0.40,
                    child:
                        const LegendItem(color: AppTheme.appCyanColor, text: 'bpm')),
                // Container(
                //     width: width * 0.40,
                //     child: LegendItem(color:AppTheme.appgreenColor, text: 'Efficiency')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
    RotatedBox(
    quarterTurns: 3,
    child: Container(
      child: const Text("BPM Rate", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),),
    )),
              SizedBox(
                width: HeartRateList.length * 40.0,
                height: height * 0.6,
                child: LineChart(
                  LineChartData(
                    lineBarsData: linesChart,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final day = value.toInt();

                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8.0,
                              child: Text(
                                  formatDate(
                                      DateTime.parse(
                                          HeartRateList[day].timestamp.toString()),
                                      [M, '/', dd, "\n", hh, ":", nn, " ", am]),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 7,
                                      fontWeight: FontWeight.w300)),
                            );
                          },
                          interval: 1,
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            final left = value.toInt();
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8.0,
                              child: Text(
                                  left == 0 ? 'Ratio $left' : left.toString(),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.black)),
                            );
                          },
                          interval: 10,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
