import 'package:dio/dio.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_utils.dart/base_response.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';

class AppExceptionHandler implements Exception {
  static BaseResponse<T> handleException<T>(
    DioException e, {
    T? data,
  }) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        (status: false, data: data, message: Strings.timeOut),
      DioExceptionType.connectionError => (
          status: false,
          data: data,
          message: Strings.timeOut
        ),
      DioExceptionType.badResponse when (e.response?.statusCode ?? 0) >= 500 =>
        (status: false, data: data, message: Strings.serverError),
      DioExceptionType.badResponse
          when (e.response?.data) is Map<String, dynamic> =>
        (
          status: false,
          data: data,
          message: e.response?.data['msg'] ??
              e.response?.data["error"]?["message"] ??
              Strings.genericError
        ),
      DioExceptionType.badResponse when (e.response?.data) is String => (
          status: false,
          data: data,
          message: e.response?.data
        ),
      _ => (status: false, data: data, message: Strings.genericError)
    };
  }
}
