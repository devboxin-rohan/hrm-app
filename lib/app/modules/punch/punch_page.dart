import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/home/home_controller.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:camera/camera.dart';
import 'package:hrm_app/app/utils/CheckPermission.dart';
import 'package:hrm_app/main.dart';

class PunchPage extends StatefulWidget {
  @override
  _punchPage createState() => _punchPage();
}

class _punchPage extends State<PunchPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  CameraDescription? _frontCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    handlePermissions();
  }


  handlePermissions() async {
    bool isPermission = await checkPermissions();
    bool isRequest = await requestPermissions(navigatorKey.currentState!.context);
    // print("------ requested permission ${isRequest}   ------- check permission ${isPermission}");
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _frontCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _cameraController =
        CameraController(_frontCamera!, ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() {});

    PunchController punchController = Get.find<PunchController>();
    HomeController homeController = Get.find<HomeController>();
    if(homeController.isFaceExist.value)
      punchController.runRecognize(_cameraController!);

  }


  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PunchController punchController = Get.find<PunchController>();
    HomeController homeController = Get.find<HomeController>();
    // ever(homeController.isFaceExist, (_) => {
    //   if(homeController.isFaceExist.value)
    //   punchController.runRecognize(_cameraController!)
    //   });

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Obx(() =>  Center(
        child: punchController.isLoading.value ? CircularProgressIndicator() : Container(
          width:
                MediaQuery.of(navigatorKey.currentState!.context).size.height *
                    .7,
          child: Column( children: [
            SizedBox(height:MediaQuery.of(navigatorKey.currentState!.context).size.height *
                    .2 ,),
          Container(
            width:
                MediaQuery.of(navigatorKey.currentState!.context).size.width *
                    .7,
            height:
                MediaQuery.of(navigatorKey.currentState!.context).size.width *
                    1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(
              //     MediaQuery.of(navigatorKey.currentState!.context).size.width *
              //         .7), // Apply rounded corners
              child: _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
          Obx(() =>  homeController.isFaceExist.value?SizedBox():
          ElevatedButton(onPressed: () {punchController.Register(_cameraController!);}, child: Text("Register")))
        ]),)
      )),
    );
  }
}
