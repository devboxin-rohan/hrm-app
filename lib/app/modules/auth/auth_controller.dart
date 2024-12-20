import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:hrm_app/app/data/local/hive_database.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/data/models/user_model.dart';
import 'package:hrm_app/app/service/attendance.dart';
import 'package:hrm_app/app/service/auth.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:hive/hive.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  var username = ''.obs;
  var password = ''.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;

  final UserService _userService = UserService();

  Future<void> login(email,password) async {
    isLoading.value = true;
    final credentials = {
      'email': email,
      'password': password,
    };

    try {
      dio.Response response = await _userService.SubmitCredential(credentials);
      Logging().LoggerPrint(response.toString());

      if( response.data["success"]==true){
        var userData = response.data["data"]["user"];
        var token = response.data["data"]["token"];
        print(userData);
        userData["token"]=token;
        SharedData().setToken(token);
        await saveUserData(userData);
        await handleDahboardData();
        isLoggedIn.value = true;
        Get.offAllNamed('/home');
        AlertNotification.success("Success", "Login Successful");
      }else{
          AlertNotification.error("Login Failed",response.data["reason"]);
      }
    } catch (e) {
      Logging().LoggerPrint(e.toString());
      print(e.toString());
      AlertNotification.error("Login Failed","Please check credentials");
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> saveUserData(Map<String, dynamic> userData) async {
    Logging().LoggerPrint(userData.toString());
    final user = UserModel.fromJson(userData);  // Create UserModel from JSON
    // if (rememberMe.value) {
      var box = await Hive.box<UserModel>(HiveDatabase.userBoxName);
      await box.put('user', user);  // Save the user model
    // }
  }

  Future handleDahboardData() async {
    try {
      dio.Response dashboardResponse =
          await AttendanceService().getAttandanceDetail();
      SharedData().setDashboardDetail(dashboardResponse.data);
    } catch (e) {
      Logging().LoggerPrint(e.toString());
    } finally {
      return;
    }
  }

   Future<UserModel?> getUserData() async {
    var box = await Hive.box<UserModel>(HiveDatabase.userBoxName);
    return box.get('user');  // Retrieve the user model
  }


  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/auth'); // Navigate back to AuthPage on logout
  }
}


// // auth_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'user_service.dart';

// class AuthController extends GetxController {
//   var username = ''.obs;
//   var password = ''.obs;
//   var rememberMe = false.obs;
//   var isLoading = false.obs;

//   final UserService _userService = UserService();

//   Future<void> login() async {
//     isLoading.value = true;
//     final credentials = {
//       'username': username.value,
//       'password': password.value,
//     };

//     try {
//       final response = await _userService.SubmitCredential(credentials);
//       if (response.statusCode == 200) {
//         var userData = response.data;
//         await saveUserData(userData);  // Save to Hive if login is successful
//         Get.snackbar("Success", "Login Successful");
//       } else {
//         Get.snackbar("Error", "Login Failed: ${response.data['message']}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "An error occurred while logging in");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> saveUserData(Map<String, dynamic> userData) async {
//     if (rememberMe.value) {
//       var box = await Hive.openBox('userBox');
//       await box.put('userData', userData);
//       await box.put('token', userData['token']);
//     }
//   }
// }



