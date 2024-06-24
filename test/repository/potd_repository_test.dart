import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture_of_the_day/core/services/local_storage/storage_keys.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/repository/picture_of_the_day_repository_impl.dart';

import '../mocks/mock_data/mock_response.dart';
import '../mocks/mocks.dart';

void main() {
  late MockNetworkClient mockNetworkClient;
  late MockLocalStorage mockLocalStorage;
  late PictureOFTheDayRepositoryImpl repository;
  setUpAll(() {
    mockNetworkClient = MockNetworkClient();
    mockLocalStorage = MockLocalStorage();
    repository =
        PictureOFTheDayRepositoryImpl(mockNetworkClient, mockLocalStorage);
  });
  group('POTDRepository', () {
    test(
        'should return a list of PotdModel when getPictureOfTheDayList is called',
        () async {
      when(() => mockNetworkClient.getPotdList({
            'start_date': MockData.startDate,
            'end_date': MockData.endDate,
          })).thenAnswer((_) async => MockData.mockResponse);

      final result = await repository.getPictureOfTheDayList(
          startDate: MockData.startDate, endDate: MockData.endDate);

      expect(result, isA<List<PictureOfTheDay>>());
    });

    test('should return a list of PotdModel when retrievePotd is called',
        () async {
      when(() => mockLocalStorage.get(any()))
          .thenReturn(jsonEncode(MockData.mockResponse));

      final result = repository.retrievePotd();

      expect(result, isA<List<PictureOfTheDay>>());
      expect(result.length, 2);
    });

    test('should save a list of PotdModel when savePotd is called', () async {
      when(() => mockLocalStorage.get(any()))
          .thenReturn(jsonEncode(MockData.mockResponse));
      when(() => mockLocalStorage.put(
            any(),
            jsonEncode(MockData.mockResponse),
          )).thenAnswer((_) async {});

      await repository.savePotd(MockData.mockResponse);

      verifyInOrder([
        () => mockLocalStorage.get(StorageKeys.potdList),
        () => mockLocalStorage.put(
              StorageKeys.potdList,
              jsonEncode(MockData.mockResponse),
            ),
      ]);
    });
  });
}
