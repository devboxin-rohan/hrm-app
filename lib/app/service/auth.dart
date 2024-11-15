import 'package:dio/dio.dart';
import 'package:hrm_app/app/service/index.dart';

class UserService {
  final NetworkClient networkClinet = NetworkClient();

  Future<Response> SubmitCredential(data) async {
    return await networkClinet.sendRequest(
        endPoint: '${NetworkClient().BaseURL}/login',
        method: "POST",
        data: data);
  }

  Future<Response> ServerCheck() async {
    return await networkClinet.sendRequest(
      endPoint: '${NetworkClient().BaseURL}/server_check',
      method: "GET",
    );
  }

  Future<Response> RefreshToken() async {
    return await networkClinet.sendRequest(
      endPoint: '${NetworkClient().BaseURL}/refresh-token',
      method: "POST",
    );
  }
}
