import 'dart:async';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Checks if location, camera, and microphone permissions are granted.
/// Returns `true` if all permissions are granted, otherwise `false`.
Future<bool> checkPermissions() async {
  final locationStatus = await Permission.location.status;
  final cameraStatus = await Permission.camera.status;
  final microphoneStatus = await Permission.microphone.status;

  // Return true only if all permissions are granted
  return locationStatus.isGranted &&
         cameraStatus.isGranted &&
         microphoneStatus.isGranted;
}

/// Requests location, camera, and microphone permissions if they are not granted.
/// Returns `true` if all permissions are granted after the request, otherwise `false`.
Future<bool> requestPermissions(context) async {
  // Request location, camera, and microphone permissions
  final statuses = await [
    Permission.location,
    Permission.camera,
    Permission.microphone,
  ].request();

  // Check for denied or permanently denied permissions and show alerts as needed
  if (statuses[Permission.camera]!.isPermanentlyDenied ||
      statuses[Permission.location]!.isPermanentlyDenied || 
      statuses[Permission.microphone]!.isPermanentlyDenied || 
      statuses[Permission.camera]!.isDenied ||
      statuses[Permission.location]!.isDenied || 
      statuses[Permission.microphone]!.isDenied) {
    
    AlertNotification.error("Permission denied", "Required permissions not granted");

    // Open app settings after a delay if permissions are permanently denied
    Timer(Duration(seconds: 2), () async {
      await openAppSettings();
    }); 
    return false;
  }

  // Return true only if all permissions are granted
  return statuses.values.every((status) => status.isGranted);
}
