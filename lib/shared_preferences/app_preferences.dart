import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../ModelResponse/device_list_response.dart';

class AppPreferences {
  static final instance = AppPreferences._();

  AppPreferences._();

  static const _langKey = "_lang_key";
  static const _themeKey = "_theme_key";
  static const _loggedInStatus = "logged_in_status";
  static const _accessTokenKey = "_accessTokenKey";
  static const _refreshTokenKey = "_refreshTokenKey";
  static const _usernameKey = "_usernameKey";
  static const _baseUrlKey = "_baseUrlKey";
  static const _deviceListKey = "_deviceListKey";

  String? _lang;
  String? _theme;
  String? _accessToken;
  String? _refreshToken;
  String? _baseUrl;
  String? _username;
  DeviceListResponse? _deviceListResponse;
  bool? _loggedIn;

  bool? get loggedIn => _loggedIn;

  String? get lang => _lang;

  String? get theme => _theme;

  String? get username => _username;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  String? get baseUrl => _baseUrl;

  DeviceListResponse? get deviceListResponse => _deviceListResponse;

  init() async {
    _lang = await AppPreferences.getLang();
    _theme = await AppPreferences.getTheme();

    _accessToken = await AppPreferences.getAccessToken();
    _refreshToken = await AppPreferences.getRefreshToken();
    _username = await AppPreferences.getUsername();
    if (_loggedIn ?? false) {
      _deviceListResponse = await AppPreferences.getDeviceList();
    }
    _loggedIn = await AppPreferences.getLoggedInStatus() ?? false;
  }

  static Future<String?> getLang() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? latLong = localStorage.getString(_langKey);
    return latLong;
  }

  static Future<void> setLang(String lang) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_langKey, lang);
    await instance.init();
  }

  static Future<String?> getBaseUrl() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? url = localStorage.getString(_baseUrlKey);
    return url;
  }

  static Future<void> setBaseUrl(String baseUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_baseUrlKey, baseUrl);
    await instance.init();
  }

  static Future<String?> getTheme() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? latLong = localStorage.getString(_themeKey);
    return latLong;
  }

  static Future<void> setTheme(String lang) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_themeKey, lang);
    await instance.init();
  }

  static Future<String> getAccessToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? latLong = localStorage.getString(_accessTokenKey);
    return latLong ?? "";
  }

  static Future<void> setAccessToken(String accessToken) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_accessTokenKey, accessToken);
    await AppPreferences.instance.init();
  }

  static Future<String> getRefreshToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? latLong = localStorage.getString(_refreshTokenKey);
    return latLong ?? "";
  }

  static Future<void> setRefreshToken(String refreshtoken) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_refreshTokenKey, refreshtoken);
    await AppPreferences.instance.init();
  }

  static Future<String> getUsername() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? latLong = localStorage.getString(_usernameKey);
    return latLong ?? "";
  }

  static Future<void> setUsername(String username) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(_usernameKey, username);
    await AppPreferences.instance.init();
  }

  static Future<bool?> getLoggedInStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool? latLong = localStorage.getBool(_loggedInStatus);
    return latLong ?? false;
  }

  static Future<void> setLoggedInStatus(bool latLong) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setBool(_loggedInStatus, latLong);
    await AppPreferences.instance.init();
  }

  static Future<void> logoutClearPreferences() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove(_loggedInStatus);
    await localStorage.remove(_accessTokenKey);
    await AppPreferences.instance.init();
  }

  static Future<void> setDeviceList(DeviceListResponse latLong) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String user = jsonEncode(latLong);
    localStorage.setString(_deviceListKey, user);
    await AppPreferences.instance.init();
  }

  static Future<DeviceListResponse?> getDeviceList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.getString(_deviceListKey) != null ||
        localStorage.getString(_deviceListKey)!.isNotEmpty) {
      Map<String, dynamic> userMap =
          jsonDecode(localStorage.getString(_deviceListKey)!);
      return DeviceListResponse.fromJson(userMap);
    } else {
      return null;
    }
  }
}
