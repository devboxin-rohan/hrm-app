import 'package:get/get.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/modules/home/home_page.dart';
import 'package:hrm_app/app/modules/punch/punch_binding.dart';
import 'package:hrm_app/app/modules/punch/punch_page.dart';
import 'package:hrm_app/app/modules/punch_list/punch_list_binding.dart';
import 'package:hrm_app/app/modules/punch_list/punch_list_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';

class AppPages {

  static const initial = '/home';
  
  //  static Future<String> getToken() async {
  //  String token =await  SharedData().getToken();
  //  return token;
  //  }

    // return StorageService.isAuthenticated() ? '/home' : '/auth';

  static final routes = [
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
      name:'/punch-screen',
      page: ()=>PunchListScreen(),
      binding: PunchListBinding()
    )
  ];
}
