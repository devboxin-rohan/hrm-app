import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/utils/logging.dart';

class FaceNetworkCLient {
  String BaseURL = "https://face-api.developerbox.co.in";

  Future<Response> sendRequest({
    required String endPoint,
    required String method,
    dynamic data,
    dynamic params,
  }) async {
    try {

      var token = await SharedData().getToken();
      // Logging().LoggerPrint("=====================28 " + data);
      Logging().LoggerPrint(endPoint+" -----Payload "+data.toString()+" ---Method "+method);

      Response response = await Dio().request(
        endPoint,
        data: data,
        queryParameters: params,
        options: Options(method: method, headers: {
          "Content-Type":"application/json",
          'Accept': "application/json",
          "X-Requested-With": "XMLHttpRequest",
          // "Authorization": "Bearer ${token}",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS",
          "Access-Control-Allow-Headers":
              "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
        }),
      );
      Logging().LoggerPrint(response.data.toString());
      return response;
    } catch (e) {
      Logging().LoggerPrint(e.toString());
      throw ErrorHandler.handle(e);
    }
  }
}

//error handling -

class ErrorHandler {
  static Failure handle(dynamic exception) {
    if (exception is DioException) {
      print("error reached");
      return _handleDioException(exception);
    }
    return Failure.getDefaultError();
  }

  static Failure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        if (exception.error is SocketException)
          return Failure.getNetworkError();
        else
          return Failure.ConnectionTimeout();
      case DioExceptionType.sendTimeout:
        return Failure.sendTimeout();
      case DioExceptionType.receiveTimeout:
        return Failure.receiveTimeout();
      case DioExceptionType.badResponse:
        final response = exception.response;
        Logging().LoggerPrint(response.toString());
        if (response != null)
          return Failure(
              message:
                  ErrorCodes.getTranslatedErrorMessage(response.statusCode));
        else
          return Failure(
              message: "Something went wrong ! please contact to admin");
      default:
        if (exception.error is SocketException)
          return Failure.getNetworkError();
        else
          return Failure.getDefaultError();
    }
  }

}

class ErrorCodes {
  // remote error codes
  static const String authenticationError = 'authentication_error';
  static const String emailAlreadyExist = 'email_already_exist';

  // local error codes
  static const String userMappingError = "001";
  static const String productMappingError = "002";

  // get Translated message from language file
  static String getTranslatedErrorMessage(dynamic? errorCode) {
    switch (errorCode) {
      case 400:
        return "Bad Request: The server could not understand the request.";
      case 401:
        return "Unauthorized: Please logout and login again.";

      case 403:
        return "Forbidden: You do not have permission to access this resource.";

      case 404:
        return "Not Found: The requested resource could not be found.";

      case 500:
        return "Internal Server Error: The server encountered an error.";

      case 429:
        return "Rate limit exceeded. Please try again later.";

      default:
        return "Unexpected error: ";
    }
  }
}

class Failure {
  final String message;
  final String? errorCode;
  Failure({required this.message, this.errorCode});

  factory Failure.getDefaultError() {
    return Failure(message: 'Default error');
  }

  factory Failure.getNetworkError() {
    return Failure(message: 'Unable to reach connection');
  } 

  factory Failure.ConnectionTimeout() {
    return Failure(message: 'Please retry, connection is lost');
  }

  factory Failure.receiveTimeout() {
    return Failure(message: 'Please retry, server is not responsding');
  }

  factory Failure.sendTimeout() {
    return Failure(message: 'Its taking long time. please try again');
  }

  factory Failure.fromLocalErrorCode(String errorCode) {
    return Failure(
      errorCode: errorCode,
      message: '${'default error'}, $errorCode',
    );
  }
}






  // static Failure _getFailureFromResponse(Response? response) {
  //   try {
  //     if (response?.data is Map<String, dynamic>) {
  //       final data = response?.data as Map<String, dynamic>;
  //       print(data.toString());
  //       print("error manipulating");
  //       final errorCode = data['error_code'];
  //       String? errorMessage = ErrorCodes.getTranslatedErrorMessage(errorCode);
  //       errorMessage ??= _getValidationError(data);
  //       errorMessage ??= data['error_message'] ?? data['detail'];
  //       if (errorMessage != null) {
  //         print("error sending ");
  //         return Failure(message: errorMessage, errorCode: errorCode);
  //       } else {
  //         return Failure.getDefaultError();
  //       }
  //     }
  //     return Failure.getDefaultError();
  //   } catch (e) {
  //     return Failure.getDefaultError();
  //   }
  // }

  // static String? _getValidationError(Map<String, dynamic> data) {
  //   if (data.isNotEmpty) {
  //     final firstError = data.values.first;
  //     if (firstError is List<dynamic> && firstError.isNotEmpty) {
  //       final errorMessage = firstError[0].toString();
  //       return errorMessage;
  //     }
  //   }
  //   return null;
  // }