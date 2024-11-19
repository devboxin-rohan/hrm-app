// modules/home/home_controller.dart
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:hrm_app/app/data/models/punch_model.dart';
import 'package:hrm_app/app/service/face.dart';
import 'package:hrm_app/app/utils/GetCurrentLocation.dart';
import 'package:hrm_app/app/utils/PunchAsyncData.dart';
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
  punchBox = await Hive.box<PunchModel>('punchBox');
  // Load data in reverse order to show the newest punches at the top
  punchList.assignAll(punchBox.values.toList()
      ..sort((a, b) => b.dateTime!.compareTo(a.dateTime!)));
}

void addPunch(PunchModel punch) {
  isAdding.value = true; // Set loading state to true

  // Add punch to Hive box
  punchBox.put(punch.id, punch);

  // Add punch to the top of the list
  punchList.insert(0, punch);

  isAdding.value = false; // Set loading state to false
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



  Future<bool> punchData(XFile imageFile,bool isPunchin) async {
    try {
      final DateTime now = DateTime.now();
      String timeNDate = DateFormat('yyyy/MM/dd hh:mm a').format(now);

      Position? position = await GetLatLong();
      // AuthController controller = Get.find<AuthController>();
      // var response = await controller.getUserData();
      final punch = PunchModel.create(
        imagePath: imageFile!.path,
        latitude: position!.latitude,
        longitude: position!.longitude,
        dateTime: timeNDate,
        isSync: false,
        isPunchin: isPunchin
      );

      addPunch(punch);
      AlertNotification.success(
          "Punched successfully", "Your attendace is save locally ");
      return true;
      // print(punchList);
    } catch (e) {
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

 Future<bool> captureAndPunch(CameraController cameraController,bool isPunchin) async {
  if (cameraController.value.isInitialized && !isProcessing.value) {
    isProcessing.value = true;

    try {
      isLoading.value = true;

      // Capture an image from the camera
      XFile imageFile = await cameraController.takePicture();

      // Process punch data
      bool isPunched = await punchData(imageFile,isPunchin);
      if (isPunched) {
        Get.toNamed("/home");
      }

      return true;
    } catch (e) {
      print("Error during face detection---------------: $e");
      AlertNotification.error("Failed!", "Cannot punch in. Report to a ");
            return false;

    } finally {
      isLoading.value = false;
      isProcessing.value = false;
      return true;
    }
  }
  else{
    return false;
  }
}



}
