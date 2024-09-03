class ApiUrl {
  static const bool isProductionUrl = false;
  static const String appVersion = "3.3";
  static const int maxAuthRetry = 3;
  static String ringToken = "";

  static const String baseUrl = isProductionUrl
      ? "https://api.ouraring.com/v2/usercollection/"
      : "https://api.ouraring.com/v2/usercollection/";

  static const String withingsBaseUrl = isProductionUrl
      ? "https://wbsapi.withings.net/v2/"
      : "https://wbsapi.withings.net/v2/";

  static String getSleepData = "daily_sleep?start_date=";
  static String getStressData = "daily_stress?start_date=";
  static String getHeartRateData = "heartrate?start_datetime=";

  /*Withings Product*/
  static String withingsSleep = "sleep";

  ///  Bridge PHILIPS HUE
  ///  //https://api.meethue.com/route/api
  static const String bridgeBaseUrl = "https://api.meethue.com/route";
  static const String config = "/api/0/config";
  static const String getTokenURL = "https://api.meethue.com/v2/oauth2/token";
  static const String getDevice = "/clip/v2/resource/device";
  static const String onOffToggle = "/clip/v2/resource/light/";
  static const String username = "/api";

  static const String spotifyEngineURL =
      "https://actions.mithragopikrishnan.info/api/v1";
}
