import 'dart:async';

import 'package:dio/dio.dart';
import 'package:nasa_picture_of_the_day/core/utils/logger.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';

/// The [RequestInterceptor] class is responsible for intercepting requests
/// made by the [Dio] client.
/// Harnessing the power of interceptors, we can modify requests before they
/// are sent, and responses before they are returned.
class RequestInterceptor extends Interceptor {
  RequestInterceptor();

  @override
  FutureOr<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    try {
      const apiKey = String.fromEnvironment(Strings.apiKey);
      options.queryParameters[Strings.apiKey.toLowerCase()] = apiKey;
    } catch (e) {
      debugLog(e);
    }
    handler.next(options);
    return options;
  }

  @override
  FutureOr<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    debugLog(err.response);
    handler.next(err);
    return err;
  }

  @override
  FutureOr<dynamic> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    debugLog('RESPONSE FROM: ${response.requestOptions.uri}');

    debugLog('RESPONSE: ${response.data}');

    handler.next(response);
    return response;
  }
}
