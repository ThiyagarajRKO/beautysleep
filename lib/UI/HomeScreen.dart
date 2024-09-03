import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phillips_hue/UI/SpotifyScreen.dart';
import 'package:phillips_hue/UI/strings.dart';
import 'package:phillips_hue/Utilis/AppUtility.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:withings_flutter/withings_flutter.dart';
import '../Components/AppButton2.dart';
import '../Components/AppTabMenu.dart';
import '../Components/HeartRateLineGraph.dart';
import '../Components/SleepAnalyser/HeartRateTrackingGraph.dart';
import '../Components/SleepAnalyser/SleepScoreGraph.dart';
import '../Components/SleepAnalyser/TrackSleepCycleGraph.dart';
import '../Components/StressLineGraph.dart';
import '../Components/SleepLineGraph.dart';
import '../Components/TextInput.dart';
import '../Controller/HomeController.dart';
import '../Controller/forms.dart';
import '../Utilis/app_preference.dart';
import '../Utilis/theme.dart';
import 'package:intl/intl.dart';

import '../api_config/ApiUrl.dart';
import '../shared_preferences/app_preferences.dart';

class HomeScreen extends GetView<HomeScreenController> {
  HomeScreen({super.key});

  StreamSubscription? deepLinkStream;
  @override
  HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    listenLink(controller);
    DateTime? startDate;
    DateTime? endDate;
    final RxString selectedText = RxString("");
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String getDateRangeText() {
      if (startDate != null && endDate != null) {
        selectedText.value =
            "${startDate!.day}.${startDate!.month}-${endDate!.day}.${endDate!.month}";
        return "${startDate!.day}.${startDate!.month}-${endDate!.day}.${endDate!.month}";
      } else {
        return "05.10-12.10";
      }
    }

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: [
            SizedBox(
              height: height * 0.04,
            ),
            const Text(
              "Welcome!",
              style: TextStyle(fontSize: 28, color: AppTheme.textColor),
            ),
            Obx(() => controller.isTokenAvailable.isFalse
                ? Column(
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        height: height * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment(-1.0, 0.0),
                            // Corresponds to 89.7 degrees
                            end: Alignment(1.0, 0.0),
                            // End point for the gradient
                            colors: [
                              AppTheme.appgreen, // #119A8E color
                              AppTheme.fluorescentGreen, // #119A8E color
                              // #36EC7D color
                            ],
                            stops: [0.003, 0.998], // 0.3% and 99.8% stops
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 20),
                                    child: SizedBox(
                                        height: height * 0.08,
                                        width: width * 0.2,
                                        child: Image.asset(
                                            "assets/Images/imagering.png")),
                                  ),
                                  const Text(
                                    "Oura Ring",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: SwipeButton(
                                  thumb: controller.ringswiped.value
                                      ? const Material(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                        )
                                      : Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: const Icon(
                                            Icons.arrow_forward_sharp,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                  activeThumbColor: controller.ringswiped.value
                                      ? Colors.transparent
                                      : Colors.black.withOpacity(0.9),
                                  activeTrackColor: controller.ringswiped.value
                                      ? Colors.black.withOpacity(0.9)
                                      : AppTheme.liteGreen,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Obx(
                                      () => Text(
                                        controller.ringmessage.value,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            color: AppTheme.textColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  onSwipe: () {
                                    controller.ringmessage.value =
                                        "Adding ring";
                                    addToken(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container()),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  // Corresponds to 89.7 degrees
                  end: Alignment(1.0, 0.0),
                  // End point for the gradient
                  colors: [
                    AppTheme.appgreen, // #119A8E color
                    AppTheme.fluorescentGreen, // #119A8E color
                    // #36EC7D color
                  ],
                  stops: [0.003, 0.998], // 0.3% and 99.8% stops
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 15, top: 15),
                          child: SizedBox(
                              height: height * 0.08,
                              width: width * 0.2,
                              child: Image.asset(
                                  "assets/Images/sleepanalyser.png")),
                        ),
                        const Text(
                          " Sleep Analyser",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SwipeButton(
                        thumb: controller.bedswiped.value
                            ? const Material(
                                elevation: 0,
                                color: Colors.transparent,
                                shadowColor: Colors.transparent,
                              )
                            : Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                child: const Icon(
                                  Icons.arrow_forward_sharp,
                                  color: Colors.white,
                                ),
                              ),
                        activeThumbColor: controller.bedswiped.value
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.9),
                        activeTrackColor: controller.bedswiped.value
                            ? Colors.black.withOpacity(0.9)
                            : AppTheme.liteGreen,
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() => Text(
                                  controller.bedmessage.value,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ))),
                        onSwipe: () async {
                          // controller.bedmessage.value = "Adding ring";
                          // addToken(context);
                          Strings.authToken = "";
                          WithingsCredentials? withingsCredentials =
                              await WithingsConnector.authorize(
                                  clientID: Strings.withingsClientID,
                                  clientSecret: Strings.withingsClientSecret,
                                  scope:
                                      'user.activity,user.metrics,user.sleepevents',
                                  redirectUri: Strings.withingsRedirectUri,
                                  callbackUrlScheme:
                                      Strings.withingsCallbackScheme);
                          Strings.authToken =
                              "Bearer ${withingsCredentials!.withingsAccessToken}";
                          print(withingsCredentials.withingsAccessToken);

                          if (Strings.authToken.isNotEmpty) {
                            controller.withingSleep();
                          }
                          // Fluttertoast.showToast(
                          //   msg: "In Development",
                          //   toastLength: Toast.LENGTH_LONG,
                          //   gravity: ToastGravity.BOTTOM,
                          //   backgroundColor: AppTheme.appBlack,
                          //   textColor: AppTheme.primaryColor,
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  // Corresponds to 89.7 degrees
                  end: Alignment(1.0, 0.0),
                  // End point for the gradient
                  colors: [
                    AppTheme.appgreen, // #119A8E color
                    AppTheme.fluorescentGreen, // #119A8E color
                    // #36EC7D color
                  ],
                  stops: [0.003, 0.998], // 0.3% and 99.8% stops
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 15, top: 25),
                          child: SizedBox(
                              height: height * 0.07,
                              width: width * 0.22,
                              child: Image.asset(
                                "assets/Images/thermostat.png",
                                fit: BoxFit.fill,
                              )),
                        ),
                        const Text(
                          "Thermostat",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SwipeButton(
                        thumb: controller.bedswiped.value
                            ? const Material(
                                elevation: 0,
                                color: Colors.transparent,
                                shadowColor: Colors.transparent,
                              )
                            : Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                child: const Icon(
                                  Icons.arrow_forward_sharp,
                                  color: Colors.white,
                                ),
                              ),
                        activeThumbColor: controller.bedswiped.value
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.9),
                        activeTrackColor: controller.bedswiped.value
                            ? Colors.black.withOpacity(0.9)
                            : AppTheme.liteGreen,
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() => Text(
                                  controller.bedmessage.value,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ))),
                        onSwipe: () async {
                          // controller.bedmessage.value = "Adding ring";

                          // controller.bedswiped.value = true;
                          // addToken(context);
                          // Fluttertoast.showToast(
                          //   msg: "In Development",
                          //   toastLength: Toast.LENGTH_LONG,
                          //   gravity: ToastGravity.BOTTOM,
                          //   backgroundColor: AppTheme.appBlack,
                          //   textColor: AppTheme.primaryColor,
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            // Container(
            //   height: height * 0.15,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     gradient: const LinearGradient(
            //       begin: Alignment(-1.0, 0.0),
            //       // Corresponds to 89.7 degrees
            //       end: Alignment(1.0, 0.0),
            //       // End point for the gradient
            //       colors: [
            //         AppTheme.appgreen, // #119A8E color
            //         AppTheme.fluorescentGreen, // #119A8E color
            //         // #36EC7D color
            //       ],
            //       stops: [0.003, 0.998], // 0.3% and 99.8% stops
            //     ),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 15),
            //     child: Row(
            //       children: [
            //         Column(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(
            //                   left: 20, right: 28, top: 25),
            //               child: SizedBox(
            //                   height: height * 0.07,
            //                   width: width * 0.15,
            //                   child: Image.asset(
            //                     "assets/Images/googlehome.png",
            //                     fit: BoxFit.fill,
            //                   )),
            //             ),
            //             const Text(
            //               " Google Home",
            //               style: TextStyle(
            //                   fontWeight: FontWeight.bold, fontSize: 16),
            //             ),
            //           ],
            //         ),
            //         Expanded(
            //           child: SwipeButton(
            //             thumb: controller.bedswiped.value
            //                 ? const Material(
            //                     elevation: 0,
            //                     color: Colors.transparent,
            //                     shadowColor: Colors.transparent,
            //                   )
            //                 : Material(
            //                     color: Colors.transparent,
            //                     borderRadius: BorderRadius.circular(30),
            //                     child: const Icon(
            //                       Icons.arrow_forward_sharp,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //             activeThumbColor: controller.bedswiped.value
            //                 ? Colors.transparent
            //                 : Colors.black.withOpacity(0.9),
            //             activeTrackColor: controller.bedswiped.value
            //                 ? Colors.black.withOpacity(0.9)
            //                 : AppTheme.liteGreen,
            //             child: AnimatedSwitcher(
            //                 duration: const Duration(milliseconds: 300),
            //                 child: Obx(() => Text(
            //                       controller.bedmessage.value,
            //                       textAlign: TextAlign.end,
            //                       style: const TextStyle(
            //                           color: AppTheme.textColor,
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w500),
            //                     ))),
            //             onSwipe: () {
            //               // controller.bedmessage.value = "Adding ring";
            //               controller.googlehomeswiped.value = true;
            //               // addToken(context);
            //               // Fluttertoast.showToast(
            //               //   msg: "In Development",
            //               //   toastLength: Toast.LENGTH_LONG,
            //               //   gravity: ToastGravity.BOTTOM,
            //               //   backgroundColor: AppTheme.appBlack,
            //               //   textColor: AppTheme.primaryColor,
            //               // );
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: height * 0.05,
            // ),
            Container(
              height: height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  // Corresponds to 89.7 degrees
                  end: Alignment(1.0, 0.0),
                  // End point for the gradient
                  colors: [
                    AppTheme.appgreen, // #119A8E color
                    AppTheme.fluorescentGreen, // #119A8E color
                    // #36EC7D color
                  ],
                  stops: [0.003, 0.998], // 0.3% and 99.8% stops
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: SizedBox(
                            height: height * 0.1,
                            width: width * 0.22,
                            // color: Colors.red,
                            child: Image.asset(
                              "assets/Images/philips.png",
                              fit: BoxFit
                                  .fill, // This makes the image fill the container
                            ),
                          ),
                        ),
                        const Text(
                          "Philips LED",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SwipeButton(
                        thumb: controller.lightSwiped.value
                            ? const Material(
                                elevation: 0,
                                color: Colors.transparent,
                                shadowColor: Colors.transparent,
                              )
                            : Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                child: const Icon(
                                  Icons.arrow_forward_sharp,
                                  color: Colors.white,
                                ),
                              ),
                        activeThumbColor: controller.lightSwiped.value
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.9),
                        activeTrackColor: controller.lightSwiped.value
                            ? Colors.black.withOpacity(0.9)
                            : AppTheme.liteGreen,
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() => Text(
                                  controller.bedmessage.value,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ))),
                        onSwipe: () async {
                          if (AppPreferences.instance.deviceListResponse ==
                              null) {
                            String url =
                                "https://api.meethue.com/v2/oauth2/authorize?client_id=${AppUtility.clientId}&response_type=code&state=ACTIVE";
                            if (!await launchUrl(Uri.parse(url))) {
                              throw Exception('Could not launch $url');
                            }
                          } else {
                            controller.getDeviceDetailsAlone();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  // Corresponds to 89.7 degrees
                  end: Alignment(1.0, 0.0),
                  // End point for the gradient
                  colors: [
                    AppTheme.appgreen, // #119A8E color
                    AppTheme.fluorescentGreen, // #119A8E color
                    // #36EC7D color
                  ],
                  stops: [0.003, 0.998], // 0.3% and 99.8% stops
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 20, top: 30),
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            // color: Colors.red,
                            child: Image.asset(
                              "assets/Images/spotify.png",
                              fit: BoxFit
                                  .fill, // This makes the image fill the container
                            ),
                          ),
                        ),
                        const Text(
                          "Spotify",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SwipeButton(
                          thumb: controller.lightSwiped.value
                              ? const Material(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                )
                              : Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                  child: const Icon(
                                    Icons.arrow_forward_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                          activeThumbColor: controller.lightSwiped.value
                              ? Colors.transparent
                              : Colors.black.withOpacity(0.9),
                          activeTrackColor: controller.lightSwiped.value
                              ? Colors.black.withOpacity(0.9)
                              : AppTheme.liteGreen,
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Obx(() => Text(
                                    controller.bedmessage.value,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        color: AppTheme.textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ))),
                          onSwipe: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SpotifyScreenView()))),
                    ),
                  ],
                ),
              ),
            ),
            /*SizedBox(
              height: height * 0.1,
            ),
            if (AppPreferences.instance.accessToken == null ||
                AppPreferences.instance.username == null ||
                AppPreferences.instance.deviceListResponse == null)
              AppTabMenu(
                margin: EdgeInsets.zero,
                title: "Configure Bridge",height: 50,
                // disable: !model.status,
                isSelected: true,
                onClick: () async {
                  String _url =
                      "https://api.meethue.com/v2/oauth2/authorize?client_id=${AppUtility.clientId}&response_type=code&state=ACTIVE";
                  if (!await launchUrl(Uri.parse(_url))) {
                    throw Exception('Could not launch $_url');
                  }
                },
              ),*/
            SizedBox(
              height: height * 0.03,
            ),
            Obx(() => (controller.fetchedAccessToken.value &&
                    controller.fetchedUserName.value &&
                    controller.fetchedDeviceList.value)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTabMenu(
                        margin: EdgeInsets.zero,
                        title: "TurnON Light",
                        height: 50,
                        // disable: !model.status,
                        isSelected: true,
                        color: controller.fetchedLightOn.value
                            ? Colors.grey
                            : null,
                        onClick: controller.fetchedLightOn.value
                            ? () {}
                            : () {
                                controller.toggleOnOffLight(true);
                              },
                      ),
                      AppTabMenu(
                        margin: EdgeInsets.zero,
                        title: "TurnOFF Light",
                        height: 50,
                        // disable: !model.status,
                        isSelected: true,
                        color: controller.fetchedLightOn.value
                            ? null
                            : Colors.grey,
                        onClick: controller.fetchedLightOn.value
                            ? () {
                                controller.toggleOnOffLight(false);
                              }
                            : () {},
                      ),
                    ],
                  )
                : Container()),
            SizedBox(
              height: height * 0.03,
            ),
            Obx(() => (controller.fetchedAccessToken.value &&
                    controller.fetchedUserName.value &&
                    controller.fetchedDeviceList.value &&
                    controller.fetchedLightOn.value)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTabMenu(
                        margin: EdgeInsets.zero,
                        title: "Theme 1",
                        height: 50,
                        style: const TextStyle(color: Colors.black),
                        // disable: !model.status,
                        isSelected: true,
                        color: const Color(0xFFFFE4B5),
                        onClick: () {
                          controller.changeColor(
                              "Theme 1", const Color(0xFFFFE4B5));
                        },
                      ),
                      AppTabMenu(
                        margin: EdgeInsets.zero,
                        title: "Theme 2",
                        height: 50,
                        style: const TextStyle(color: Colors.black),
                        // disable: !model.status,
                        isSelected: true,
                        color: const Color(0xFFFFC0CB),
                        onClick: () {
                          controller.changeColor(
                              "Theme 2", const Color(0xFFFFC0CB));
                        },
                      ),
                      AppTabMenu(
                        margin: EdgeInsets.zero,
                        title: "Theme 3",
                        height: 50,
                        style: const TextStyle(color: Colors.black),
                        color: const Color(0xFFB0C4DE),
                        // disable: !model.status,
                        isSelected: true,
                        onClick: () {
                          controller.changeColor(
                              "Theme 3", const Color(0xFFB0C4DE));
                        },
                      ),
                    ],
                  )
                : Container()),
            SizedBox(
              height: height * 0.1,
            ),
            Obx(() => controller.bedswiped.isTrue
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppTheme.borderShade1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/Images/datePicker.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: Obx(
                                      () => Text(
                                        controller
                                            .currentDateWithigsHeart.value,
                                        style: const TextStyle(
                                          color: AppTheme.appBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Get.bottomSheet(SingleChildScrollView(
                                  child: Container(
                                decoration: const BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 15,
                                          bottom: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(height: 20, width: 20),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: const Text("Select Date",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .secondaryColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: const Icon(Icons.clear))
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    SfDateRangePicker(
                                      view: DateRangePickerView.month,
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                      selectionShape:
                                          DateRangePickerSelectionShape
                                              .rectangle,
                                      backgroundColor: AppTheme.primaryColor,
                                      selectionTextStyle: const TextStyle(
                                          color: AppTheme.primaryColor),
                                      yearCellStyle:
                                          DateRangePickerYearCellStyle(
                                              cellDecoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4))),
                                      startRangeSelectionColor:
                                          AppTheme.secondaryColor,
                                      endRangeSelectionColor:
                                          AppTheme.secondaryColor,
                                      rangeTextStyle: const TextStyle(
                                        color: AppTheme.appBlack,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      headerStyle:
                                          const DateRangePickerHeaderStyle(
                                        textAlign: TextAlign.center,
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.labelColor90),
                                      ),
                                      selectionRadius: 0,
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        startDate = args.value.startDate;
                                        endDate = args.value.endDate;

                                        if (startDate != null) {
                                          controller.from_date_withings =
                                              "${startDate!.year}-${startDate!.month}-${startDate!.day}";
                                        }
                                        if (endDate != null) {
                                          controller.to_date_withings =
                                              "${endDate!.year}-${endDate!.month}-${endDate!.day}";
                                        }
                                        getDateRangeText();
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AppButton2(
                                          width: width * 0.45,
                                          height: 40,
                                          title: 'Cancel',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          onPressed: () {
                                            Get.back();
                                          },
                                          color: AppTheme.primaryColor,
                                          titleColor: AppTheme
                                              .bottomTabsLabelInActiveColor,
                                          borderColor: AppTheme.cancelBorder,
                                        ),
                                        AppButton2(
                                          width: width * 0.45,
                                          height: 40,
                                          title: 'Apply ',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          onPressed: () {
                                            controller.currentDateWithigsHeart
                                                    .value =
                                                "${DateFormat('dd-MM-yyyy').format(startDate!)}  -  ${DateFormat('dd-MM-yyyy').format(endDate!)}";

                                            controller.from_date_withings =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(startDate!);
                                            controller.to_date_withings =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(endDate!);
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (_) async {
                                              controller.withingSleep();
                                            });
                                            Get.back();
                                          },
                                          titleColor: AppTheme.primaryColor,
                                          color: AppTheme.secondaryColor,
                                          borderColor: AppTheme.secondaryColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              )));
                            },
                          ),
                          AppTabMenu(
                            margin: EdgeInsets.zero,
                            title: "Export",
                            // disable: !model.status,
                            isSelected: true,
                            onClick: () {
                              controller.createExcelWithings();
                            },
                          )
                        ],
                      ),
                      const Text(
                        "TRACK SLEEP CYCLE",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Container(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Tracksleepcyclegraph(
                            withingsSeriesData:
                                controller.withingsSleepBarChart),
                      )),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "SLEEP SCORE",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Sleepscoregraph(
                          withingsSeriesData: controller.withingsSeriesData),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "HEART RATE TRACKING",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Heartratetrackinggraph(
                          sleepExcelModel: controller.withingsSeriesData,
                          linesChart: controller.lineChartForWithingsHeart!)
                    ],
                  )
                : Container()),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.isTokenAvailable.isTrue
                  ? Column(
                      children: [
                        Visibility(
                          visible: true,
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Stress Chart",
                                    style: TextStyle(
                                        color: AppTheme.appBlack, fontSize: 24),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextInputField(
                                    controller:
                                        controller.pointsControllerSecond,
                                    height: 100,
                                    label: "Chart Points ",
                                    onPressed: () {
                                      controller.isPointsSecond.value =
                                          !controller.isPointsSecond.value;
                                    },
                                    textInputType: TextInputType.phone,
                                    textColor: AppTheme.selectPointTextColor,
                                    hintText: "Select Points",
                                    obscureText: true,
                                    isReadOnly: true,
                                    margin: false,
                                    onTextChange: (String) {},
                                  ),
                                  Obx(() => Visibility(
                                        visible:
                                            controller.isPointsSecond.value,
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              12, 4, 12, 0),
                                          padding: const EdgeInsets.fromLTRB(
                                              6, 4, 6, 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppTheme.inputBorderColor,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppTheme
                                                .primaryColor, // Set the desired background color
                                          ),
                                          child: IntrinsicHeight(
                                            child: Column(
                                              children: List.generate(
                                                controller.keySecond!.length,
                                                (index) {
                                                  var model = controller
                                                      .keySecond![index];
                                                  return Container(
                                                    child: Column(
                                                      children: [
                                                        TextInputField(
                                                          onPressed: () {
                                                            if (controller
                                                                .selectedPointsSecond
                                                                .value
                                                                .any((e) =>
                                                                    e
                                                                        .toString()
                                                                        .contains(
                                                                            "All") &&
                                                                    model !=
                                                                        "All")) {
                                                              int indexToRemove = controller
                                                                  .selectedPointsSecond
                                                                  .value
                                                                  .indexWhere((e) => e
                                                                      .toString()
                                                                      .contains(
                                                                          "All"));

                                                              if (indexToRemove !=
                                                                  -1) {
                                                                controller
                                                                    .selectedPointsSecond
                                                                    .value
                                                                    .removeAt(
                                                                        indexToRemove);
                                                              }
                                                            }

                                                            if (!controller
                                                                .selectedPointsSecond
                                                                .value
                                                                .any((e) => e
                                                                    .toString()
                                                                    .contains(
                                                                        model))) {
                                                              if (model ==
                                                                  "All") {
                                                                controller
                                                                    .selectedPointsSecond
                                                                    .clear();
                                                                for (String value
                                                                    in controller
                                                                        .keySecond!) {
                                                                  controller
                                                                      .selectedPointsSecond
                                                                      .value
                                                                      .add(
                                                                          value);
                                                                }
                                                              } else {
                                                                controller
                                                                    .selectedPointsSecond
                                                                    .value
                                                                    .add(model);
                                                              }
                                                            } else {
                                                              if (model ==
                                                                  "All") {
                                                                controller
                                                                    .selectedPointsSecond
                                                                    .clear();
                                                              } else {
                                                                int indexToRemove = controller
                                                                    .selectedPointsSecond
                                                                    .value
                                                                    .indexWhere((e) => e
                                                                        .toString()
                                                                        .contains(
                                                                            model));

                                                                if (indexToRemove !=
                                                                    -1) {
                                                                  controller
                                                                      .selectedPointsSecond
                                                                      .value
                                                                      .removeAt(
                                                                          indexToRemove);
                                                                }
                                                              }
                                                            }

                                                            controller
                                                                .pointsControllerSecond
                                                                .text = jsonEncode(
                                                                    controller
                                                                        .selectedPointsSecond
                                                                        .value)
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'[\[\]]'),
                                                                    '')
                                                                .replaceAll(
                                                                    "\"", '');

                                                            if (controller
                                                                    .keySecond!
                                                                    .length ==
                                                                1) {
                                                              controller
                                                                  .isPointsSecond
                                                                  .value = false;
                                                            } else {
                                                              controller
                                                                  .isPointsSecond
                                                                  .value = false;
                                                              controller
                                                                  .isPointsSecond
                                                                  .value = true;
                                                            }
                                                          },
                                                          margin: false,
                                                          isSelected: controller
                                                              .selectedPointsSecond
                                                              .value
                                                              .any((e) => e
                                                                  .toString()
                                                                  .contains(
                                                                      model)),
                                                          label: "",
                                                          dropDownWithCheckBox:
                                                              true,
                                                          isEntryField: false,
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                          textColor:
                                                              const Color(
                                                                  0xCC234345),
                                                          hintText: model,
                                                          obscureText: true,
                                                          onTextChange:
                                                              (String) {},
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        (controller.keySecond!
                                                                        .length -
                                                                    1) !=
                                                                index
                                                            ? Container(
                                                                height: 1,
                                                                color: AppTheme
                                                                    .divderColor,
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (controller
                                                                            .selectedPointsSecond
                                                                            .value
                                                                            .isEmpty) {
                                                                          Fluttertoast
                                                                              .showToast(
                                                                            msg:
                                                                                "Please Select the category",
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            gravity:
                                                                                ToastGravity.BOTTOM,
                                                                            backgroundColor:
                                                                                AppTheme.appBlack,
                                                                            textColor:
                                                                                AppTheme.primaryColor,
                                                                          );

                                                                          return;
                                                                        }

                                                                        controller
                                                                            .isPointsSecond
                                                                            .value = false;

                                                                        controller
                                                                            .generateCallSecond();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                7),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              35,
                                                                          // Reduced height
                                                                          width:
                                                                              35,
                                                                          // Reduced width
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              top: 20),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(100),
                                                                            color:
                                                                                AppTheme.appgreen,
                                                                          ),
                                                                          child:
                                                                              const Center(
                                                                            child:
                                                                                Icon(
                                                                              Icons.arrow_circle_right,
                                                                              color: AppTheme.primaryColor,
                                                                              size: 34, // Increased size
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                ],
                                                              )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.borderShade1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/Images/datePicker.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 4, 8, 4),
                                            child: Obx(
                                              () => Text(
                                                controller
                                                    .currentDateStress.value,
                                                style: const TextStyle(
                                                  color: AppTheme.appBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.bottomSheet(SingleChildScrollView(
                                          child: Container(
                                        decoration: const BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 15,
                                                  bottom: 7),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                      height: 20, width: 20),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          "Select Date",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .secondaryColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: const Icon(
                                                          Icons.clear))
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            SfDateRangePicker(
                                              view: DateRangePickerView.month,
                                              selectionMode:
                                                  DateRangePickerSelectionMode
                                                      .range,
                                              selectionShape:
                                                  DateRangePickerSelectionShape
                                                      .rectangle,
                                              backgroundColor:
                                                  AppTheme.primaryColor,
                                              selectionTextStyle:
                                                  const TextStyle(
                                                      color: AppTheme
                                                          .primaryColor),
                                              yearCellStyle:
                                                  DateRangePickerYearCellStyle(
                                                      cellDecoration:
                                                          BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4))),
                                              startRangeSelectionColor:
                                                  AppTheme.secondaryColor,
                                              endRangeSelectionColor:
                                                  AppTheme.secondaryColor,
                                              rangeTextStyle: const TextStyle(
                                                color: AppTheme.appBlack,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              headerStyle:
                                                  const DateRangePickerHeaderStyle(
                                                textAlign: TextAlign.center,
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppTheme.labelColor90),
                                              ),
                                              selectionRadius: 0,
                                              onSelectionChanged:
                                                  (DateRangePickerSelectionChangedArgs
                                                      args) {
                                                startDate =
                                                    args.value.startDate;
                                                endDate = args.value.endDate;

                                                if (startDate != null) {
                                                  controller.from_date_stress =
                                                      "${startDate!.year}-${startDate!.month}-${startDate!.day}";
                                                }
                                                if (endDate != null) {
                                                  controller.to_date_stress =
                                                      "${endDate!.year}-${endDate!.month}-${endDate!.day}";
                                                }
                                                getDateRangeText();
                                              },
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                AppButton2(
                                                  width: width * 0.45,
                                                  height: 40,
                                                  title: 'Cancel',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  color: AppTheme.primaryColor,
                                                  titleColor: AppTheme
                                                      .bottomTabsLabelInActiveColor,
                                                  borderColor:
                                                      AppTheme.cancelBorder,
                                                ),
                                                AppButton2(
                                                  width: width * 0.45,
                                                  height: 40,
                                                  title: 'Apply ',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  onPressed: () {
                                                    controller.currentDateStress
                                                            .value =
                                                        "${DateFormat('dd-MM-yyyy').format(startDate!)}  -  ${DateFormat('dd-MM-yyyy').format(endDate!)}";

                                                    controller
                                                            .from_date_stress =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(startDate!);
                                                    controller.to_date_stress =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(endDate!);
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) async {
                                                      controller.SecondCall();
                                                    });
                                                    Get.back();
                                                  },
                                                  titleColor:
                                                      AppTheme.primaryColor,
                                                  color:
                                                      AppTheme.secondaryColor,
                                                  borderColor:
                                                      AppTheme.secondaryColor,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      )));
                                    },
                                  ),
                                  AppTabMenu(
                                    margin: EdgeInsets.zero,
                                    title: "Export",
                                    // disable: !model.status,
                                    isSelected: true,
                                    onClick: () {
                                      controller.createExcelSecond();
                                    },
                                  )
                                ],
                              ),
                              Obx(() => controller.initialLoading.isFalse
                                  ? controller.stressData.isNotEmpty
                                      ? Container(
                                          child: StressLineGraph(
                                              StressList: controller.stressData,
                                              linesChart:
                                                  controller.lineChartSecond!))
                                      : SizedBox(
                                          height: height * 0 * 4,
                                          width: width,
                                          child: const Center(
                                            child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ))
                                  : SizedBox(
                                      height: height * 0 * 4,
                                      width: width,
                                      child: const Center(
                                        child: Text(
                                          "No data",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      )))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        const Row(
                          children: [
                            Text(
                              "Sleep Chart",
                              style: TextStyle(
                                  color: AppTheme.appBlack, fontSize: 24),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextInputField(
                              controller: controller.pointsController,
                              height: 100,
                              label: "Chart Points ",
                              onPressed: () {
                                controller.isPoints.value =
                                    !controller.isPoints.value;
                              },
                              textInputType: TextInputType.phone,
                              textColor: AppTheme.selectPointTextColor,
                              hintText: "Select Points",
                              obscureText: true,
                              isReadOnly: true,
                              margin: false,
                              onTextChange: (String) {},
                            ),
                            Obx(() => Visibility(
                                  visible: controller.isPoints.value,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(12, 4, 12, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 4, 6, 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.inputBorderColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppTheme
                                          .primaryColor, // Set the desired background color
                                    ),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        children: List.generate(
                                          controller.key!.length,
                                          (index) {
                                            var model = controller.key![index];
                                            return Container(
                                              child: Column(
                                                children: [
                                                  TextInputField(
                                                    onPressed: () {
                                                      if (controller
                                                          .selectedPoints.value
                                                          .any((e) =>
                                                              e
                                                                  .toString()
                                                                  .contains(
                                                                      "All") &&
                                                              model != "All")) {
                                                        int indexToRemove =
                                                            controller
                                                                .selectedPoints
                                                                .value
                                                                .indexWhere((e) => e
                                                                    .toString()
                                                                    .contains(
                                                                        "All"));

                                                        if (indexToRemove !=
                                                            -1) {
                                                          controller
                                                              .selectedPoints
                                                              .value
                                                              .removeAt(
                                                                  indexToRemove);
                                                        }
                                                      }

                                                      if (!controller
                                                          .selectedPoints.value
                                                          .any((e) => e
                                                              .toString()
                                                              .contains(
                                                                  model))) {
                                                        if (model == "All") {
                                                          controller
                                                              .selectedPoints
                                                              .clear();
                                                          for (String value
                                                              in controller
                                                                  .key!) {
                                                            controller
                                                                .selectedPoints
                                                                .value
                                                                .add(value);
                                                          }
                                                        } else {
                                                          controller
                                                              .selectedPoints
                                                              .value
                                                              .add(model);
                                                        }
                                                      } else {
                                                        if (model == "All") {
                                                          controller
                                                              .selectedPoints
                                                              .clear();
                                                        } else {
                                                          int indexToRemove = controller
                                                              .selectedPoints
                                                              .value
                                                              .indexWhere((e) => e
                                                                  .toString()
                                                                  .contains(
                                                                      model));

                                                          if (indexToRemove !=
                                                              -1) {
                                                            controller
                                                                .selectedPoints
                                                                .value
                                                                .removeAt(
                                                                    indexToRemove);
                                                          }
                                                        }
                                                      }

                                                      controller
                                                          .pointsController
                                                          .text = jsonEncode(
                                                              controller
                                                                  .selectedPoints
                                                                  .value)
                                                          .replaceAll(
                                                              RegExp(r'[\[\]]'),
                                                              '')
                                                          .replaceAll("\"", '');

                                                      if (controller
                                                              .key!.length ==
                                                          1) {
                                                        controller.isPoints
                                                            .value = false;
                                                      } else {
                                                        controller.isPoints
                                                            .value = false;
                                                        controller.isPoints
                                                            .value = true;
                                                      }
                                                    },
                                                    margin: false,
                                                    isSelected: controller
                                                        .selectedPoints.value
                                                        .any((e) => e
                                                            .toString()
                                                            .contains(model)),
                                                    label: "",
                                                    dropDownWithCheckBox: true,
                                                    isEntryField: false,
                                                    textInputType:
                                                        TextInputType.text,
                                                    textColor:
                                                        const Color(0xCC234345),
                                                    hintText: model,
                                                    obscureText: true,
                                                    onTextChange: (String) {},
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  (controller.key!.length -
                                                              1) !=
                                                          index
                                                      ? Container(
                                                          height: 1,
                                                          color: AppTheme
                                                              .divderColor,
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                if (controller
                                                                    .selectedPoints
                                                                    .value
                                                                    .isEmpty) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg:
                                                                        "Please Select the category",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .BOTTOM,
                                                                    backgroundColor:
                                                                        AppTheme
                                                                            .appBlack,
                                                                    textColor:
                                                                        AppTheme
                                                                            .primaryColor,
                                                                  );

                                                                  return;
                                                                }

                                                                controller
                                                                    .generateCall();
                                                                controller
                                                                        .isPoints
                                                                        .value =
                                                                    false;
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            7),
                                                                child:
                                                                    Container(
                                                                  height: 35,
                                                                  // Reduced height
                                                                  width: 35,
                                                                  // Reduced width
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              20),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    color: AppTheme
                                                                        .appgreen,
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_circle_right,
                                                                      color: AppTheme
                                                                          .primaryColor,
                                                                      size:
                                                                          34, // Increased size
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppTheme.borderShade1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/Images/datePicker.png",
                                      height: 20,
                                      width: 20,
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      child: Obx(
                                        () => Text(
                                          controller.currentDate.value,
                                          style: const TextStyle(
                                            color: AppTheme.appBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Get.bottomSheet(SingleChildScrollView(
                                    child: Container(
                                  decoration: const BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 7),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                                height: 20, width: 20),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: const Text("Select Date",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .secondaryColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: const Icon(Icons.clear))
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      SfDateRangePicker(
                                        view: DateRangePickerView.month,
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                        selectionShape:
                                            DateRangePickerSelectionShape
                                                .rectangle,
                                        backgroundColor: AppTheme.primaryColor,
                                        selectionTextStyle: const TextStyle(
                                            color: AppTheme.primaryColor),
                                        yearCellStyle:
                                            DateRangePickerYearCellStyle(
                                                cellDecoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4))),
                                        startRangeSelectionColor:
                                            AppTheme.secondaryColor,
                                        endRangeSelectionColor:
                                            AppTheme.secondaryColor,
                                        rangeTextStyle: const TextStyle(
                                          color: AppTheme.appBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        headerStyle:
                                            const DateRangePickerHeaderStyle(
                                          textAlign: TextAlign.center,
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.labelColor90),
                                        ),
                                        selectionRadius: 0,
                                        onSelectionChanged:
                                            (DateRangePickerSelectionChangedArgs
                                                args) {
                                          startDate = args.value.startDate;
                                          endDate = args.value.endDate;

                                          if (startDate != null) {
                                            controller.from_date =
                                                "${startDate!.year}-${startDate!.month}-${startDate!.day}";
                                          }
                                          if (endDate != null) {
                                            controller.to_date =
                                                "${endDate!.year}-${endDate!.month}-${endDate!.day}";
                                          }
                                          getDateRangeText();
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          AppButton2(
                                            width: width * 0.45,
                                            height: 40,
                                            title: 'Cancel',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            onPressed: () {
                                              Get.back();
                                            },
                                            color: AppTheme.primaryColor,
                                            titleColor: AppTheme
                                                .bottomTabsLabelInActiveColor,
                                            borderColor: AppTheme.cancelBorder,
                                          ),
                                          AppButton2(
                                            width: width * 0.45,
                                            height: 40,
                                            title: 'Apply ',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            onPressed: () {
                                              controller.currentDate.value =
                                                  "${DateFormat('dd-MM-yyyy').format(startDate!)}  -  ${DateFormat('dd-MM-yyyy').format(endDate!)}";

                                              controller.from_date =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(startDate!);
                                              controller.to_date =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(endDate!);
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (_) async {
                                                controller.firstCall();
                                              });
                                              Get.back();
                                            },
                                            titleColor: AppTheme.primaryColor,
                                            color: AppTheme.secondaryColor,
                                            borderColor:
                                                AppTheme.secondaryColor,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                )));
                              },
                            ),
                            AppTabMenu(
                              margin: EdgeInsets.zero,
                              title: "Export",
                              // disable: !model.status,
                              isSelected: true,
                              onClick: () {
                                controller.createExcelTry();
                              },
                            )
                          ],
                        ),
                        Obx(() => controller.initialLoading.isFalse
                            ? controller.sleepData!.isNotEmpty
                                ? Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          RotatedBox(
                                              quarterTurns: 3,
                                              child: Container(
                                                child: const Text(
                                                  "Ratio",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                          Sleeplinegraph(
                                              StressList: controller.sleepData!,
                                              linesChart:
                                                  controller.lineChart!),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: height * 0 * 4,
                                    width: width,
                                    child: const Center(
                                      child: Text(
                                        "No data",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      ),
                                    ))
                            : SizedBox(
                                height: height * 0 * 4,
                                width: width,
                                child: const Center(
                                  child: Text(
                                    "No data",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ))),
                        Visibility(
                          visible: true,
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Heart Rate Chart",
                                    style: TextStyle(
                                        color: AppTheme.appBlack, fontSize: 24),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          width: width * 0.6,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.borderShade1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/Images/datePicker.png",
                                                height: 20,
                                                width: 20,
                                              ),
                                              Container(
                                                width: width * 0.48,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 4, 8, 4),
                                                child: Obx(
                                                  () => Text(
                                                    controller
                                                        .currentDateHeartFromRate
                                                        .value,
                                                    style: const TextStyle(
                                                      color: AppTheme.appBlack,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () =>
                                            _selectDateTime(context, true),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          width: width * 0.6,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.borderShade1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/Images/datePicker.png",
                                                height: 20,
                                                width: 20,
                                              ),
                                              Container(
                                                width: width * 0.48,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 4, 8, 4),
                                                child: Obx(
                                                  () => Text(
                                                    controller
                                                        .currentDateHeartToRate
                                                        .value,
                                                    style: const TextStyle(
                                                      color: AppTheme.appBlack,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () =>
                                            _selectDateTime(context, false),
                                      ),
                                    ],
                                  ),
                                  AppTabMenu(
                                    margin: EdgeInsets.zero,
                                    title: "Export",
                                    // disable: !model.status,
                                    isSelected: true,
                                    onClick: () {
                                      if (controller.heartRateData.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Heart Rate Data is Empty",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: AppTheme.appBlack,
                                          textColor: AppTheme.primaryColor,
                                        );
                                        return;
                                      }
                                      controller.createExcelThird();
                                    },
                                  )
                                ],
                              ),
                              Obx(() => controller.initialLoading.isFalse
                                  ? controller.heartRateData.isNotEmpty
                                      ? Container(
                                          child: HeartRatelinegraph(
                                              HeartRateList:
                                                  controller.heartRateData,
                                              linesChart:
                                                  controller.lineChartThird!),
                                        )
                                      : SizedBox(
                                          height: height * 0 * 4,
                                          width: width,
                                          child: const Center(
                                            child: Text(
                                              "No data",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ))
                                  : SizedBox(
                                      height: height * 0 * 4,
                                      width: width,
                                      child: const Center(
                                        child: Text(
                                          "No data",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 75, right: 75),
                          child: AppTabMenu(
                            title: "SIGN OUT",
                            isSelected: true,
                            onClick: () {
                              controller.signOut();
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                      ],
                    )
                  : Container(),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => controller.googlehomeswiped.isTrue
                ? Column(
                    children: [
                      Container(
                          height: 100,
                          color: Colors.red,
                          child: Column(children: [
                            ElevatedButton(
                              onPressed: controller.authenticateWithGoogle,
                              child: const Text('Sign in with Google'),
                            ),
                            ElevatedButton(
                              onPressed: () => controller.sendAssistantCommand(
                                  'Play my Spotify playlist'),
                              child: const Text('Play Playlist on Google Home'),
                            ),
                          ])),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  )
                : Container())
          ]),
        ),
      )),
    );
  }

  static Future addToken(
    BuildContext context,
  ) {
    HomeScreenController controller = Get.put(HomeScreenController());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    controller.bedswiped.value = false;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Add Token",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textColor),
                      ),
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.ringswiped.value = false;
                          Get.back();
                        },
                        icon: const Icon(Icons.cancel))
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 7, right: 0),
              content: SizedBox(
                width: width * 0.12,
                child: TextInput(
                  controller: controller.TokenBedController,
                  margin: true,
                  height: 80,
                  label: "",
                  onTextChange: (text) {},
                  textInputType: TextInputType.text,
                  textColor: AppTheme.selectPointTextColor,
                  hintText: "Enter Token",
                  isReadOnly: false,
                  obscureText: false,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (controller.TokenBedController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please Add the Token",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );
                          return;
                        }
                        AppPreference().updateRingToken(
                            controller.TokenBedController.text.trim());
                        ApiUrl.ringToken =
                            "Bearer ${controller.TokenBedController.text.trim()}";
                        controller.tokenAdded();

                        Get.back();
                      },
                      child: Container(
                        height: 30,
                        // Reduced height
                        width: 30,
                        // Reduced width
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppTheme.appgreen,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_circle_right,
                            color: AppTheme.primaryColor,
                            size: 28, // Increased size
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  Future<void> _selectDateTime(BuildContext context, bool isFrom) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary:
                  Colors.black, // Set the text color of the buttons to black
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary:
                    Colors.black, // Set the text color of the buttons to black
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate);
        String formattedTime = DateFormat("HH:mm:ss").format(selectedDate);
        String timeZoneOffset = '-12:00';

        String formattedDateTime =
            "${formattedDate}T$formattedTime$timeZoneOffset";

        if (isFrom) {
          DateTime? toDate =
              _parseDateTime(controller.currentDateHeartToRate.value);
          if (toDate != null && selectedDate.isAfter(toDate)) {
            _showErrorDialog(context, 'Start date cannot be after end date.');
          } else {
            controller.currentDateHeartFromRate.value = formattedDateTime;
          }
        } else {
          DateTime? fromDate =
              _parseDateTime(controller.currentDateHeartFromRate.value);
          if (fromDate != null && selectedDate.isBefore(fromDate)) {
            _showErrorDialog(context, 'End date cannot be before start date.');
          } else {
            controller.currentDateHeartToRate.value = formattedDateTime;
            controller.HeartRateCall();
          }
        }
      }
    }
  }

  DateTime? _parseDateTime(String dateTimeStr) {
    try {
      return DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(dateTimeStr, true);
    } catch (e) {
      return null;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Invalid Date Selection',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          content: Text(message,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  /*URILink
  * */

  listenLink(HomeScreenController controller) {
    deepLinkStream = uriLinkStream.listen(
      (Uri? uri) async {
        if (uri == null) return;

        final int start = uri.toString().indexOf("?");
        String queryParams = uri.toString().substring(start);
        Uri truncatedUri = Uri.parse(queryParams);

        try {
          final String? pkce = truncatedUri.queryParameters[ApiFields.pkce];
          final String? code = truncatedUri.queryParameters[ApiFields.code];
          final String? resState =
              truncatedUri.queryParameters[ApiFields.state];

          // Handle Flutter Hue deep link
          if (pkce != null && code != null && resState != null) {
            String stateSecret;
            if (resState.contains("-")) {
              stateSecret = resState.substring(0, resState.indexOf("-"));
            } else {
              stateSecret = resState;
            }

            controller.getCloudToken(code, pkce);
          }
        } catch (_) {}
      },
    );
  }
}

// void _showBottomSheetDateAndTime(
//   BuildContext context,
//     RxString selectedDate, RxString finalValue
//     ) {
//   DateTime focusDay = DateTime.now();
//   DateTime? selectedDay = focusDay;
//   selectedDate.value = formatDate(selectedDay!, [yyyy, '-', mm, '-', dd]);
//   // dateformat.value = formatDate(selectedDay, [dd, '.', M, '.', yyyy]);
//   double width = MediaQuery.of(context).size.width;
//   double height = MediaQuery.of(context).size.height;
//
//   Get.bottomSheet(SingleChildScrollView(
//       child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(16.0),
//             topRight: Radius.circular(16.0),
//           ),
//           child: Container(
//               color: Colors.white,
//               child: Column(children: [
//                 Container(
//                   height: 350,
//                   child: DateRangeExample(
//                       selectedDate: selectedDate,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     AppButton2(
//                       width: width * 0.45,
//                       height: 40,
//                       title: 'Cancel',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       onPressed: () {
//                         Get.back();
//                       },
//                       color: Colors.white,
//                       titleColor: AppTheme.bottomTabsLabelInActiveColor,
//                       borderColor: AppTheme.cancelBorder,
//                     ),
//                     AppButton2(
//                       width: width * 0.45,
//                       height: 40,
//                       title: 'Apply ',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       onPressed: () {
//                         String timeZoneOffset = '-12:00';
//
//                         String fromFormattedDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(selectedDate.value));
//
//                         selectedDate.value = "${fromFormattedDate}T";
//
//                         String toFormattedDate = DateFormat("yyyy-MM-dd").format(endDate!);
//                         String toFormattedTime = DateFormat("HH:mm:ss").format(endDate!);
//                         controller.to_date_heartrate = "${toFormattedDate}T$toFormattedTime$timeZoneOffset";
//
//                         // Format for display
//                         String formattedFromDate = formatDate(startDate!, [
//                           dd,
//                           '-',
//                           mm,
//                           '-',
//                           yyyy
//                         ]);
//
//                         String formattedFromTime = DateFormat.jm().format(startDate!);
//                         String formattedToDate =
//                         formatDate(endDate!, [
//                           dd,
//                           '-',
//                           mm,
//                           '-',
//                           yyyy
//                         ]);
//                         String formattedToTime = DateFormat.jm().format(DateTime.now());
//
//                         // Set the controller currentDateHeartRate value
//                         controller
//                             .currentDateHeartFromRate
//                             .value =
//                         "$formattedFromDate $formattedFromTime";
//                         controller
//                             .currentDateHeartFromRate
//                             .value =
//                         "$formattedToDate $formattedToTime";
//
//                         WidgetsBinding.instance
//                             .addPostFrameCallback(
//                                 (_) async {
//                               controller.HeartRateCall();
//                             });
//
//                         Get.back();
//                       },
//                       titleColor: Colors.white,
//                       color: AppTheme.secondaryColor,
//                       borderColor: AppTheme.secondaryColor,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//               ])))));
// }
//
// _showbottomTimePicker(BuildContext context,
//     RxString finalDate, RxString selectedDate) {
//   var times;
//   double width = MediaQuery.of(context).size.width;
//   double height = MediaQuery.of(context).size.height;
//
//   showModalBottomSheet(
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(16.0),
//         topRight: Radius.circular(16.0),
//       ),
//     ),
//     isScrollControlled: true,
//     context: context,
//     builder: (BuildContext context) {
//       return Builder(
//         builder: (BuildContext context) {
//           return Container(
//             height: 280,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 10, right: 10, top: 15, bottom: 7),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(height: 20, width: 20),
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: const Text("Select Time",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: AppTheme.secondaryColor,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold)),
//                         ),
//                       ),
//                       GestureDetector(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: Icon(Icons.clear))
//                     ],
//                   ),
//                 ),
//                 Divider(),
//                 Expanded(
//                   child: TimePickerSpinner(
//                     is24HourMode: false,
//                     spacing: 30,
//                     itemHeight: 37,
//                     itemWidth: 60,
//                     isForce2Digits: true,
//                     onTimeChange: (time) {
//                       times = time;
//                     },
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     AppButton2(
//                       width: width * 0.45,
//                       height: 40,
//                       title: 'Cancel',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       onPressed: () {
//                         Get.back();
//                       },
//                       color: Colors.white,
//                       titleColor: AppTheme.bottomTabsLabelInActiveColor,
//                       borderColor: AppTheme.cancelBorder,
//                     ),
//                     AppButton2(
//                       width: width * 0.45,
//                       height: 40,
//                       title: 'Done ',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       onPressed: () {
//                         dateformat.value =
//                             "${selectedDate.value} ${formatDate(times, [
//                               HH,
//                               ':',
//                               nn,
//                               ':',
//                               ss
//                             ])}";
//
//                         Navigator.of(context).pop();
//                       },
//                       titleColor: Colors.white,
//                       color: AppTheme.secondaryColor,
//                       borderColor: AppTheme.secondaryColor,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
