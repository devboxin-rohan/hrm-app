import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:hrm_app/app/data/local/local_storage.dart';
import 'package:hrm_app/app/utils/logging.dart';

class NetworkClient {
  String BaseURL = "https://hrm-qa.developerbox.co.in/api";

  Future<Response> sendRequest({
    required String endPoint,
    required String method,
    dynamic data,
    dynamic params,
  }) async {
    try {

      var token = await SharedData().getToken();

      Logging().LoggerPrint("${endPoint} -----Payload  ${data.toString()}  ---Method ${method}");

      Response response = await Dio().request(
        endPoint,
        data: data,
        queryParameters: params,
        options: Options(method: method, headers: {
          "Content-Type":"application/json",
          'Accept': "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${token}",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS",
          "Access-Control-Allow-Headers":
              "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
        }),
      );

      Logging().LoggerPrint(response.toString());
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



// ------------- better optimal solution added below --------------- //

// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
// import 'package:hrm_app/app/data/local/local_storage.dart';
// import 'package:hrm_app/app/utils/logging.dart';

// class NetworkClient {
//   final String baseURL = "https://hrm-qa.developerbox.co.in/api";

//   Dio _dio;

//   NetworkClient() : _dio = Dio() {
//     _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
//   }

//   Future<Response> sendRequest({
//     required String endPoint,
//     required String method,
//     dynamic data,
//     dynamic params,
//   }) async {
//     try {
//       final token = await _fetchToken();

//       Logging().LoggerPrint(
//           "Request - Endpoint: $endPoint | Payload: ${data.toString()} | Method: $method");

//       final response = await _dio.request(
//         '$baseURL$endPoint',
//         data: data,
//         queryParameters: params,
//         options: Options(
//           method: method,
//           headers: _buildHeaders(token),
//         ),
//       );

//       Logging().LoggerPrint("Response - ${response.toString()}");
//       return response;
//     } catch (e) {
//       Logging().LoggerPrint("Error - ${e.toString()}");
//       throw ErrorHandler.handle(e, endpoint: endPoint);
//     }
//   }

//   Future<String> _fetchToken() async {
//     try {
//       return await SharedData().getToken();
//     } catch (e) {
//       throw Failure(
//         message: "Failed to retrieve token. Please login again.",
//       );
//     }
//   }

//   Map<String, String> _buildHeaders(String token) {
//     return {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//       "X-Requested-With": "XMLHttpRequest",
//       "Authorization": "Bearer $token",
//       "Access-Control-Allow-Origin": "*",
//       "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
//       "Access-Control-Allow-Headers":
//           "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With",
//     };
//   }
// }

// // Error Handling
// class ErrorHandler {
//   static Failure handle(dynamic exception, {String? endpoint}) {
//     if (exception is DioException) {
//       return _handleDioException(exception, endpoint: endpoint);
//     }
//     return Failure.getDefaultError();
//   }

//   static Failure _handleDioException(DioException exception,
//       {String? endpoint}) {
//     final errorContext = endpoint != null ? "Endpoint: $endpoint | " : "";
//     switch (exception.type) {
//       case DioExceptionType.connectionTimeout:
//         return Failure.getNetworkError(errorContext);
//       case DioExceptionType.sendTimeout:
//         return Failure.sendTimeout(errorContext);
//       case DioExceptionType.receiveTimeout:
//         return Failure.receiveTimeout(errorContext);
//       case DioExceptionType.badResponse:
//         return _handleBadResponse(exception, errorContext: errorContext);
//       default:
//         if (exception.error is SocketException) {
//           return Failure.getNetworkError(errorContext);
//         }
//         return Failure.getDefaultError(errorContext);
//     }
//   }

//   static Failure _handleBadResponse(DioException exception,
//       {required String errorContext}) {
//     final response = exception.response;
//     if (response != null) {
//       print(response.data);
//       final reason = response.data?["data"]?["reason"] ?? "";
//       final errorCode = response.statusCode ?? "Unknown";

//       Logging().LoggerPrint(
//           "Bad Response - Status: $errorCode | Reason: $reason | Response: ${response.toString()}");

//       return Failure(
//         message: reason.isNotEmpty
//             ? reason
//             : ErrorCodes.getTranslatedErrorMessage(errorCode),
//         errorCode: errorCode.toString(),
//       );
//     } else {
//       return Failure(
//         message: "${errorContext}Unknown response error occurred.",
//       );
//     }
//   }
// }

// class ErrorCodes {
//   static const String authenticationError = 'authentication_error';
//   static const String emailAlreadyExist = 'email_already_exist';

//   static String getTranslatedErrorMessage(dynamic? errorCode) {
//     switch (errorCode) {
//       case 400:
//         return "Bad Request: The server could not understand the request.";
//       case 401:
//         return "Unauthorized: Please logout and login again.";
//       case 403:
//         return "Forbidden: You do not have permission to access this resource.";
//       case 404:
//         return "Not Found: The requested resource could not be found.";
//       case 500:
//         return "Internal Server Error: The server encountered an error.";
//       case 429:
//         return "Rate limit exceeded. Please try again later.";
//       default:
//         return "Unexpected error occurred.";
//     }
//   }
// }

// class Failure {
//   final String message;
//   final String? errorCode;

//   Failure({required this.message, this.errorCode});

//   factory Failure.getDefaultError([String? context]) {
//     return Failure(
//         message: "${context ?? ''}An unexpected error occurred. Please try again later.");
//   }

//   factory Failure.getNetworkError([String? context]) {
//     return Failure(
//         message: "${context ?? ''}Unable to reach the network. Check your connection.");
//   }

//   factory Failure.sendTimeout([String? context]) {
//     return Failure(
//         message: "${context ?? ''}Request timeout. Please try again.");
//   }

//   factory Failure.receiveTimeout([String? context]) {
//     return Failure(
//         message: "${context ?? ''}Server response timeout. Please retry.");
//   }
// }
