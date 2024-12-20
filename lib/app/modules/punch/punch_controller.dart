// modules/home/home_controller.dart
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:hrm_app/app/data/local/hive_database.dart';
import 'package:hrm_app/app/data/models/punch_model.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/service/face.dart';
import 'package:hrm_app/app/utils/GetCurrentLocation.dart';
import 'package:hrm_app/app/utils/GetPersistentFIlePath.dart';
import 'package:hrm_app/app/utils/PunchAsyncData.dart';
import 'package:hrm_app/app/utils/logging.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

class PunchController extends GetxController {
  var todayHours = '00:00 Hrs'.obs;
  var monthHours = '00:00 Hrs'.obs;
  var timesheet = <Map<String, String>>[].obs; // Holds timesheet data

  var isProcessing = false.obs;
  var faceFound = false.obs;
  var isLoading = false.obs;

  // Offline punch data save
  var punchList = <PunchModel>[].obs;
  late Box<PunchModel> punchBox;
  var displayCount = 5.obs;
  var expandedCardIndex = (-1).obs;
  var isAdding = false.obs;
  Rxn<Timer> timer = Rxn<Timer>();

  @override
  void onInit() {
    super.onInit();
    loadPunchData();
  }

  void loadPunchData() async {
    punchBox = Hive.box<PunchModel>(HiveDatabase.punchBoxName);
    AuthController controller = Get.find<AuthController>();
    HomeController homeController = Get.find<HomeController>();
    var response = await controller.getUserData();
    punchList.assignAll(punchBox.values
        .where((punch) => homeController.isManualAllowed.value ? punch.user_id == response!.empId:true)
        .toList()
      ..sort((a, b) => b.dateTime!.compareTo(a.dateTime!)));
  }

  void addPunch(PunchModel punch) async {
    isAdding.value = true; // Set loading state to true

    // Add punch to Hive box
    punchBox.put(punch.id, punch);

    // Add punch to the top of the list
    punchList.insert(0, punch);

    isAdding.value = false; // Set loading state to false
    // await BackgroundWorkDispatcher.SubmitPunchData();
  }

  void updatePunch(String id, PunchModel updatedPunch) {
    punchBox.put(id, updatedPunch);
    int index = punchList.indexWhere((p) => p.id == id);
    if (index != -1) {
      punchList[index] = updatedPunch;
    }
  }

  void deletePunch(String id) {
    punchBox.delete(id);
    punchList.removeWhere((p) => p.id == id);
  }

  void clearAllPunches() {
    punchBox.clear();
    punchList.clear();
  }

  // Function to increase display count
  void showMore() {
    displayCount.value += 5;
  }

  // Function to decrease display count
  void showLess() {
    if (displayCount.value > 5) {
      displayCount.value -= 5;
    }
  }

  void clockIn() {
    // Handle clock-in functionality
    // todayHours.value = "08:00 Hrs";
    // monthHours.value = "40:00 Hrs";
    // timesheet.add({
    //   'date': '12 Nov 2024',
    //   'duration': '8:10 Hrs',
    //   'inOut': '10:05 Am --- 8:10 Pm',
    // });
  }

  Future Register(String path) async {
    if (!isProcessing.value) {
      isProcessing.value = true;

      try {
        // Capture an image from the camera
        File image = File(path);
        AuthController controller = Get.find<AuthController>();
        var response = await controller.getUserData();
        String fileName = image.path.split('/').last;

        dio.MultipartFile file =
            await dio.MultipartFile.fromFile(image.path, filename: fileName);

        // Prepare form data with image file and user information
        dio.FormData formData = dio.FormData.fromMap({
          "emp_id": response!.empId,
          "emp_image": file,
          "userName": response.name,
        });

        // Print form data fields for debugging
        print("Form Data Fields: ${formData.fields}");

        try {
          // Send the form datas
          dio.Response res = await FaceService().RegisterFace(formData);
          if (res.data["success"] == true) {
            AlertNotification.success(res.data["message"], "");
            Get.toNamed("/home");
          } else
            AlertNotification.error("Failed !", res.data["message"]);
        } catch (error) {
          Logging().LoggerPrint(error.toString());
          print("Error during face registration: $error");
          AlertNotification.error(
              "Registration Failed", "Unable to register face");
          Get.toNamed("/home");
        }
      } catch (e) {
        Logging().LoggerPrint(e.toString());
        print("Exception: $e");
      } finally {
        isProcessing.value = false;
      }
    }
  }

  void runRecognize(String path, bool isPunchin) {
    timer.value = Timer.periodic(
        Duration(seconds: 2), (Timer t) => Recognize(path, isPunchin));
  }

  Future Recognize(String path, bool isPunchin) async {
    if (!isProcessing.value) {
      isProcessing.value = true;

      try {
        // Capture an image from the camera
        File image = File(path);
        AuthController controller = Get.find<AuthController>();
        var response = await controller.getUserData();
        String fileName = image.path.split('/').last;

        dio.MultipartFile file =
            await dio.MultipartFile.fromFile(image.path, filename: fileName);

        dio.FormData formData = dio.FormData.fromMap({
          "emp_id": response!.empId,
          "face_encoding": file,
        });

        try {
          dio.Response response = await FaceService().RecognizeIdFace(formData);
          if (response.data["success"] == true) {
            AlertNotification.success(
                "Face found successfully", response.data["message"]);
            faceFound.value = true;
            isLoading.value = true;
            bool isPunched = await punchData(path, isPunchin);
            if (isPunched) {
              isLoading.value = false;
              Get.toNamed("/home");
            }
            isLoading.value = false;
            // timer.value!.cancel();
          } else {
            AlertNotification.error("Failed !", response.data["message"]);
            faceFound.value = false;
          }
        } catch (e) {
          AlertNotification.error("Failed !", "Face not recognized");
          Logging().LoggerPrint(e.toString());
          faceFound.value = false;
        }
      } catch (e) {
        Logging().LoggerPrint(e.toString());
        AlertNotification.error("Unable to recognize", "Please retry");
      } finally {
        isProcessing.value = false;
      }
    }
  }

  Future RecognizeByAll(String path, bool isPunchin) async {
    if (!isProcessing.value) {
      isProcessing.value = true;

      try {
        // Capture an image from the camera
        File image = File(path);
        AuthController controller = Get.find<AuthController>();
        var response = await controller.getUserData();
        String fileName = image.path.split('/').last;

        dio.MultipartFile file =
            await dio.MultipartFile.fromFile(image.path, filename: fileName);

        dio.FormData formData = dio.FormData.fromMap({
          "face_encoding": file,
        });

        try {
          dio.Response response =
              await FaceService().RecognizeByAllFace(formData);
          if (response.data["success"] == true) {
            AlertNotification.success(
                "Face found successfully",
                response.data["data"]["message"] +
                    " " +
                    response.data["data"]["employee_name"]);
            faceFound.value = true;
            isLoading.value = true;
            await punchData(path, isPunchin,response.data["data"]["emp_id"]);
            await Future.delayed(Duration(seconds: 1));
            isLoading.value = false;
          } else {
            AlertNotification.error(
                "Failed !", response.data["data"]["message"]);
            faceFound.value = false;
          }
        } catch (e) {
          AlertNotification.error("Failed !", "Face not recognized");
          Logging().LoggerPrint(e.toString());
          faceFound.value = false;
        }
      } catch (e) {
        Logging().LoggerPrint(e.toString());
        AlertNotification.error("Unable to recognize", "Please retry");
      } finally {
        isProcessing.value = false;
      }
    }
  }

  Future<bool> punchData(String imagePath, bool isPunchin, [int? id]) async {
    try {
      final DateTime now = DateTime.now();
      String timeNDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      HomeController homeController = Get.find<HomeController>();
      Position? position;
      if (homeController.isManualAllowed.value) {
        position = await GetLatLong();
      }
      AuthController controller = Get.find<AuthController>();
      var response = await controller.getUserData();
      String fixPath = await saveFileToPersistentStorage(File(imagePath));
      var appType = homeController.isManualAllowed.value ? "Manual" : "lens";

      final punch = PunchModel.create(
          imagePath: fixPath,
          latitude: position?.latitude,
          longitude: position?.longitude,
          dateTime: timeNDate,
          isSync: false,
          user_id: id ?? response!.empId,
          isPunchin: isPunchin,
          app_type: appType);

      addPunch(punch);
      // AlertNotification.success(
      //     "Punched successfully", "Your attendace is save locally ");
      return true;
      // print(punchList);s
    } catch (e) {
      Logging().LoggerPrint(e.toString());
      AlertNotification.error("Unable to punch", "Please contact to admin");
      return false;
    }
  }

  void toggleCardExpansion(int index) {
    if (expandedCardIndex.value == index) {
      expandedCardIndex.value = -1; // Collapse if it's already expanded
    } else {
      expandedCardIndex.value = index;
    }
  }

  Future<bool> captureAndPunch(String path, bool isPunchin) async {
    if (!isProcessing.value) {
      isProcessing.value = true;

      try {
        // Capture an image from the camera
        File image = File(path);
        isLoading.value = true;
        // Capture an image from the camera

        // Process punch data
        bool isPunched = await punchData(path, isPunchin,0);
        if (isPunched) {
          Get.toNamed("/home");
        }
        return true;
      } catch (e) {
        Logging().LoggerPrint(e.toString());
        AlertNotification.error("Failed!", "Cannot punch in. Report to admin ");
        return false;
      } finally {
        isLoading.value = false;
        isProcessing.value = false;
        return true;
      }
    } else {
      return false;
    }
  }
}
