import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/retrieve_picture_of_the_day_usecase.dart';
import 'package:test/test.dart';

import '../mocks/mock_data/mock_response.dart';
import '../mocks/mocks.dart';

void main() {
  late MockPotdRepository mockPotdRepository;
  late RetrievePictureOfTheDayUsecase retrievePotdUsecase;

  setUpAll(() {
    mockPotdRepository = MockPotdRepository();
    retrievePotdUsecase = RetrievePictureOfTheDayUsecase(
      mockPotdRepository,
    );
  });

  test('verify that repository.retrievePotd is called once', () async {
    when(() => mockPotdRepository.retrievePotd())
        .thenReturn(MockData.mockResponse);

    retrievePotdUsecase.call();

    verify(() => mockPotdRepository.retrievePotd()).called(1);
  });

  test('verify that repository.retrievePotd returns a list of PotdModel',
      () async {
    when(() => mockPotdRepository.retrievePotd())
        .thenReturn(MockData.mockResponse);

    final result = retrievePotdUsecase.call();

    expect(result, isA<List<PictureOfTheDay>>());
    expect(result.length, 2);
  });
}
