// import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hrm_app/app/service/auth.dart';
import 'package:hrm_app/app/service/index.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'dart:io';
// import 'package:signal_strength/signal_strength.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


Future<bool> CheckInternet() async {
  
  bool result = await InternetConnection().hasInternetAccess;
  Logging().LoggerPrint("Internet Access - " + result.toString());


  if (result)
    return true;
  else
    return false;
}

Future<bool> CheckServer(context) async {
  try {
    var response = await UserService().ServerCheck();
    Logging().LoggerPrint(response.toString());
    if (response.statusCode == 200 && response.data["success"] == true) {
      return true;
    } else {
      AlertNotification.error("Connection issue", "Server is not responding, please check");
      return false;
    }
  } on Failure catch (e) {
    AlertNotification.error("Connection issue", "Server is not responding, please check");
    // AlertMessage()
    //       .Error(context, "${e.message}", 2000);

    return false;
  } catch (e) {
    // Handle any other type of error
    print('Unexpected error other: $e');
    return false;
  }
}
