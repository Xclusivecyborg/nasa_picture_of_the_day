import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/save_picture_of_the_day_usecase.dart';
import 'package:test/test.dart';

import '../mocks/mock_data/mock_response.dart';
import '../mocks/mocks.dart';

void main() {
  late MockPotdRepository mockPotdRepository;
  late SavePictureOfTheDayUsecase savePotdUsecase;

  setUpAll(() {
    mockPotdRepository = MockPotdRepository();
    savePotdUsecase = SavePictureOfTheDayUsecase(
      mockPotdRepository,
    );
  });

  test('verify that repository.savepotd is called once', () async {
    when(() => mockPotdRepository.savePotd(any())).thenAnswer((_) async {});

    await savePotdUsecase.call(
      MockData.mockResponse,
    );

    verify(() => mockPotdRepository.savePotd(MockData.mockResponse)).called(1);
  });

  tearDown(() {
    // Clean up any resources used by the test
  });
}
