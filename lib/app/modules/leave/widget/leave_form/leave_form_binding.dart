import 'package:get/get.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'leave_form_controller.dart';

class LeaveFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaveFormController());
    Get.lazyPut(()=> HomeController());
    Get.lazyPut(() => PunchController());
    Get.lazyPut(() => AuthController());
  }
}
