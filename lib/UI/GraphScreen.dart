import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Controller/GraphScreenController.dart';

class GraphScreen extends GetView<GraphScreenController> {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {

    GraphScreenController controller = Get.put(GraphScreenController());
    List<_SalesData> data = [
      _SalesData('Jan', 35),
      _SalesData('Feb', 28),
      _SalesData('Mar', 34),
      _SalesData('Apr', 32),
      _SalesData('May', 40)
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Column(children: [
          SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              legend: const Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),

        ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);
  final String year;
  final double sales;
}