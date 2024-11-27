import 'package:get/get.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'leave_controller.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaveController());
    Get.lazyPut(()=> HomeController());
    Get.lazyPut(() => PunchController());
    Get.lazyPut(() => AuthController());
  }
}
