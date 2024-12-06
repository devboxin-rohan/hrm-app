import 'package:flutter/material.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';

Future<String> setDeviceId(context, empId) async {
  String mobilecode = "";
  if (Theme.of(context).platform == TargetPlatform.android)
    mobilecode=  await _getAndroidDeviceID(empId);
  else if (Theme.of(context).platform == TargetPlatform.iOS) _getIosDeviceID();

  return mobilecode;
}

Future<String> _getAndroidDeviceID(empId) async {
  const _androidIdPlugin = AndroidId();
  final String? androidId = await _androidIdPlugin.getId();

  String id1 = "${androidId?.substring(0, 4)}." +
      empId.toString() +
      ".${androidId?.substring(androidId.length - 4, androidId.length)}";

  SharedData().setDeviceId(id1);
  return id1;
}

Future<void> _getIosDeviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  SharedData().setDeviceId(iosInfo.identifierForVendor);
}
