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
          activeColor: Colors.brown,
          inactiveColor: Colors.blueGrey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.nfc),
          title: Text('NFC'),
          activeColor: Colors.brown,
          inactiveColor: Colors.blueGrey,
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Dispositivos bluetooth próximos",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: controller.listBluetoothDevicesOut
                .map(
                  (device) => ListTile(
                    leading: Icon(Icons.bluetooth),
                    title: Text(
                      device.id,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      device.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
        Text(
          "Dispositivos NFC próximos",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: ListView(
            children: controller.listNFCDevicesOut
                .map(
                  (tag) => ListTile(
                    leading: Icon(Icons.nfc),
                    title: Text(
                      tag.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => controller.writeNFC(
                      tag.data['id'],
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
