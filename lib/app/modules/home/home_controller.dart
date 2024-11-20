// modules/home/home_controller.dart
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/service/face.dart';
import 'package:hrm_app/app/utils/logging.dart';
 
class HomeController extends GetxController {
 // Holds timesheet data
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
      if (response.data["success"] == true) {
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
  }
}
