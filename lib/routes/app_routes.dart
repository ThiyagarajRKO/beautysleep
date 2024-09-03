enum AppRoutes {
  root,
  HomeScreen,
}

extension AppRouteExtension on AppRoutes {
  static const appRoutes = {
    AppRoutes.root: "/",
    AppRoutes.HomeScreen: "/HomeScreen",

  };

  String get toName => appRoutes[this]!;
}

enum ApiRoutes {
  login,
}

extension ApiRouteExtension on ApiRoutes {
  static const apiRoutes = {
    ApiRoutes.login: "",
  };

  String get toName => apiRoutes[this]!;
}
