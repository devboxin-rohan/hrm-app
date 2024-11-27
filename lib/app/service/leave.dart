import 'package:dio/dio.dart';
import 'package:hrm_app/app/service/index.dart';

class LeaveServices {
  final NetworkClient networkClinet = NetworkClient();

  Future<Response> ApplyLeave(data) async {
    // print(data);
    return await networkClinet.sendRequest(
        endPoint: '${NetworkClient().BaseURL}/modules-hrm/leaves',
        method: "POST",
        data: data);
  }

}
