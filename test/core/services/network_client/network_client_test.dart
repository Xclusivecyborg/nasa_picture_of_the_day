import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_client.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_utils.dart/network_routes.dart';
import 'package:test/test.dart';

import '../../../mocks/mock_data/mock_response.dart';

void main() {
  late NetworkClient networkClient;
  late DioAdapter dioAdapter;
  setUpAll(() {
    dioAdapter = DioAdapter(dio: Dio());
    networkClient = NetworkClient(dioAdapter.dio);
  });

  group('NetworkClient', () {
    test('should return a List<PotdModel> when getPotdList is called',
        () async {
      dioAdapter.onGet(
        NetworkRoutes.apod,
        (request) => request.reply(200, [
          MockData.getMockPotdMap,
        ]),
      );

      final response = await networkClient.getPotdList({});

      expect(response.length, 1);
      expect(response.first.copyright, 'NASA');
    });
  });

  tearDownAll(() {
    dioAdapter.close();
  });
}
