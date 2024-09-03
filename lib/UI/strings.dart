class Strings {
  // App name
  static const String appName = "Withings";

  // Route names
  static const String homeScreenRouteName = '/home';
  static const String withingsSettingsScreenRouteName = '/home/fitbitSettings';

  // Screen names
  static const String homeScreenName = "Withings_flutter Example";
  static const String withingsSettingsScreenName = "Fitbit Account";

  // Fitbit Client ID
  static const String withingsClientID =
      '5862e0342417d1fd612ce4ba299d8615a4920a0221883505135d349016d31bbe'; //put here your withingsClientID

  // Fitbit Client Secret
  static const String withingsClientSecret =
      '9764ffc55c0755dc974bca035ddf8d44d49199a8c4dbd29c3086a6d63f0f1784'; //put here your withingsClientSecret
  // const callbackUrlScheme = 'tark';

  /// Auth Uri
  static const String withingsRedirectUri =
      '$withingsCallbackScheme://callback'; //put here your withingsRedirectUri

  /// Callback scheme
  static const String withingsCallbackScheme =
      'tark'; //put here your withingsCallbackScheme

  /// Callback scheme
  static String authToken =
      ''; //put here your withingsCallbackScheme

  // Placeholders
  static const String hello = "Hello, World!";
}
