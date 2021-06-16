import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlutterReactiveBle());
    Get.lazyPut(() => Location());

    Get.lazyPut<HomeController>(
      () => HomeController(
        flutterReactiveBle: Get.find(),
        location: Get.find(),
      ),
    );
  }
}
