// modules/home/home_controller.dart
import 'package:get/get.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hrm_app/app/service/face.dart';
import 'package:hrm_app/app/utils/logging.dart';
 
class HomeController extends GetxController {
  var todayHours = '00:00 Hrs'.obs;
  var monthHours = '00:00 Hrs'.obs;
  var timesheet = <Map<String, String>>[].obs; // Holds timesheet data
  var isLoading = false.obs;
  var isFaceExist = false.obs;

  fetchDetails() async {
    AuthController controller = Get.find<AuthController>();
    var response = await controller.getUserData();
    print(response!.empId);
    checkFaceExist(response!.empId);
    return response;
  }

  checkFaceExist(id) async {
    try {
      isLoading.value = true;
      dio.Response response = await FaceService().IsFaceExist(id);
      print(response.data);
      if (response.data["exists"] == true) {
          isFaceExist.value = true;
      } else {
          isFaceExist.value = false;
      }
    } catch (error, stack) {
      Logging().LoggerPrint(stack.toString());
    } finally {
        isLoading.value = false;
    }
  }


  void clockIn() {
    Get.toNamed('/punch');
    // Handle clock-in functionality
    todayHours.value = "08:00 Hrs";
    monthHours.value = "40:00 Hrs";
    timesheet.add({
      'date': '12 Nov 2024',
      'duration': '8:10 Hrs',
      'inOut': '10:05 Am --- 8:10 Pm',
    });
  }
}
