// modules/home/home_controller.dart
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:hrm_app/app/data/models/punch_model.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
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
  var isAdding = false.obs;
  Rxn<Timer> timer = Rxn<Timer>();

  @override
  void onInit() {
    super.onInit();
    punchBox = Hive.box<PunchModel>('punchBox');
    loadPunchData();
  }

  void loadPunchData() async{
    AuthController controller = Get.find<AuthController>();
    var response = await controller.getUserData();
    punchList.assignAll(punchBox.values.where((punch) => punch.user_id == response!.empId).toList());
  }

  void addPunch(PunchModel punch) {
    isAdding.value = true; // Set loading state to true
    punchBox.put(punch.id, punch);
    punchList.insert(0, punch);
    isAdding.value = false; // Set loading state to true

     BackgroundWorkDispatcher.SubmitPunchData();
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

  void Register(CameraController cameraController) async {
  if (cameraController != null &&
      cameraController.value.isInitialized &&
      !isProcessing.value) {
    isProcessing.value = true;

    try {
      // Capture an image from the camera
      XFile? imageFile = await cameraController.takePicture();
      
      // Check if the file was actually created
      if (imageFile == null || !(await File(imageFile.path).exists())) {
        print("Error: Captured image file not found at path: ${imageFile?.path}");
        isProcessing.value = false;
        return;
      }

      // Convert XFile to File for compatibility
      File image = File(imageFile.path);
      String fileName = image.path.split('/').last;

      // Get user data for form submission
      AuthController controller = Get.find<AuthController>();
      var response = await controller.getUserData();

      // Prepare form data with image file and user information
      dio.FormData formData = dio.FormData.fromMap({
        "user_id": response!.empId,
        "file": await dio.MultipartFile.fromFile(image.path, filename: fileName),
        "userName": response.name,
      });

      // Print form data fields for debugging
      print("Form Data Fields: ${formData.fields}");

      try {
        // Send the form data
        dio.Response res = await FaceService().RegisterFace(formData);
        AlertNotification.success(res.data["message"], "");
        Get.toNamed("/home");
      } catch (error) {
        print("Error during face registration: $error");
        AlertNotification.error("Registration Failed", "Unable to register face");
        Get.toNamed("/home");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isProcessing.value = false;
    }
  }
}

  void runRecognize(CameraController cameraController) {
    timer.value = Timer.periodic(
        Duration(seconds: 2), (Timer t) => Recognize(cameraController));
  }

  void Recognize(CameraController cameraController) async {
    if (cameraController != null &&
        cameraController!.value.isInitialized &&
        !isProcessing.value) {
      isProcessing.value = true;

      try {
        // Capture an image from the camera
        XFile imageFile = await cameraController!.takePicture();
        File image = File(imageFile.path);

        AuthController controller = Get.find<AuthController>();
        var response = await controller.getUserData();
        String fileName = image.path.split('/').last;
        dio.MultipartFile file =
            await dio.MultipartFile.fromFile(image.path, filename: fileName);

        dio.FormData formData = dio.FormData.fromMap({
          "user_id": response!.empId,
          "file": file,
        });

        try {
          dio.Response response = await FaceService().RecognizeFace(formData);
          AlertNotification.success(
              "Face found successfully", response.data["message"]);
          faceFound.value = true;
          isLoading.value = true;
          bool isPunched = await punchData(imageFile);
          if (isPunched) {
            isLoading.value = false;
            Get.toNamed("/home");
          }
          isLoading.value = false;
          timer.value!.cancel();
        } catch (e) {
          AlertNotification.error("Failed !", "Face not recognized");
          faceFound.value = false;
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Error during registration.")));
      } finally {
        isProcessing.value = false;
      }
    }
  }

  Future<bool> punchData(XFile imageFile) async {
    try {
      final DateTime now = DateTime.now();
      String timeNDate = DateFormat('yyyy/MM/dd hh:mm a').format(now);

      Position? position = await GetLatLong();
      AuthController controller = Get.find<AuthController>();
      var response = await controller.getUserData();
      final punch = PunchModel.create(
        imagePath: imageFile!.path,
        latitude: position!.latitude,
        longitude: position!.longitude,
        dateTime: timeNDate,
        isSync: false,
        user_id: response!.empId
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
}
