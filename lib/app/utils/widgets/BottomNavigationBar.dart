import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/main.dart';

Widget buildBottomNavigationBar() {
  HomeController homeController = Get.find<HomeController>();
  return BottomNavigationBar(
    backgroundColor: AppColors.white,
    currentIndex: homeController.bottomNavigationBarIndex.value,
    onTap: (index) {

      homeController.bottomNavigationBarIndex.value = index;

      // Navigate based on index
      switch (index) {
        case 0:
          Get.toNamed("/home");
          break;
        case 1:
          Get.toNamed("/leave");
          break;  
        case 2:
          removeToken(navigatorKey.currentState!.context);
          Get.toNamed("/auth");
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.access_time),
        label: "Clock",
        backgroundColor: Colors.white,
      ),
       BottomNavigationBarItem(
        icon: Icon(Icons.upgrade_outlined),
        label: "Leave",
        backgroundColor: Colors.white,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.logout),
        label: "Logout",
        backgroundColor: Colors.white,
      ),
    ],
  );
}
