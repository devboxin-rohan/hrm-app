import 'package:dio/dio.dart';
import 'package:hrm_app/app/service/index.dart';

class AttendanceService {
  final NetworkClient networkClinet = NetworkClient();

  Future<Response> SubmitPunchIn(data) async {
    // print(data);
    return await networkClinet.sendRequest(
        endPoint: '${NetworkClient().BaseURL}/modules-hrm/punch_in_out',
        method: "POST",
        data: data);
  }

  Future<Response> getAttandanceDetail() async {
    return await networkClinet.sendRequest(
      endPoint: '${NetworkClient().BaseURL}/modules-hrm/fetch_mobile_dashboard',
      method: "GET",
    );
  }

  // Future<Response> getLocation(latitude, longitude) async {
  //   return await networkClinet.sendRequest(
  //     endPoint:
  //         'https://api.olamaps.io/places/v1/reverse-geocode?latlng=$latitude%2C$longitude&api_key=TCYdGbffMa6b1rpI3Iqan7EZG9fv3BtPQaMWzBoR',
  //     method: "GET",
  //   );
  // }
}

// User Id : shreeshivam23@outlook.com
// Password :  xTv#gdDyoo6NvC3


// Ola maps Api 
// Project Id : 8e8b905f-b6cb-4bb4-82c9-8df8d2e93f02
// Api Key : TCYdGbffMa6b1rpI3Iqan7EZG9fv3BtPQaMWzBoR
// Oauth Credentials : 
// Client Id : 92702ca8-1904-4409-a925-51b7446d5a13
// Client Secret : EkInB7nV6JTt18iSa6mru7bYPlfZK395
