import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/HomeController.dart';
import '../../ModelResponse/WithingsSleepResponseData.dart';
import '../HorizontalScrollView.dart';

class Sleepscoregraph extends StatelessWidget {
  // final List<Data> StressList;
  final RxList<WithingsSeries> withingsSeriesData;

  const Sleepscoregraph({super.key, required this.withingsSeriesData});

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
        width: width,
        height: 300,
      child: HorizontalScrollView(
          children: List.generate(controller.withingsSeriesData.length, (index) {
        var model = controller.withingsSeriesData[index];
        return Column(
          children: [
            Text(model.date.toString(),style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.black),),

            const SizedBox(height: 10,),
            Container(
                width: width,
                height: 240,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 8),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey,
                          ),
                          child: Center(
                              child: Text(
                                model.data!.sleepScore.toString(),
                            style: const TextStyle(color: Colors.white),
                          ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        // color: Colors.red,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Duration",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      model.data!.durationtosleep.toString(),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Recovery",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "Good",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Interruptions",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "${model.data!.wakeupcount} Times",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.yellowAccent),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Regularity",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "Poor",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Time to sleep",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      model.data!.totalSleepTime.toString(),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        );
      })),
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
