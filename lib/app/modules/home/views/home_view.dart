import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.barTexrOut)),
        centerTitle: true,
      ),
      body: Obx(
        () => buildPage(
          controller.pageControllerOut,
        ),
      ),
      bottomNavigationBar: Obx(
        () => SafeArea(child: buildNavBar()),
      ),
    );
  }

  Widget buildNavBar() {
    return BottomNavyBar(
      selectedIndex: controller.pageControllerOut,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.bluetooth),
          title: Text('Bluetooth'),
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.nfc),
          title: Text('NFC'),
        ),
      ],
      onItemSelected: (page) => controller.changePage(page),
    );
  }

  Widget buildPage(int page) {
    switch (page) {
      case 0:
        return buildBluetoothPage();
      case 1:
        return buildNFCPage();
    }
    return Center(
      child: Text(
        'HomeView is working',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildBluetoothPage() {
    return Column(
      children: [
        Text("Dispositivos bluetooth próximos"),
        Expanded(
          child: ListView(
            children: controller.listBluetoothDevicesOut
                .map(
                  (device) => ListTile(
                    title: Text(device.id),
                    subtitle: Text(device.name),
                    onTap: () => controller.connectToDevice(device),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  Widget buildNFCPage() {
    return Column(
      children: [
        Text("Dispositivos NFC próximos"),
        Expanded(
          child: ListView(
            children: controller.listNFCDevicesOut
                .map(
                  (tag) => ListTile(
                    title: Text(tag.toString()),
                    onTap: () => controller.writeNFC(tag.data['id']),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
