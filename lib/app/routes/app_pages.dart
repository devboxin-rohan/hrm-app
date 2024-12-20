import 'package:get/get.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/modules/auth/auth_binding.dart';
import 'package:hrm_app/app/modules/auth/auth_page.dart';
import 'package:hrm_app/app/modules/auth/widgets/welcome_page.dart';
import 'package:hrm_app/app/modules/home/home_page.dart';
import 'package:hrm_app/app/modules/leave/leave_binding.dart';
import 'package:hrm_app/app/modules/leave/leave_page.dart';
import 'package:hrm_app/app/modules/leave/widget/leave_form/leave_form_binding.dart';
import 'package:hrm_app/app/modules/leave/widget/leave_form/leave_form_page.dart';
import 'package:hrm_app/app/modules/punch/punch_binding.dart';
import 'package:hrm_app/app/modules/punch/punch_page.dart';
import 'package:hrm_app/app/modules/punch_list/punch_list_binding.dart';
import 'package:hrm_app/app/modules/punch_list/punch_list_page.dart';
import 'package:hrm_app/app/modules/splash/splash.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';

class AppPages {
  static const initial = '/splash';

  static final routes = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
    ),
    GetPage(
      name: '/auth',
      page: () => const MyWelcomePage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/punch',
      page: () => PunchPage(),
      binding: PunchBinding(),
    ),
    GetPage(
      name: '/leave',
      page: () => LeavePage(),
      binding: LeaveBinding(),
    ),
    GetPage(
      name:'/leave-form',
      page: ()=>LeaveFormPage(),
      binding: LeaveFormBinding()
    ),
     GetPage(
      name:'/punch-screen',
      page: ()=>PunchListScreen(),
      binding: PunchListBinding()
    )
  ];
}
