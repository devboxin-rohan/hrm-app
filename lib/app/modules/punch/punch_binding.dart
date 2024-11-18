// modules/home/home_binding.dart
import 'package:get/get.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';

class PunchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PunchController());
    Get.lazyPut(()=>HomeController());
  }
}
