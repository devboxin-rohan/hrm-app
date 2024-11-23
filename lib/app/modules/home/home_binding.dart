// modules/home/home_binding.dart
import 'package:get/get.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PunchController());
    Get.lazyPut(() => AuthController());
  }
}
