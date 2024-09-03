import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/HomeController.dart';
import '../ModelResponse/StressResponse.dart';
import '../Utilis/theme.dart';

class StressLineGraph extends StatelessWidget {
  final List<StressData> StressList;
  final List<LineChartBarData> linesChart;

  const StressLineGraph({super.key, required this.StressList, required this.linesChart});

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 20),
        Obx(()=>  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.selectedPointsSecond.value.contains('Recovery High')?
             const Visibility(
               visible: true,
               child: Padding(
                 padding: EdgeInsets.only(left: 8),
                 child: LegendItem(
                         color: AppTheme.appRedColor, text: 'Recovery High'),
                   ),
             ):Container(),

              controller.selectedPointsSecond.value.contains("Stress High")?
              const Visibility(
                visible: true,
                child:  Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: LegendItem(
                          color: AppTheme.appCyanColor, text: 'Stress High'),
                ),
              ):Container(),
            ],
          ),),
          const SizedBox(height: 20),
        ]),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    child: const Text("Ratio", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),),
                  )),
              SizedBox(
                width: StressList.length > 12 ?StressList.length * 40.0 :  width * 1.2,
                height: height * 0.6,
                child: LineChart(
                  LineChartData(
                    lineBarsData: linesChart,
                    // lineBarsData: [
                    //   LineChartBarData(
                    //     spots: recoveryHigh,
                    //     isCurved: true,
                    //     color: Colors.red,
                    //     barWidth: 2,
                    //     belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.3)),
                    //   ),
                    //   LineChartBarData(
                    //     spots: stressHigh,
                    //     isCurved: true,
                    //     color: Colors.blue,
                    //     barWidth: 2,
                    //     belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                    //   ),
                    // ],
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
                                      DateTime.parse(StressList[day].day.toString()),
                                      [M, '/', dd]),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400)),
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
                              child: Text(left == 0 ? 'Ratio $left' : left.toString(),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.black)),
                            );
                          },
                          interval: 1000,
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
