import 'package:get/get.dart';

class HomeController extends GetxController {
  var _page = 0.obs;
  var _barText = 'Bluetooth'.obs;

  int get pageControllerOut => _page.value;
  String get barTexrOut => _barText.value;

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
    switch (page) {
      case 0:
        _barText.value = 'Bluetooth';
        break;
      case 1:
        _barText.value = 'NFC';
        break;
      case 2:
        _barText.value = 'Setup';
        break;
    }
    _page.value = page;
  }
}
