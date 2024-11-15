import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/service/auth.dart';
import 'package:hrm_app/main.dart';
import 'package:get/get.dart';
// import 'package:shree_shivam/Screens/Welcome/welcome.dart';
// import 'package:shree_shivam/Services/auth.dart';
// import 'package:shree_shivam/Services/localStorage.dart';
// import 'package:shree_shivam/main.dart';

intializeToken(token) {
  SharedData().setToken(token);
  saveCurrentTokenTime();
}

removeToken(context) {
  SharedData().setToken("");
  Get.toNamed("/auth");
  // Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => MyWelcomePage()),
  //     ModalRoute.withName("welcome"));
}

RefreshToken(context) {
  UserService().RefreshToken().then((value) {
    if (value.data["success"] == true) {
      SharedData().setToken(value.data["data"]["refresh_token"]);
      saveCurrentTokenTime();
      // Navigator.pushNamed(context, 'dashboard');
    } else {
      removeToken(navigatorKey.currentState?.context);
    }
  }).onError((error, trace) {
      removeToken(navigatorKey.currentState?.context);
  });
}

// Save the current time in local storage
Future<void> saveCurrentTokenTime() async {
  final currentTime = DateTime.now().millisecondsSinceEpoch;
  SharedData().setTokenTime(currentTime);
  print('Time saved: $currentTime');
}

// Check if 1 hour has passed
Future<bool> isOneHourPassed() async {
  final savedTime = await SharedData().getTokenTime();

  if (savedTime == 0) return false;

  final currentTime = DateTime.now().millisecondsSinceEpoch;
  final timeDifference = currentTime - savedTime;

  // Check if more than 1 hour (3600 seconds) has passed
  return timeDifference > 3600 * 1000;
}

// Check time and trigger function
Future<void> checkTimeAndTriggerFunction(context) async {
  bool oneHourPassed = await isOneHourPassed();

  if (oneHourPassed) {
    print('More than 1 hour has passed. Triggering the function.');
     RefreshToken(context);
  } else {
    print('Less than 1 hour has passed.');
  }
}


