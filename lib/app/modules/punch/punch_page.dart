import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'package:hrm_app/app/utils/CheckPermission.dart';
import 'package:hrm_app/app/utils/widgets/AppBar.dart';
import 'package:hrm_app/main.dart';
import 'package:hrm_app/app/utils/face_detection_utils.dart';

class PunchPage extends StatefulWidget {
  @override
  _PunchPageState createState() => _PunchPageState();
}

class _PunchPageState extends State<PunchPage> {
  CameraController? _cameraController;
  late FaceDetectionUtil _faceDetectionUtil;
  bool _hasPunched = false; // Ensures a single punch is registered
  bool _isApiRunning = false; // Prevents multiple API calls
  Timer? _timer;

  HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _faceDetectionUtil = FaceDetectionUtil();
    _initializeCamera();
    _faceDetectionUtil.initializeFaceDetector();
    _handlePermissions();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetectionUtil.dispose();
    _timer?.cancel(); // Stop the timer to prevent memory leaks
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameraController = await _faceDetectionUtil.initializeCamera();
    setState(() {});

    _timer = Timer.periodic(Duration(seconds: 2), (Timer t) async {
      if (!_hasPunched && !_isApiRunning) {
        await _captureAndDetectFaces();
      }
    });
  }

  Future<void> _handlePermissions() async {
    await checkPermissions();
    await requestPermissions(navigatorKey.currentState!.context);
  }

  Future<void> _captureAndDetectFaces() async {
    _isApiRunning = true;

    final imagePath =
        await _faceDetectionUtil.captureAndDetectFaces(_cameraController!);
    
    if (imagePath != null && !_hasPunched) {

      _hasPunched = true;

      bool? isPunchin = Get.arguments['isPunchin'];

      // // Determine the correct API call
      try {
        if (homeController.isManualAllowed.value) {
          if (homeController.isFaceAuthenticationAllowed.value) {
            if (homeController.isFaceExist.value) {
              await Get.find<PunchController>()
                  .Recognize(imagePath, isPunchin!);
            } else {
              await Get.find<PunchController>().Register(imagePath);
            }
          } else {
            await Get.find<PunchController>()
                .captureAndPunch(imagePath, isPunchin!);
          }
        } else {
          if (homeController.isFaceAuthenticationAllowed.value) {
            await Get.find<PunchController>()
                .RecognizeByAll(imagePath, isPunchin!);
          } else {
            await Get.find<PunchController>()
                .captureAndPunch(imagePath, isPunchin!);
          }
        }
      } finally {
          _hasPunched = false;
        _isApiRunning = false;
      }
    } else {
      print("No faces detected.");
      _isApiRunning = false; // Allow new attempts even if no faces detected
    }
  }

  @override
  Widget build(BuildContext context) {
    PunchController punchController = Get.find<PunchController>();

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: AppColors.secondary,
      body: Obx(() {
        return Center(
          child: punchController.isLoading.value
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Check if the camera is initialized
                    if (_cameraController != null &&
                        _cameraController!.value.isInitialized)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: CameraPreview(_cameraController!),
                      )
                    else
                      // Show a placeholder or loading indicator while the camera initializes
                      Container(
                        height: MediaQuery.of(context).size.width * 0.6,
                        width: MediaQuery.of(context).size.width * 0.6,
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: Text(
                          "Initializing Camera...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                    // SizedBox(height: 20),
                    // ElevatedButton(
                    //     onPressed: markManually, child: Text("Mark Manually"))
                  ],
                ),
        );
      }),
    );
  }
}
