import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/HomeController.dart';


class Tracksleepcyclegraph extends StatelessWidget {
  final List<BarChartGroupData> withingsSeriesData;

  const Tracksleepcyclegraph({super.key, required this.withingsSeriesData});

  double getMaxY() {
    double maxY = 0;
    for (var group in withingsSeriesData) {
      for (var rod in group.barRods) {
        if (rod.toY > maxY) {
          maxY = rod.toY;
        }
      }
    }
    return maxY;
  }

  double calculateYInterval(double maxY) {
    double interval = maxY / 5; // Default interval to display around 5 values
    if (interval < 1) interval = 1; // Ensure interval is at least 1
    return interval;
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double maxY = getMaxY();
    double yInterval = calculateYInterval(maxY);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 350,
          width: withingsSeriesData.length > 12 ?withingsSeriesData.length * 40.0 :  width * 1.2,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.start,
                maxY: maxY * 1.2, // Add some padding to the maxY
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        if (value % yInterval == 0) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(
                              value == 0 ? 'Ratio $value' : value.toInt().toString(),
                              style: const TextStyle(fontSize: 10, color: Colors.black),
                            ),
                          );
                        }
                        return Container(); // Hide other values
                      },
                      interval: yInterval,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Adjust these x-axis values based on your data
                        switch (value.toInt()) {
                          case 0:
                            return const Text('11:49PM');
                          case 1:
                            return const Text('12:00AM');
                          case 2:
                            return const Text('1:00AM');
                          case 3:
                            return const Text('2:00AM');
                          case 4:
                            return const Text('7:45AM');
                          default:
                            return const Text('');
                        }
                      },
                      interval: 1, // Adjust interval as needed
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: withingsSeriesData,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("Deep", style: TextStyle(color: Colors.black)),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("REM", style: TextStyle(color: Colors.black)),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("Light", style: TextStyle(color: Colors.black)),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
        const SizedBox(height: 15),
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
