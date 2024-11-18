import 'dart:async';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path/path.dart';

class FaceDetectionUtil {
  late CameraController _cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;

  /// Initialize Camera with the front-facing lens
  Future<CameraController> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController.initialize();
    return _cameraController;
  }

  /// Initialize ML Kit Face Detector
  void initializeFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
    );
  }

  /// Capture image and detect faces
  Future<bool> captureAndDetectFaces(CameraController cameraController) async {
    if (_isDetecting) return false;  // Prevent concurrent captures
    _isDetecting = true;

    try {
      final imageFile = await cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final faces = await _faceDetector.processImage(inputImage);

      return faces.isNotEmpty;
    } catch (e) {
      print("Error during face detection: $e");
      return false;
    } finally {
      _isDetecting = false;
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}
