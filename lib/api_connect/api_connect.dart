import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../ModelResponse/HeartRateResponse.dart';
import '../ModelResponse/StressResponse.dart';
import '../ModelResponse/SleepResponse.dart';
import '../ModelResponse/UploadResponse.dart';
import '../ModelResponse/WithingsSleepResponseData.dart';
import '../ModelResponse/device_list_response.dart';
import '../ModelResponse/ewallet_error.dart';
import '../ModelResponse/token_response.dart';
import '../UI/strings.dart';
import '../Utilis/AppUtility.dart';
import '../Utilis/app_preference.dart';
import '../Utilis/validation_utils.dart';
import '../api_config/ApiUrl.dart';
import '../routes/app_routes.dart';
import '../shared_preferences/app_preferences.dart';

class ApiConnect extends GetConnect {
  @override
  onInit() async {
    super.allowAutoSignedCert = true;
    super.onInit();

    // setUpLogs();
    httpClient.addResponseModifier((request, response) {
      debugPrint("------------ AUTH ------------");
      debugPrint(
          "REQUEST METHOD: ${request.method} ; ENDPOINT:  ${request.url}");
      debugPrint("RESPONSE : ${response.bodyString}");
      // writeCounter(
      //     " METHOD: ${request.method} ; ENDPOINT:  ${request.url} \n RESPONSE : Timing: ${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second} \n ${response.bodyString}");
      // // FlutterLogs.logInfo(_tag, "AutoLogs", "REQUEST METHOD: ${request.method} ; ENDPOINT:  ${request.url} \n RESPONSE : ${response.bodyString}");
      return response;
    });
  }

  Future<File> get _localFile async {
    final path = await getDownloadPath();
    // String timeStamp = "AutoRevogLog${DateTime.now()}.txt";
    String timeStamp = "Oura.txt";
    print("StorePath$path/$timeStamp");

    bool doesFileExists = await File('$path/$timeStamp').exists();
    if (!doesFileExists) {
      await File('$path/$timeStamp').create();
    }
    return File('$path/$timeStamp');
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<File> writeCounter(String s) async {
    final file = await _localFile;
    print("Printed$s");

    // Write the file
    return await file.writeAsString('$s\n', mode: FileMode.append);
  }

  Future<SleepResponse> getSleepData(String Url) async {
    Map<String, String> header = {
      'Authorization': ApiUrl.ringToken,
    };
    var response = await get(Url, headers: header);
    if (response.body == null) {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    if (response.statusCode! >= 400 && response.statusCode! >= 500) {
      AppPreference().clearData();
      Get.offAllNamed(AppRoutes.HomeScreen.toName);
    }
    return SleepResponse.fromJson(response.body);
  }

  Future<StressResponse> getStressData(String Url) async {
    Map<String, String> header = {
      'Authorization': ApiUrl.ringToken,
    };
    var response = await get(Url, headers: header);
    if (response.body == null) {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    if (response.statusCode! >= 400 && response.statusCode! >= 500) {
      AppPreference().clearData();
      Get.offAllNamed(AppRoutes.HomeScreen.toName);
    }
    return StressResponse.fromJson(response.body);
  }

  Future<WithingsSleepResponseData> getWithingsSleep(
      Map<String, dynamic> payload) async {
    Map<String, String> header = {
      'Authorization': Strings.authToken,
    };

    var response = await post(
      ApiUrl.withingsBaseUrl + ApiUrl.withingsSleep,
      FormData(payload),
      headers: header,
    );
    if (response.body == null) {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    if (response.statusCode! >= 400 && response.statusCode! >= 500) {
      AppPreference().clearData();
      Get.offAllNamed(AppRoutes.HomeScreen.toName);
    }
    return WithingsSleepResponseData.fromJson(response.body);
  }

  Future<HeartRateResponse> getHeartRateData(String Url) async {
    Map<String, String> header = {
      'Authorization': ApiUrl.ringToken,
    };
    var response = await get(Url, headers: header);
    if (response.body == null) {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    if (response.statusCode! > 400 && response.statusCode! > 500) {
      AppPreference().clearData();
      Get.offAllNamed(AppRoutes.HomeScreen.toName);
    }
    return HeartRateResponse.fromJson(response.body);
  }

  Future<UploadResponse> imgUpload(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://beautysleep.nashiinfo.com/api/upload_file"));
    var imageStream = http.ByteStream(imageFile.openRead());
    var imageLength = await imageFile.length();
    var multipartFile = http.MultipartFile(
        'excelFile', imageStream, imageLength,
        filename: imageFile.path.split('/').last);

    debugPrint("multipartFile : $multipartFile");

    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    var responseBody = await response.stream.bytesToString();
    debugPrint("responseBody : $responseBody");

    Map<String, dynamic> parsedResponse;

    try {
      parsedResponse = json.decode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      return UploadResponse();
    }

    var convertedResponse = UploadResponse.fromJson(parsedResponse);
    return convertedResponse;
  }

  ///*** PHILIPS HUE Bridge Device Configuration APIs ***/
  Future<dynamic> getConfig(String url) async {
    Map<String, String> header = addConfigHeaders();
    var response = await http.put(Uri.parse(url),
        headers: header, body: jsonEncode({"linkbutton": true}));
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      return jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    return ErrorResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getUsername(String url) async {
    Map<String, String> header = addConfigHeaders();
    var response = await http.post(Uri.parse(url),
        headers: header, body: jsonEncode({"devicetype": "BeautySleep"}));
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      return jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    return ErrorResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getDevice(String url) async {
    Map<String, String> header = addConfigHeaders();
    var response = await http.get(
      Uri.parse(url),
      headers: header,
    );
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      return DeviceListResponse.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    return ErrorResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getDeviceDetails(String url) async {
    Map<String, String> header = addConfigHeaders();
    var response = await http.get(
      Uri.parse(url),
      headers: header,
    );
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      return jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    return ErrorResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getToken(String url,
      {required String clientSecret,
      required String clientId,
      required Map body}) async {
    String credentials = "$clientId:$clientSecret";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);

    Map<String, String> header = {
      "Authorization": "Basic $encoded",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(Uri.parse(url), headers: header, body: body);
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      return TokenResponse.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    return ErrorResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> getOnOffToggle(String url, {bool on = false}) async {
    Map<String, String> header =  addConfigHeaders();
    var response = await http.put(Uri.parse(url), headers: header, body: jsonEncode({
      "on": {"on": on}
    }));
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      return jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    return ErrorResponse.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> changeColor(String url, {Map? body}) async {
    Map<String, String> header =  addConfigHeaders();
    var response = await http.put(Uri.parse(url), headers: header, body: jsonEncode(body));
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      return response.body;
    } else {
      Fluttertoast.showToast(
        msg: AppUtility.somethingWrong,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    return ErrorResponse.fromJson(jsonDecode(response.body));
  }

  addConfigHeaders() {
    var headers = <String, String>{};
    headers["Content-Type"] = 'application/json';
    if (AppPreferences.instance.accessToken != null &&
        AppPreferences.instance.accessToken!.isNotEmpty) {
      headers["Authorization"] =
          'Bearer ${AppPreferences.instance.accessToken!}';
    }
    if (AppPreferences.instance.username != null &&
        AppPreferences.instance.username!.isNotEmpty) {
      headers["hue-application-key"] = AppPreferences.instance.username!;
    }
    return headers;
  }
}
