import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phillips_hue/Utilis/theme.dart';

enum MsgEnum {
  COMMON_LOADING,
}

class AppUtility {
  static String serverError = 'Server Error, Try again later';
  static String noDataFound = 'No Data Found';
  static String offlineMessage = 'Your device goes offline';
  static String connectivityMessage =
      'Check your internet connection and try again';
  static String offlineDataMessage =
      'Data Saved Locally, it will be uploaded once your device back online';
  static String onlineMessage = 'Your device back online';
  static String evaluationConfirmationMessage =
      'This lead is not yet confirmed for Evaluation process.';
  static String evaluationCheckMessage =
      'Complete Basic Info section to proceed.';
  static String somethingWrong = 'Something went wrong.';
  static String clientId = "q4CAKIJxURqJaeUsJQynWXPIvGeUhREf";
  static String clientSecret = "41tAbjc54BnobsAP";

  // Spotify
  static String spotifyClientId = "9ea07392acd74661bf93a9ab1d381e6b";
  static String spotifyClientSecret = "6dd4c639bc904716a30e7430643588b3";
  static String spotifyAuthURL = "https://accounts.spotify.com/authorize";
  static String spotifyTokenURL = "https://accounts.spotify.com/api/token";
  static String spotifyRedirectURL =
      "https://actions.mithragopikrishnan.info/oauth-callback";

  Future<bool> connectionChecker() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      Fluttertoast.showToast(
        msg: AppUtility.connectivityMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    } else {
      return true;
    }
  }

  static Future loader(
    BuildContext context,
    MsgEnum enumData,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String msg = "";
    String path = "";

    RxBool isDelayed = RxBool(false);

    path = "assets/Images/logo.png";
    msg = "Loading....";

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(const Duration(seconds: 5), () {
            isDelayed.value = true;
          });

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => isDelayed.value
                      ? Row(
                          children: [
                            Material(
                              type: MaterialType.transparency,
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    iconSize: 18,
                                    color: Colors.white,
                                    onPressed: () {
                                      Get.back();
                                    }),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
                Center(
                  child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 15),
                                child: ImageIcon(
                                  AssetImage(
                                    path,
                                  ),
                                  size: 40,
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(10),
                                backgroundColor: AppTheme.labelColor50,
                                valueColor: const AlwaysStoppedAnimation(
                                    AppTheme.secondaryColor),
                                minHeight: 5,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                msg,
                                style: TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 12,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Container(),
              ],
            ),
          );
        });
  }
}
