import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/data/models/punch_model.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'package:hrm_app/app/service/attendance.dart';
import 'package:hrm_app/app/service/index.dart';
import 'package:hrm_app/app/utils/CheckInternet.dart';
import 'package:hrm_app/app/utils/TimeFormat.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:hrm_app/main.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BackgroundWorkDispatcher {

  static Future SubmitPunchData() async {

    bool? isInternet = await CheckInternet();
    
    if (isInternet) {
      bool? isServer = await CheckServer(context);
      if (isServer) {
        print("Internet is available.");
        final PunchController punchController = Get.find<PunchController>();

        var unsyncedPunches = punchController.punchList
            .where((punch) => punch.isSync == false)
            .toList();

        // print(unsyncedPunches);
        var device_code = await SharedData().getDeviceId();
        PackageInfo packageInfo=await PackageInfo.fromPlatform();
        String version = packageInfo.version;

        for (PunchModel punch in unsyncedPunches) {
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
              'app_version':version,
              'mobile_login_code': device_code,
              'date': punch.dateTime!.substring(0, 10),
              'time': punch.dateTime!.substring(11, 16),
              'is_punchin': punch.isPunchin == true ? 0 : 1
            });

            Logging().LoggerPrint(payload.fields.toString());

            var response = await AttendanceService().SubmitPunchIn(payload);

            if (response.data["success"] == true) {
              punch.isLoading = false;
              punch.isSync = true;
              punch.error = null;
              punchController.updatePunch(punch.id!, punch);
              // AlertMessage().Success(context, response.data["reason"], 2000);
            } else {
              punch.isLoading = false;
              punch.error = response.data["reason"];
              punchController.updatePunch(punch.id!, punch);
              AlertNotification.error("Punch failed", response.data["reason"]);
              // Navigator.pop(context);
            }

            Logging().LoggerPrint(response.toString());
          } catch (error) {
            Logging().LoggerPrint(error.toString());
            final failure = ErrorHandler.handle(error);
            Logging().LoggerPrint(failure.message);
            punch.isLoading = false;
            punch.error = "Contact to admin";
            punchController.updatePunch(punch.id!, punch);
            // return false;
          }
        }
      }
    } else {
      AlertNotification.error(
          "Internet Issue", "Please check your internet connection");
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
