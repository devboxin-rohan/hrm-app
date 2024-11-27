// modules/home/home_controller.dart
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hive/hive.dart';
import 'package:hrm_app/app/data/local/hive_database.dart';
import 'package:hrm_app/app/data/models/user_model.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/service/face.dart';
import 'package:hrm_app/app/service/leave.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';

class LeaveFormController extends GetxController {
  SubmitLeave(data) async {
    try {
      var response = await LeaveServices().ApplyLeave(data);
      if (response.data["success"] == true) {
        Get.offAndToNamed("/leave");
        AlertNotification.success("Leave submitted !", response.data["reason"]);
      } else {
        AlertNotification.error(
            "Leave submission failed !", response.data["reason"]);
        // Navigator.pop(context);
      }

      Logging().LoggerPrint(response.toString());
    } catch (e) {
      Logging().LoggerPrint(e.toString());
      AlertNotification.error(
          "Leave submission failed !", "Please try again after sometime or contact to admin.");
    }
  }
}
