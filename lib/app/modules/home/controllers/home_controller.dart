import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class HomeController extends GetxController {
  final FlutterReactiveBle flutterReactiveBle;
  final Location location;
  HomeController({
    required this.flutterReactiveBle,
    required this.location,
  });
  var _page = 0.obs;
  var _barText = 'Bluetooth'.obs;
  var _listBluetoothDevices = <DiscoveredDevice>[].obs;

  int get pageControllerOut => _page.value;
  List get listBluetoothDevicesOut => _listBluetoothDevices.toList();
  String get barTexrOut => _barText.value;

  @override
  void onInit() async {
    await getLocation();
    scanBluetoothDevices();
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

  Future<void> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void scanBluetoothDevices() {
    flutterReactiveBle.scanForDevices(
        scanMode: ScanMode.lowLatency,
        withServices: []).listen((discoveredDevice) {
      var _hasDevice = false;
      _listBluetoothDevices.forEach((device) {
        if (device.id == discoveredDevice.id) {
          _hasDevice = true;
        }
      });
      if (!_hasDevice) {
        _listBluetoothDevices.add(discoveredDevice);
      }
    }, onError: (error) {
      print(error);
    });
  }

  void connectToDevice(String id) {
    flutterReactiveBle.connectToDevice(
      id: id,
      connectionTimeout: Duration(seconds: 5),
    );
  }
}
