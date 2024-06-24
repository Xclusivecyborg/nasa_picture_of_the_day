import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_client.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_utils.dart/network_routes.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_utils.dart/request_interceptor.dart';

@module
abstract class AppModule {
  @singleton
  NetworkClient networkClient() {
    final dio = Dio()
      ..options.baseUrl = NetworkRoutes.baseUrl
      ..interceptors.add(RequestInterceptor())
      ..options.receiveTimeout = const Duration(milliseconds: 3000);
    return NetworkClient(dio);
  }

  @Singleton()
  @Named('hive_interface')
  HiveInterface box() => Hive;
}
