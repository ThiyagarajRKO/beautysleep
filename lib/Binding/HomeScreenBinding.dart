import 'package:get/get.dart';
import '../Controller/HomeController.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreenController>(
            () => HomeScreenController());
  }
}
