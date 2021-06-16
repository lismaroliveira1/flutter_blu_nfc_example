import 'package:get/get.dart';

class HomeController extends GetxController {
  var _page = 0.obs;

  int get pageControllerOut => _page.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void changePage(int page) {
    _page.value = page;
  }
}
