import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


Future GetLatLong() async {
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

// Future<String> getUserLocation(currentPosition) async {
//   String response = "";

//   await AttendanceService()
//       .getLocation(currentPosition.latitude, currentPosition.longitude)
//       .then(((value) {
//     response = value.data['results'][0]["formatted_address"];
//   })).catchError((onError) {
//     throw Error();
//   });

//   return response;
//   // List<Placemark> placemarks = await placemarkFromCoordinates(
//   //     currentPosition.latitude, currentPosition.longitude);
//   // Placemark place = placemarks[0];
//   // return '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
// }
