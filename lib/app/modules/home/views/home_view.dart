import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavyBar(
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
              icon: Icon(Icons.bluetooth),
              title: Text('NFC'),
            ),
          ],
          onItemSelected: (page) => controller.changePage(page),
        ),
      ),
    );
  }
}
