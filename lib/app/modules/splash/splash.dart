import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/utils/RefreshToken.dart';
import 'package:hrm_app/main.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    _checkToken();
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _checkToken() async {
    String token = await SharedData().getToken();
    checkTimeAndTriggerFunction(navigatorKey.currentState!.context);
    if (token.isNotEmpty) {
      Get.offNamed('/home'); // Navigate to Home if token exists
    } else {
      Get.offNamed('/auth'); // Navigate to Auth if token does not exist
    }
  }
}
