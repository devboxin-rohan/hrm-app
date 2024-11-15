import 'package:get/get.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/modules/punch/punch_binding.dart';
import 'package:hrm_app/app/modules/punch/punch_page.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';

class AppPages {
  static const initial = '/auth';
  
   static Future<String> getToken() async {
   String token =await  SharedData().getToken();
   return token;
   }

    static String get initialRoute {
       String value = getToken();
        if(value.length>0)
        return '/auth';
       else 
       return '/home';
    }
    // return StorageService.isAuthenticated() ? '/home' : '/auth';
  }

  static final routes = [
    GetPage(
      name: '/auth',
      page: () => LoginScreen(),
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
  ];
}
