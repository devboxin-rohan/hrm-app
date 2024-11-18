// modules/home/home_controller.dart
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hrm_app/app/service/face.dart';
import 'package:hrm_app/app/utils/logging.dart';
 
class HomeController extends GetxController {
 // Holds timesheet data
  var isLoading = false.obs;


  void clockIn() {
    Get.toNamed('/punch');
  }
}
