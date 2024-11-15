import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'package:hrm_app/app/service/attendance.dart';
import 'package:hrm_app/app/service/index.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:hrm_app/main.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';

class BackgroundWorkDispatcher {

  static Future SubmitPunchData() async {
   
    // bool hasInternet = await CheckInternet();
    // if (hasInternet) {
      print("Internet is available.");
      final PunchController punchController = Get.find<PunchController>();

      var unsyncedPunches = punchController.punchList
          .where((punch) => punch.isSync == false)
          .toList();

      // print(unsyncedPunches);

      for (var punch in unsyncedPunches) {
        File image = File(punch.imagePath!);
        String fileName = basename(image.path);
        punch.isLoading = true;
        punchController.updatePunch(punch.id!, punch);

        try {
          var payload = dio.FormData.fromMap({
            'longitude': punch.longitude,
            'latitude': punch.latitude,
            'image_file': await dio.MultipartFile.fromFile(
              image.path,
              filename: fileName,
            ),
          });

          var response = await AttendanceService().SubmitPunchIn(payload);

          if (response.data["success"] == true) {
            punch.isLoading = false;
            punch.isSync = true;
            punchController.updatePunch(punch.id!, punch);
            // AlertMessage().Success(context, response.data["reason"], 2000);
          } else {
            punch.isLoading = false;
            punch.error=response.data["reason"];
            punchController.updatePunch(punch.id!, punch);
            AlertNotification.error( "Punch failed" , response.data["reason"]);
            // Navigator.pop(context);
          }

          Logging().LoggerPrint(response.toString());
        } catch (error) {
          Logging().LoggerPrint(error.toString());
          final failure = ErrorHandler.handle(error);
          Logging().LoggerPrint(failure.message);
          punch.isLoading = false;
          punch.error="Contact to admin";
          punchController.updatePunch(punch.id!, punch);
          return false;
        }
      }

      return true;
    // } else {
    //   BuildContext? context = navigatorKey.currentState?.context;

    //   AlertMessage().Error(context, "No internet available", 2000);
    //   // await _showNotification("Background Task", "No internet connection.");
    //   return false;
    // }
  }
}
