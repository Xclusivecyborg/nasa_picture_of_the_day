import 'package:dio/dio.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_utils.dart/network_routes.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';

/// The [NetworkClient] class is a wrapper around the [Dio] client.
/// It is responsible for making network requests to the NASA API.
/// To access this service, make use of the [getIt] instance this way;
/// getIt<NetworkClient>()
class NetworkClient {
  late final Dio dio;
  NetworkClient(this.dio);

  Future<List<PictureOfTheDay>> getPotdList(
      Map<String, dynamic> queries) async {
    final response = await dio.get(
      NetworkRoutes.apod,
      queryParameters: queries,
    );
    final items = List<Map<String, dynamic>>.from(response.data);
    final potdList = items.map(PictureOfTheDay.fromJson).toList();
    return potdList;
  }
}
