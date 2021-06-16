import 'dart:async';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
  var _listNFCDevices = <NfcTag>[].obs;
  var _isNFCAvailable = false.obs;

  int get pageControllerOut => _page.value;
  List get listBluetoothDevicesOut => _listBluetoothDevices.toList();
  List get listNFCDevicesOut => _listNFCDevices.toList();
  String get barTexrOut => _barText.value;

  @override
  void onInit() async {
    await getLocation();
    scanBluetoothDevices();
    checkNFC();
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
    flutterReactiveBle.initialize();
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

  void connectToDevice(DiscoveredDevice device) {
    EasyLoading.show(status: 'Aguardando resposta do dispositivo...');
    try {
      flutterReactiveBle
          .connectToAdvertisingDevice(
        id: device.id,
        connectionTimeout: Duration(seconds: 1),
        prescanDuration: const Duration(seconds: 5),
        withServices: device.serviceUuids,
      )
          .listen(
        (connectionState) async {
          switch (connectionState.connectionState) {
            case DeviceConnectionState.connecting:
              EasyLoading.show(status: 'Estabelecendo connexão');
              break;
            case DeviceConnectionState.connected:
              EasyLoading.dismiss();
              EasyLoading.showSuccess('Conectado!');
              await Flushbar(
                title: 'Conexão estabelecida',
                message: "Dispositivo connectado com sucesso",
                duration: Duration(seconds: 3),
              ).show(Get.context!);
              break;
            case DeviceConnectionState.disconnecting:
              EasyLoading.show(status: 'Desconectando...');
              break;
            case DeviceConnectionState.disconnected:
              EasyLoading.dismiss();
              await Flushbar(
                title: 'Não conectado',
                message:
                    "Não é possivel estabelecer connexão com este dispositivo",
                duration: Duration(seconds: 3),
              ).show(Get.context!);
              break;
          }
        },
        onError: (dynamic error) async {
          EasyLoading.dismiss();
          print(error);
          await Flushbar(
            title: 'Não conectado',
            message: "Nao houve resposta do dispositivo",
            duration: Duration(seconds: 3),
          ).show(Get.context!);
        },
      );
    } catch (err) {}
  }

  void writeBluetooth(DiscoveredDevice device) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: device.serviceUuids.first,
        characteristicId: device.serviceUuids.first,
        deviceId: device.id);
    await flutterReactiveBle.writeCharacteristicWithResponse(
      characteristic,
      value: [0x00],
    );
  }

  void tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      _listNFCDevices.add(tag);
    }).asStream();
  }

  Future<void> checkNFC() async {
    _isNFCAvailable.value = await NfcManager.instance.isAvailable();
    if (_isNFCAvailable.value) {
      tagRead();
    }
  }

  Future<void> writeNFC(NfcTag tag) async {
    final ndef = Ndef.from(tag);
    final message = NdefMessage([
      NdefRecord.createText('Hello World!'),
      NdefRecord.createUri(Uri.parse('https://flutter.dev')),
      NdefRecord.createMime(
          'text/plain', Uint8List.fromList('Hello'.codeUnits)),
      NdefRecord.createExternal(
          'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
    ]);
    try {
      await ndef!.write(message);
      NfcManager.instance.stopSession();
    } catch (e) {
      NfcManager.instance.stopSession(errorMessage: "error");
      print(e);
      return;
    }
  }
}
