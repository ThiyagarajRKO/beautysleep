import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/HomeController.dart';
import '../ModelResponse/SleepResponse.dart';
import '../Utilis/theme.dart';

class Sleeplinegraph extends StatelessWidget {
  final List<SleepResponseData> StressList;
  final List<LineChartBarData> linesChart;

  const Sleeplinegraph({super.key, required this.StressList, required this.linesChart});

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Obx(()=> Row(
          // mainAxisAlignment: MainAxisAlignment.center,
           children: [
             // SizedBox(width: width*0.07,),
             controller.selectedPoints.value.contains("Deep Sleep")?
             const Visibility(
               visible: true,
               child:  Padding(
                     padding: EdgeInsets.all(8),
                     child: LegendItem(color:AppTheme.appBlueColor, text: 'Deep Sleep'),
                   ),
             ):Container(),
             controller.selectedPoints.value.contains("Efficiency")?

             const Visibility(
               visible: true,
               child: Padding(
                 padding: EdgeInsets.all(8),

                     child: LegendItem(color:AppTheme.appgreenColor, text: 'Efficiency'),
                   ),
             ):Container(),
             // SizedBox(height: 20),
             controller.selectedPoints.value.contains("Latency")?

             const Visibility(
               visible:true,
               child: Padding(
                 padding: EdgeInsets.all(8),

                     child: LegendItem(color:AppTheme.appGreyColor, text: 'Latency'),
                   ),
             ):Container(),
             controller.selectedPoints.value.contains("Rem Sleep")?

             const Visibility(visible: true,
               child:  Padding(
                 padding: EdgeInsets.all(8),

                     child: LegendItem(color:AppTheme.appYellowColor, text: 'Rem Sleep'),
                   ),
             ):Container(),
             // SizedBox(height: 20),
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 controller.selectedPoints.value.contains("Restfulness")?
                 const Visibility(
                   visible:true,
                   child: Padding(
                     padding: EdgeInsets.all(8),

                         child: LegendItem(color:AppTheme.appPurpleColor, text: 'Restfulness'),
                       ),
                 ):Container(),
                 controller.selectedPoints.value.contains("Timing")?
                 const Visibility(visible: true,
                   child:  Padding(
                     padding: EdgeInsets.all(8),

                         child: LegendItem(color:AppTheme.appOrangeColor, text: 'Timing'),
                       ),
                 ):Container(),
               ],
             ),
             // SizedBox(height: 20),
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 controller.selectedPoints.value.contains("Total Sleep")?
                 const Visibility(
                   visible:true,
                   child:  Padding(
                     padding: EdgeInsets.all(8),

                         child: LegendItem(color: AppTheme.appDeepPurpleColor, text: 'Total Sleep'),
                       ),
                 ):Container(),
               ],
             ),
             // SizedBox(height: 20),
           ],
         )),
        const SizedBox(height: 20),
        SizedBox(
          width: StressList.length > 12 ?StressList.length * 40.0 :  width * 1.2,
          height: height*0.6,
          child: LineChart(
            LineChartData(
              lineBarsData: linesChart,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final day = value.toInt() ;

                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(  formatDate(DateTime.parse(StressList[day].day.toString()), [ M, '/', dd]) ,
                            style: const TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w400)),
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
                    interval: 10,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
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
