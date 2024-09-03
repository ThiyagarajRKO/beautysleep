// import 'package:android_content_resolver/android_content_resolver.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hue/utils/color_converter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import '../ModelResponse/HeartRateResponse.dart';
import '../ModelResponse/SleepModelForExcel.dart';
import '../ModelResponse/SleepResponse.dart';
import '../ModelResponse/StressResponse.dart';
import '../ModelResponse/WithingsSleepResponseData.dart';
import '../ModelResponse/ewallet_error.dart';
import '../ModelResponse/token_response.dart';
import '../UI/dummy.dart';
import '../Utilis/AppUtility.dart';
import '../Utilis/app_preference.dart';
import '../Utilis/theme.dart';
import '../api_config/ApiUrl.dart';
import '../api_connect/api_connect.dart';
import 'package:http/http.dart' as http;

import '../shared_preferences/app_preferences.dart';

class HomeScreenController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: 'YOUR_WEB_CLIENT_ID', // Replace with your Web Client ID
  );

  BuildContext? context;
  RxString ringmessage = RxString("Swipe to add");
  RxBool ringswiped = RxBool(false);
  RxBool initialLoading = RxBool(false);
  RxBool fetchedUserName = RxBool(false);
  RxBool fetchedAccessToken = RxBool(false);
  RxBool fetchedDeviceList = RxBool(false);
  RxBool fetchedLightOn = RxBool(false);
  TextEditingController TokenRingController = TextEditingController();
  RxString bedmessage = RxString("Swipe to add");
  RxBool bedswiped = RxBool(false);
  RxBool lightSwiped = RxBool(false);
  RxBool stressExporting = RxBool(false);
  RxBool sleepExporting = RxBool(false);
  RxBool isTokenAvailable = RxBool(false);
  RxBool googlehomeswiped = RxBool(false);
  TextEditingController TokenBedController = TextEditingController();
  TextEditingController pointsController = TextEditingController(text: "All");
  TextEditingController pointsControllerSecond =
      TextEditingController(text: "All");
  final ApiConnect _connect = Get.put(ApiConnect());
  RxList<SleepResponseData>? sleepData = RxList();
  RxList<StressData> stressData = RxList();
  RxList<WithingsSeries> withingsSeriesData = RxList();
  RxList<HeartRateData> heartRateData = RxList();
  RxList<String>? key = RxList();
  RxList<String>? keySecond = RxList();
  RxList<String> selectedPoints = RxList();
  RxList<String> selectedPointsSecond = RxList();
  RxList<SleepModelForExcel> sleepExcelModel = RxList();
  List<LineChartBarData>? lineChart = [];
  List<LineChartBarData>? lineChartSecond = [];
  List<LineChartBarData>? lineChartThird = [];
  List<LineChartBarData>? lineChartForWithingsHeart = [];

  List<FlSpot> bpm = [];
  List<FlSpot> withingsFLSpot = [];

  String from_date = "";
  String to_date = "";

  String from_date_stress = "";
  String to_date_stress = "";

  String from_date_withings = "";
  String to_date_withings = "";

  RxString currentDate = RxString("");
  RxString currentDateStress = RxString("");
  RxString currentDateWithigsHeart = RxString("");
  RxString currentDateHeartFromRate = RxString("");
  RxString currentDateHeartToRate = RxString("");

  RxList<String> selectedPointsThird = RxList();
  RxList<String>? keyThird = RxList();

  String from_date_heartrate = "";
  String to_date_heartrate = "";

  RxBool isPoints = RxBool(false);
  RxBool isPointsSecond = RxBool(false);

  List<String> alphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K"
  ];

  List<FlSpot> spotsDeepSleep = [];
  List<FlSpot> spotsEfficiency = [];
  List<FlSpot> spotsLatency = [];
  List<FlSpot> spotsRemSleep = [];
  List<FlSpot> spotsRestfulness = [];
  List<FlSpot> spotsTiming = [];
  List<FlSpot> spotsTotalSleep = [];
  List<FlSpot> recoveryHigh = [];
  List<FlSpot> stressHigh = [];
  List<BarChartGroupData> withingsSleepBarChart = [];

  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  final RxList<ChartData> data = <ChartData>[
    ChartData('Jan', 35),
    ChartData('Feb', 28),
    ChartData('Mar', 34),
    ChartData('Apr', 32),
    ChartData('May', 40)
  ].obs;

  @override
  void onInit() async {
    super.onInit();

    if (AppPreference().ringToken.isEmpty) {
      isTokenAvailable.value = false;
    } else {
      ApiUrl.ringToken = "Bearer ${AppPreference().ringToken.trim()}";
      isTokenAvailable.value = true;
    }

    currentDateWithigsHeart.value = "${formatDate(DateTime.now(), [
          "01",
          '-',
          mm,
          '-',
          yyyy
        ])}  -  ${formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy])}";

    from_date_withings = formatDate(DateTime.now(), [yyyy, '-', mm, '-', "01"]);
    to_date_withings = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    if (isTokenAvailable.value) {
      from_date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', "01"]);
      to_date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

      currentDate.value = "${formatDate(DateTime.now(), [
            "01",
            '-',
            mm,
            '-',
            yyyy
          ])}  -  ${formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy])}";

      from_date_stress = formatDate(DateTime.now(), [yyyy, '-', mm, '-', "01"]);
      to_date_stress = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

      currentDateStress.value = "${formatDate(DateTime.now(), [
            "01",
            '-',
            mm,
            '-',
            yyyy
          ])}  -  ${formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy])}";

      DateTime now = DateTime.now();
      DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(now.toUtc());
      // Create a DateTime object for the start of today (12:00 AM)
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Define the time zone offset, for example, -12:00
      String timeZoneOffset = '-12:00';

      String fromFormattedDate = DateFormat("yyyy-MM-dd").format(startOfDay);
      String fromFormattedTime = DateFormat("HH:mm:ss").format(startOfDay);
      from_date_heartrate =
          "${fromFormattedDate}T$fromFormattedTime$timeZoneOffset";

      String toFormattedDate = DateFormat("yyyy-MM-dd").format(now);
      String toFormattedTime = DateFormat("HH:mm:ss").format(now);
      to_date_heartrate = "${toFormattedDate}T$toFormattedTime$timeZoneOffset";

      currentDateHeartFromRate.value = from_date_heartrate;
      currentDateHeartToRate.value = to_date_heartrate;

      key!.add("All");
      key!.add("Deep Sleep");
      key!.add("Efficiency");
      key!.add("Latency");
      key!.add("Rem Sleep");
      key!.add("Restfulness");
      key!.add("Timing");
      key!.add("Total Sleep");

      keySecond!.add("All");
      keySecond!.add("Recovery High");
      keySecond!.add("Stress High");

      for (String value in key!) {
        selectedPoints.add(value);
      }

      for (String value in keySecond!) {
        selectedPointsSecond.add(value);
      }

      firstCall();
      SecondCall();
      HeartRateCall();
    }
  }

  void signOut() {
    TokenRingController.clear();
    AppPreference().clearData();
    sleepData!.clear();
    lineChartSecond!.clear();
    lineChart!.clear();
    spotsDeepSleep.clear();
    spotsEfficiency.clear();
    spotsLatency.clear();
    spotsRemSleep.clear();
    spotsRestfulness.clear();
    spotsTiming.clear();
    spotsTotalSleep.clear();
    recoveryHigh.clear();
    stressHigh.clear();
    initialLoading.value = true;
    isTokenAvailable.value = false;
    initialLoading.value = false;
  }

  void tokenAdded() {
    if (AppPreference().ringToken.isEmpty) {
      isTokenAvailable.value = false;
    } else {
      isTokenAvailable.value = true;
    }

    if (isTokenAvailable.value) {
      from_date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', "01"]);
      to_date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

      currentDate.value = "${formatDate(DateTime.now(), [
            "01",
            '-',
            mm,
            '-',
            yyyy
          ])}  -  ${formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy])}";
      from_date_stress = formatDate(DateTime.now(), [yyyy, '-', mm, '-', "01"]);
      to_date_stress = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

      currentDateStress.value = "${formatDate(DateTime.now(), [
            "01",
            '-',
            mm,
            '-',
            yyyy
          ])}  -  ${formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy])}";

      DateTime now = DateTime.now();
      // DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(now.toUtc());
      // Create a DateTime object for the start of today (12:00 AM)
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Define the time zone offset, for example, -12:00
      String timeZoneOffset = '-12:00';

      String fromFormattedDate = DateFormat("yyyy-MM-dd").format(startOfDay);
      String fromFormattedTime = DateFormat("HH:mm:ss").format(startOfDay);
      from_date_heartrate =
          "${fromFormattedDate}T$fromFormattedTime$timeZoneOffset";

      String toFormattedDate = DateFormat("yyyy-MM-dd").format(now);
      String toFormattedTime = DateFormat("HH:mm:ss").format(now);
      to_date_heartrate = "${toFormattedDate}T$toFormattedTime$timeZoneOffset";

      currentDateHeartFromRate.value = from_date_heartrate;
      currentDateHeartToRate.value = to_date_heartrate;

      key!.clear();
      selectedPoints.clear();
      selectedPointsSecond.clear();
      keySecond!.clear();

      key!.add("All");
      key!.add("Deep Sleep");
      key!.add("Efficiency");
      key!.add("Latency");
      key!.add("Rem Sleep");
      key!.add("Restfulness");
      key!.add("Timing");
      key!.add("Total Sleep");

      keySecond!.add("All");
      keySecond!.add("Recovery High");
      keySecond!.add("Stress High");

      for (String value in key!) {
        selectedPoints.add(value);
      }

      for (String value in keySecond!) {
        selectedPointsSecond.add(value);
      }

      firstCall();
      SecondCall();
      HeartRateCall();
    }
  }

  Future<void> generateCall() async {
    /*Adding the Points to their separate Array*/

    spotsDeepSleep.clear();
    spotsEfficiency.clear();
    spotsLatency.clear();
    spotsRemSleep.clear();
    spotsRestfulness.clear();
    spotsTiming.clear();
    spotsTotalSleep.clear();

    for (int i = 0; i < sleepData!.length; i++) {
      final contributor = sleepData![i].contributors;

      spotsDeepSleep
          .add(FlSpot(i.toDouble(), contributor!.deepSleep!.toDouble()));
      spotsEfficiency
          .add(FlSpot(i.toDouble(), contributor.efficiency!.toDouble()));
      spotsLatency.add(FlSpot(i.toDouble(), contributor.latency!.toDouble()));
      spotsRemSleep.add(FlSpot(i.toDouble(), contributor.remSleep!.toDouble()));
      spotsRestfulness
          .add(FlSpot(i.toDouble(), contributor.restfulness!.toDouble()));
      spotsTiming.add(FlSpot(i.toDouble(), contributor.timing!.toDouble()));
      spotsTotalSleep
          .add(FlSpot(i.toDouble(), contributor.totalSleep!.toDouble()));
    }
    lineChart!.clear();

    /*Condition for the Drop down*/
    if (selectedPoints.contains("All")) {
      lineChart!.add(
        LineChartBarData(
            spots: spotsDeepSleep,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appBlueColor,
            belowBarData: BarAreaData(
                show: true, color: AppTheme.appBlueColor.withOpacity(0.3))),
      );
      lineChart!.add(
        LineChartBarData(
            spots: spotsEfficiency,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appgreenColor,
            belowBarData: BarAreaData(
                show: true, color: AppTheme.appgreenColor.withOpacity(0.3))),
      );
      lineChart!.add(
        LineChartBarData(
            spots: spotsLatency,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appGreyColor,
            belowBarData: BarAreaData(
                show: true, color: AppTheme.appGreyColor.withOpacity(0.3))),
      );
      lineChart!.add(
        LineChartBarData(
            spots: spotsRemSleep,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appYellowColor,
            belowBarData: BarAreaData(
                show: true, color: AppTheme.appYellowColor.withOpacity(0.3))),
      );
      lineChart!.add(
        LineChartBarData(
            spots: spotsRestfulness,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appPurpleColor,
            belowBarData: BarAreaData(
                show: true, color: AppTheme.appPurpleColor.withOpacity(0.3))),
      );
      lineChart!.add(
        LineChartBarData(
            spots: spotsTiming,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appOrangeColor,
            belowBarData: BarAreaData(
                show: true, color: AppTheme.appOrangeColor.withOpacity(0.3))),
      );
      lineChart!.add(
        LineChartBarData(
            spots: spotsTotalSleep,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appDeepPurpleColor,
            belowBarData: BarAreaData(
                show: true,
                color: AppTheme.appDeepPurpleColor.withOpacity(0.3))),
      );
    } else {
      if (selectedPoints.contains("Stress High")) {
        lineChart!.add(
          LineChartBarData(
            spots: stressHigh,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appRedColor,
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.appRedColor.withOpacity(0.3),
            ),
          ),
        );
      }
      if (selectedPoints.contains("Stress Recovery")) {
        lineChart!.add(
          LineChartBarData(
            spots: recoveryHigh,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appCyanColor,
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.appCyanColor.withOpacity(0.3),
            ),
          ),
        );
      }
      if (selectedPoints.contains("Deep Sleep")) {
        lineChart!.add(
          LineChartBarData(
              spots: spotsDeepSleep,
              isCurved: true,
              barWidth: 4,
              color: AppTheme.appBlueColor,
              belowBarData: BarAreaData(
                  show: true, color: AppTheme.appBlueColor.withOpacity(0.3))),
        );
      }
      if (selectedPoints.contains("Efficiency")) {
        lineChart!.add(
          LineChartBarData(
              spots: spotsEfficiency,
              isCurved: true,
              barWidth: 4,
              color: AppTheme.appgreenColor,
              belowBarData: BarAreaData(
                  show: true, color: AppTheme.appgreenColor.withOpacity(0.3))),
        );
      }
      if (selectedPoints.contains("Latency")) {
        lineChart!.add(
          LineChartBarData(
              spots: spotsLatency,
              isCurved: true,
              barWidth: 4,
              color: AppTheme.appGreyColor,
              belowBarData: BarAreaData(
                  show: true, color: AppTheme.appGreyColor.withOpacity(0.3))),
        );
      }
      if (selectedPoints.contains("Rem Sleep")) {
        lineChart!.add(
          LineChartBarData(
              spots: spotsRemSleep,
              isCurved: true,
              barWidth: 4,
              color: AppTheme.appYellowColor,
              belowBarData: BarAreaData(
                  show: true, color: AppTheme.appYellowColor.withOpacity(0.3))),
        );
      }
      if (selectedPoints.contains("Restfulness")) {
        lineChart!.add(
          LineChartBarData(
              spots: spotsRestfulness,
              isCurved: true,
              barWidth: 4,
              color: AppTheme.appPurpleColor,
              belowBarData: BarAreaData(
                  show: true, color: AppTheme.appPurpleColor.withOpacity(0.3))),
        );
      }
      if (selectedPoints.contains("Timing")) {
        lineChart!.add(
          LineChartBarData(
              spots: spotsTiming,
              isCurved: true,
              barWidth: 4,
              color: AppTheme.appOrangeColor,
              belowBarData: BarAreaData(
                  show: true, color: AppTheme.appOrangeColor.withOpacity(0.3))),
        );
      }
      if (selectedPoints.contains("Total Sleep")) {
        lineChart!.add(
          LineChartBarData(
              spots: spotsTotalSleep,
              isCurved: true,
              barWidth: 4,
              color: AppTheme.appDeepPurpleColor,
              belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.appDeepPurpleColor.withOpacity(0.3))),
        );
      }
    }
    creatingExcel();
    initialLoading.value = true;
    initialLoading.value = false;
  }

  Future<void> generateCallSecond() async {
    /*Adding the Points to their separate Array*/
    stressHigh.clear();
    recoveryHigh.clear();
    lineChartSecond!.clear();

    for (int i = 0; i < stressData.length; i++) {
      final contributors = stressData[i];
      stressHigh.add(FlSpot(i.toDouble(), contributors.stressHigh!.toDouble()));
      recoveryHigh
          .add(FlSpot(i.toDouble(), contributors.recoveryHigh!.toDouble()));
    }

    /*Condition for the Drop down*/
    if (selectedPointsSecond.contains("All")) {
      lineChartSecond!.add(
        LineChartBarData(
          spots: recoveryHigh,
          isCurved: true,
          barWidth: 4,
          color: AppTheme.appCyanColor,
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.appCyanColor.withOpacity(0.3),
          ),
        ),
      );

      lineChartSecond!.add(
        LineChartBarData(
          spots: stressHigh,
          isCurved: true,
          barWidth: 4,
          color: AppTheme.appRedColor,
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.appRedColor.withOpacity(0.3),
          ),
        ),
      );
    } else {
      if (selectedPointsSecond.contains("Stress High")) {
        lineChartSecond!.add(
          LineChartBarData(
            spots: stressHigh,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appCyanColor,
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.appCyanColor.withOpacity(0.3),
            ),
          ),
        );
      }
      if (selectedPointsSecond.contains("Recovery High")) {
        lineChartSecond!.add(
          LineChartBarData(
            spots: recoveryHigh,
            isCurved: true,
            barWidth: 4,
            color: AppTheme.appRedColor,
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.appRedColor.withOpacity(0.3),
            ),
          ),
        );
      }
    }

    initialLoading.value = true;
    initialLoading.value = false;
  }

  Future<void> firstCall() async {
    if (!await AppUtility().connectionChecker()) {
      return;
    }

    initialLoading.value = true;

    AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
    String url =
        "${ApiUrl.baseUrl}${ApiUrl.getSleepData}$from_date&end_date=$to_date";
    var response = await _connect.getSleepData(url);
    print("sleepdataresponse$response");
    sleepData!.clear();
    Get.back();
    if (response.data != null) {
      sleepData!.value = response.data!;
      createOuraResponse();
    } else {
      ringmessage = RxString("Swipe to add");
      signOut();
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }

  Future<void> SecondCall() async {
    if (!await AppUtility().connectionChecker()) {
      return;
    }

    AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
    String url =
        "${ApiUrl.baseUrl}${ApiUrl.getStressData}$from_date_stress&end_date=$to_date_stress";
    var response = await _connect.getStressData(url);
    print("Stressdataresponse$response");
    stressData.clear();
    Get.back();
    if (response.data != null) {
      stressData.value = response.data!;
      print("stress data ${stressData.value}");

      createOuraResponse();
    } else {
      ringmessage = RxString("Swipe to add");
      signOut();
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }

  Future<void> withingSleep() async {
    if (!await AppUtility().connectionChecker()) {
      return;
    }

    Map<String, dynamic> payload = {
      'action': "getsummary",
      'startdateymd': from_date_withings,
      'enddateymd': to_date_withings,
      'data_fields':
          'data_fields=nb_rem_episodes,sleep_efficiency,sleep_latency,total_sleep_time,total_timeinbed,wakeup_latency,waso,apnea_hypopnea_index,breathing_disturbances_intensity,asleepduration,deepsleepduration,durationtosleep,durationtowakeup,hr_average,hr_max,hr_min,lightsleepduration,night_events,out_of_bed_count,remsleepduration,rr_average,rr_max,rr_min,sleep_score,snoring,snoringepisodecount,wakeupcount,wakeupduration'
    };

    AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);

    var response = await _connect.getWithingsSleep(payload);
    print("Stressdataresponse$response");
    withingsSleepBarChart.clear();
    Get.back();
    if (response.body != null &&
        response.body!.series != null &&
        response.body!.series!.isNotEmpty) {
      withingsSeriesData.value = response.body!.series!;

      int j = 0;
      for (int i = 0; i < withingsSeriesData.length; i++) {
        withingsSleepBarChart.add(BarChartGroupData(x: j, barRods: [
          BarChartRodData(
            toY: double.parse(
                withingsSeriesData[i].data!.remsleepduration!.toString()),
            color: Colors.cyan,
            width: 70,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ]));

        j++;
        withingsSleepBarChart.add(BarChartGroupData(x: j, barRods: [
          BarChartRodData(
            toY: double.parse(
                withingsSeriesData[i].data!.deepsleepduration!.toString()),
            color: Colors.blue,
            width: 30,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ]));
        j++;
        withingsSleepBarChart.add(BarChartGroupData(x: j, barRods: [
          BarChartRodData(
            toY: double.parse(
                withingsSeriesData[i].data!.lightsleepduration!.toString()),
            color: Colors.green,
            width: 50,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ]));
      }
      generateWithingsHeart();
      bedswiped.value = true;
      print("withingsSeriesData ${stressData.value}");
    } else {
      ringmessage = RxString("Swipe to add");
      signOut();
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }

  Future<void> excelFileCall(File file) async {
    if (!await AppUtility().connectionChecker()) {
      return;
    }

    AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
    var response = await _connect.imgUpload(file);
    print("uploadresponse$response");
    Get.back();
    if (response.data != null) {
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final String fileName = 'OuraOutput_$timestamp.xlsx';

      Directory? downloadsDirectory;
      try {
        if (Platform.isIOS) {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        } else {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
          if (!await downloadsDirectory.exists()) {
            downloadsDirectory = await getExternalStorageDirectory();
          }
        }
      } catch (err) {
        print("Cannot get download folder path");
      }
      String downloadDir =
          '${downloadsDirectory?.path}/$fileName'; // Use path separator

      print("Download Directory: $downloadDir");

      // downloadFile(response.data!,fileName, downloadsDirectory!.path!);
      var dio = Dio();
      await dio.download(response.data ?? "", downloadDir);
      Fluttertoast.showToast(
        msg: "Downloaded Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    } else {
      ringmessage = RxString("Swipe to add");
      signOut();
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        filePath = 'Error code: ${response.statusCode}';
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  Future<void> HeartRateCall() async {
    if (!await AppUtility().connectionChecker()) {
      return;
    }
    AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
    String url =
        "${ApiUrl.baseUrl}${ApiUrl.getHeartRateData}${currentDateHeartFromRate.value}&end_datetime=${currentDateHeartToRate.value}";
    var response = await _connect.getHeartRateData(url);
    print("Stressdataresponse$response");
    heartRateData.clear();
    Get.back();
    if (response.data != null) {
      heartRateData.value = response.data!;
      print("stress data ${heartRateData.value}");
      createOuraResponse();
    } else {
      ringmessage = RxString("Swipe to add");
      signOut();
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }

  Future<void> generateCallThird() async {
    bpm.clear();
    lineChartThird!.clear();

    for (int i = 0; i < heartRateData.length; i++) {
      final contributors = heartRateData[i];
      bpm.add(FlSpot(i.toDouble(), contributors.bpm!.toDouble()));
    }

    lineChartThird!.add(
      LineChartBarData(
        spots: bpm,
        isCurved: true,
        barWidth: 4,
        color: AppTheme.appCyanColor,
        belowBarData: BarAreaData(
          show: true,
          color: AppTheme.appCyanColor.withOpacity(0.3),
        ),
      ),
    );

    initialLoading.value = true;
    initialLoading.value = false;
  }

  Future<void> generateWithingsHeart() async {
    withingsFLSpot.clear();
    lineChartForWithingsHeart!.clear();

    for (int i = 0; i < withingsSeriesData.length; i++) {
      final contributors = withingsSeriesData[i];
      withingsFLSpot
          .add(FlSpot(i.toDouble(), contributors.data!.hrAverage!.toDouble()));
    }

    lineChartForWithingsHeart!.add(
      LineChartBarData(
        spots: withingsFLSpot,
        isCurved: true,
        barWidth: 4,
        color: AppTheme.appCyanColor,
        belowBarData: BarAreaData(
          show: true,
          color: AppTheme.appCyanColor.withOpacity(0.3),
        ),
      ),
    );

    initialLoading.value = true;
    initialLoading.value = false;
  }

  Future<void> createOuraResponse() async {
    generateCall();
    generateCallSecond();
    generateCallThird();
    initialLoading.value = true;
    initialLoading.value = false;
  }

  Future<void> createExcelSecond() async {
    if (selectedPointsSecond.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Select the category",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );

      return;
    }

    if (stressData.isEmpty) {
      Fluttertoast.showToast(
        msg: "No data in Stress",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );

      return;
    }

    final Workbook workbook = Workbook();
    int i;

    /*Creating Sheet and fitting data into it*/
    late Worksheet sheet;
    sheet = workbook.worksheets[0];

    if (stressData.isNotEmpty) {
      sheet.getRangeByName('A1').setText("Date");

      if (selectedPointsSecond.contains("All") ||
          (selectedPointsSecond.contains("Recovery High") &&
              selectedPointsSecond.contains("Stress High"))) {
        sheet.getRangeByName('B1').setText("Recovery High");
        sheet.getRangeByName('C1').setText("Stress High");

        for (i = 0; i < stressData.length; i++) {
          sheet
              .getRangeByName("A${i + 2}")
              .setText(stressData[i].day.toString());
          sheet
              .getRangeByName("B${i + 2}")
              .setText(stressData[i].recoveryHigh.toString());
          sheet
              .getRangeByName("C${i + 2}")
              .setText(stressData[i].stressHigh!.toString());
        }
      } else {
        if (selectedPointsSecond.contains("Recovery High")) {
          sheet.getRangeByName('B1').setText("Recovery High");

          for (i = 0; i < stressData.length; i++) {
            sheet
                .getRangeByName("A${i + 2}")
                .setText(stressData[i].day.toString());
            sheet
                .getRangeByName("B${i + 2}")
                .setText(stressData[i].recoveryHigh.toString());
          }
        } else if (selectedPointsSecond.contains("Stress High")) {
          sheet.getRangeByName('B1').setText("Stress High");

          for (i = 0; i < stressData.length; i++) {
            sheet
                .getRangeByName("A${i + 2}")
                .setText(stressData[i].day.toString());
            sheet
                .getRangeByName("B${i + 2}")
                .setText(stressData[i].stressHigh.toString());
          }
        }
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isWindows ? '$path\\OuraOutput.xlsx' : '$path/OuraOutput.xlsx';

    print("FilePath$fileName");
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);

    excelFileCall(file);
  }

  Future<void> createExcelWithings() async {
    if (withingsSeriesData.isEmpty) {
      Fluttertoast.showToast(
        msg: "No data in Stress",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
      return;
    }

    final Workbook workbook = Workbook();
    int i;

    /*Creating Sheet and fitting data into it*/
    late Worksheet sheet;
    sheet = workbook.worksheets[0];

    if (withingsSeriesData.isNotEmpty) {
      sheet.getRangeByName('A1').setText("Date");
      sheet.getRangeByName('B1').setText("Heart Rate Average");
      sheet.getRangeByName('C1').setText("Total Sleep");
      sheet.getRangeByName('D1').setText("Sleep Score");
      sheet.getRangeByName('E1').setText("Sleep Efficiency");
      sheet.getRangeByName('F1').setText("Duration Sleep");
      sheet.getRangeByName('G1').setText("Rem Sleep Duration");

      for (i = 0; i < withingsSeriesData.length; i++) {
        sheet
            .getRangeByName("A${i + 2}")
            .setText(withingsSeriesData[i].date.toString());
        sheet
            .getRangeByName("B${i + 2}")
            .setText(withingsSeriesData[i].data!.hrAverage.toString());
        sheet
            .getRangeByName("C${i + 2}")
            .setText(withingsSeriesData[i].data!.totalSleepTime.toString());
        sheet
            .getRangeByName("D${i + 2}")
            .setText(withingsSeriesData[i].data!.sleepScore.toString());
        sheet
            .getRangeByName("E${i + 2}")
            .setText(withingsSeriesData[i].data!.sleepEfficiency.toString());

        sheet
            .getRangeByName("F${i + 2}")
            .setText(withingsSeriesData[i].data!.deepsleepduration.toString());

        sheet
            .getRangeByName("G${i + 2}")
            .setText(withingsSeriesData[i].data!.remsleepduration.toString());
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\WithingsSleep.xlsx'
        : '$path/WithingsSleep.xlsx';
    print("FilePath$fileName");
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
    excelFileCall(file);
  }

  Future<void> createExcelThird() async {
    if (heartRateData.isEmpty) {
      Fluttertoast.showToast(
        msg: "No data in Stress",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );

      return;
    }

    Fluttertoast.showToast(
      msg: "Generating Your Data, Please Wait",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.appBlack,
      textColor: AppTheme.primaryColor,
    );

    final Workbook workbook = Workbook();
    int i;

    /*Creating Sheet and fitting data into it*/
    late Worksheet sheet;
    sheet = workbook.worksheets[0];

    if (heartRateData.isNotEmpty) {
      sheet.getRangeByName('A1').setText("Date");

      sheet.getRangeByName('B1').setText("BPM");

      for (i = 0; i < heartRateData.length; i++) {
        sheet.getRangeByName("A${i + 2}").setText(formatDate(
            DateTime.parse(heartRateData[i].timestamp.toString()),
            [M, '/', dd, " - ", hh, ":", nn, " ", am]));
        sheet
            .getRangeByName("B${i + 2}")
            .setText(heartRateData[i].bpm.toString());
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\OuraOutput.xlsx'
        : '$path/OuraOu12tput.xlsx';

    print("File Pa th$fileName");
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);

    excelFileCall(file);
    OpenFile.open(fileName);
  }

  Future<void> toggleOnOffLight(bool on) async {
    AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
    String url =
        "${ApiUrl.bridgeBaseUrl}${ApiUrl.onOffToggle}${AppPreferences.instance.deviceListResponse!.data![1].services![1].rid}";
    dynamic deviceResponse = await _connect.getOnOffToggle(url, on: on);
    Get.back();
    if (deviceResponse is! ErrorResponse) {
      fetchedLightOn.value = on;
      Fluttertoast.showToast(
        msg: "Light ${on ? "ON" : "OFF"} successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    } else {
      Fluttertoast.showToast(
        msg:
            "Error while fetching DeviceInfo : ${deviceResponse.errorDescription!}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }

  Future<void> changeColor(String colorName, Color color) async {
    Map colorObject = {};
    print(color.toXy());
    colorObject = {
      "dimming": {"brightness": 50.0},
      "color": {
        "xy": {"x": color.toXy()[0], "y": color.toXy()[1], "z": color.toXy()[2]}
      }
    };

    AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
    String changeColorURL =
        "${ApiUrl.bridgeBaseUrl}${ApiUrl.onOffToggle}${AppPreferences.instance.deviceListResponse!.data![1].services![1].rid}";
    dynamic deviceResponse =
        await _connect.changeColor(changeColorURL, body: colorObject);
    Get.back();
    if (deviceResponse is! ErrorResponse) {
      Fluttertoast.showToast(
        msg: "Light color changed as $colorName",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    } else {
      Fluttertoast.showToast(
        msg:
            "Error while fetching DeviceInfo : ${deviceResponse.errorDescription!}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }

  Future<void> getCloudToken(String code, String pkce) async {

      AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
      String url = ApiUrl.getTokenURL;
      dynamic res = await _connect.getToken(url,
          clientSecret: AppUtility.clientSecret,
          clientId: AppUtility.clientId,
          body: {"code": code, "grant_type": "authorization_code"});
      Get.back();
      if (res is TokenResponse) {
        await AppPreferences.setAccessToken(res.accessToken!);
        await AppPreferences.setRefreshToken(res.refreshToken!);
        fetchedAccessToken.value = true;
        AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
        String getConfigUrl = "${ApiUrl.bridgeBaseUrl}${ApiUrl.config}";
        dynamic configResponse = await _connect.getConfig(getConfigUrl);
        Get.back();
        if (configResponse is! ErrorResponse) {
          AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
          String getUsernameUrl = "${ApiUrl.bridgeBaseUrl}${ApiUrl.username}";
          dynamic usernameResponse = await _connect.getUsername(getUsernameUrl);
          Get.back();
          if (usernameResponse is! ErrorResponse) {
            await AppPreferences.setUsername(
                usernameResponse[0]["success"]["username"]);
            fetchedUserName.value = true;
            AppUtility.loader(Get.context!, MsgEnum.COMMON_LOADING);
            String getDeviceUrl = "${ApiUrl.bridgeBaseUrl}${ApiUrl.getDevice}";
            dynamic deviceResponse = await _connect.getDevice(getDeviceUrl);
            Get.back();
            if (deviceResponse is! ErrorResponse) {
              await AppPreferences.setLoggedInStatus(true);
              await AppPreferences.setDeviceList(deviceResponse);
              dynamic deviceDetails = await _connect.getDeviceDetails(
                  "${ApiUrl.bridgeBaseUrl}${ApiUrl.onOffToggle}${AppPreferences.instance.deviceListResponse!.data![1].services![1].rid}");
              if (deviceResponse is! ErrorResponse) {
                fetchedLightOn.value = deviceDetails["data"][0]["on"]["on"];
                fetchedDeviceList.value = true;
                Fluttertoast.showToast(
                  msg: "Device details fetched successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: AppTheme.appBlack,
                  textColor: AppTheme.primaryColor,
                );
              }
            } else {
              Fluttertoast.showToast(
                msg: "Something went wrong. Please try again!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppTheme.appBlack,
                textColor: AppTheme.primaryColor,
              );
            }
          } else {
            Fluttertoast.showToast(
              msg: "Something went wrong. Please try again!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppTheme.appBlack,
              textColor: AppTheme.primaryColor,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Something went wrong. Please try again!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppTheme.appBlack,
            textColor: AppTheme.primaryColor,
          );
        }
      }
      debugPrint("getToken RESPONSE $res");
  }

  getDeviceDetailsAlone()async{
    dynamic deviceDetails = await _connect.getDeviceDetails(
        "${ApiUrl.bridgeBaseUrl}${ApiUrl.onOffToggle}${AppPreferences.instance.deviceListResponse!.data![1].services![1].rid}");
    if (deviceDetails is! ErrorResponse) {
      fetchedAccessToken.value = true;
      fetchedUserName.value = true;
      fetchedLightOn.value = deviceDetails["data"][0]["on"]["on"];
      fetchedDeviceList.value = true;
      Fluttertoast.showToast(
        msg: "Device details fetched successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
    }
  }
  Future<void> createExcelTry() async {
    if (selectedPoints.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Select the category",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
      return;
    }

    if (sleepExcelModel.isEmpty) {
      Fluttertoast.showToast(
        msg: "Submit your selection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
      return;
    }

    if (sleepData!.isEmpty) {
      Fluttertoast.showToast(
        msg: "No data in Stress",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
      return;
    }

    Fluttertoast.showToast(
      msg: "Generating Your Data, Please Wait",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.appBlack,
      textColor: AppTheme.primaryColor,
    );

    final Workbook workbook = Workbook();
    int i;

    /*Creating Sheet and fitting data into it*/
    late Worksheet sheet;
    sheet = workbook.worksheets[0];

    for (i = 0; i < sleepExcelModel.length; i++) {
      print("Alphabet : ${alphabet[i]}${1}");
      print(sleepExcelModel[i].modelName);

      sheet
          .getRangeByName("${alphabet[i]}${1}")
          .setText(sleepExcelModel[i].modelName);

      for (int j = 0; j < sleepExcelModel[i].modelList!.length; j++) {
        sheet
            .getRangeByName("${alphabet[i]}${j + 2}")
            .setText(sleepExcelModel[i].modelList![j].toString());
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = Platform.isWindows
        ? '$path\\OuraOutput.xlsx'
        : '$path/OuraOu12tput.xlsx';

    print("File Path$fileName");
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);

    excelFileCall(file);
    OpenFile.open(fileName);
  }

  Future<void> creatingExcel() async {
    sleepExcelModel.clear();
    SleepModelForExcel sleep = SleepModelForExcel();
    sleep.modelName = "Date";

    List<String> val = [];

    for (var data in sleepData!) {
      val.add(data.day.toString());
    }
    sleep.modelList = val;
    sleepExcelModel.add(sleep);

    for (String value in selectedPoints) {
      if (value == "Deep Sleep") {
        SleepModelForExcel sleep = SleepModelForExcel();
        sleep.modelName = "Deep Sleep";
        List<String> val = [];

        for (var data in sleepData!) {
          val.add(data.contributors!.deepSleep.toString());
        }
        sleep.modelList = val;
        sleepExcelModel.add(sleep);
      }

      if (value == "Efficiency") {
        SleepModelForExcel sleep = SleepModelForExcel();
        sleep.modelName = "Efficiency";
        List<String> val = [];

        for (var data in sleepData!) {
          val.add(data.contributors!.efficiency.toString());
        }
        sleep.modelList = val;
        sleepExcelModel.add(sleep);
      }

      if (value == "Latency") {
        SleepModelForExcel sleep = SleepModelForExcel();
        sleep.modelName = "Latency";
        List<String> val = [];

        for (var data in sleepData!) {
          val.add(data.contributors!.latency.toString());
        }
        sleep.modelList = val;
        sleepExcelModel.add(sleep);
      }

      if (value == "Rem Sleep") {
        SleepModelForExcel sleep = SleepModelForExcel();
        sleep.modelName = "Rem Sleep";
        List<String> val = [];

        for (var data in sleepData!) {
          val.add(data.contributors!.remSleep.toString());
        }
        sleep.modelList = val;
        sleepExcelModel.add(sleep);
      }
      if (value == "Restfulness") {
        SleepModelForExcel sleep = SleepModelForExcel();
        sleep.modelName = "Restfulness";
        List<String> val = [];

        for (var data in sleepData!) {
          val.add(data.contributors!.restfulness.toString());
        }
        sleep.modelList = val;
        sleepExcelModel.add(sleep);
      }
      if (value == "Timing") {
        SleepModelForExcel sleep = SleepModelForExcel();
        sleep.modelName = "Timing";
        List<String> val = [];

        for (var data in sleepData!) {
          val.add(data.contributors!.timing.toString());
        }
        sleep.modelList = val;
        sleepExcelModel.add(sleep);
      }
      if (value == "Total Sleep") {
        SleepModelForExcel sleep = SleepModelForExcel();
        sleep.modelName = "Total Sleep";
        List<String> val = [];

        for (var data in sleepData!) {
          val.add(data.contributors!.totalSleep.toString());
        }
        sleep.modelList = val;
        sleepExcelModel.add(sleep);
      }
    }
  }

  Future<void> authenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;
        print('Access Token: ${auth.accessToken}');
        // Use auth.accessToken to make API calls
      }
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> sendAssistantCommand(String command) async {
    final account = _googleSignIn.currentUser;
    if (account == null) {
      await authenticateWithGoogle();
    }

    final GoogleSignInAuthentication auth =
        await _googleSignIn.currentUser!.authentication;
    final response = await http.post(
      Uri.parse('https://actions.googleapis.com/v2/conversations:send'),
      headers: {
        'Authorization': 'Bearer ${auth.accessToken}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'input': {
          'text': {
            'query': command,
          },
        },
        'conversation': {
          'conversationId': '1234',
          'type': 'NEW',
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Command sent successfully');
    } else {
      print('Failed to send command: ${response.body}');
    }
  }

  ///*** PHILIPS HUE Bridge Device Configuration APIs ***/
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
