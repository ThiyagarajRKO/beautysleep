import 'package:get/get.dart';

import '../Binding/HomeScreenBinding.dart';
import '../UI/HomeScreen.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
        name: AppRoutes.root.toName,
        page: () => HomeScreen(),
        binding: HomeScreenBinding()),
  ];
}
