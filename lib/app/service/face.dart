import 'package:dio/dio.dart';
import 'package:hrm_app/app/service/faceIndex.dart';

class FaceService {
  final FaceNetworkCLient networkClinet = FaceNetworkCLient();

  Future<Response> RegisterFace(data) async {
    return await networkClinet.sendRequest(
        endPoint: '${FaceNetworkCLient().BaseURL}/register',
        method: "POST",
        data: data);
  }

  Future<Response> RecognizeFace(data) async {
    return await networkClinet.sendRequest(
        endPoint: '${FaceNetworkCLient().BaseURL}/verify',
        method: "POST",
        data: data
    );
  }

  Future<Response> IsFaceExist(id) async {
    return await networkClinet.sendRequest(
      endPoint: '${FaceNetworkCLient().BaseURL}/check_face_existence/${id}',
      method: "GET",
    );
  }

}
