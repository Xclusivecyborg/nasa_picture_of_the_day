import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_utils.dart/base_response.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/get_picture_of_the_day_usecase.dart';
import 'package:test/test.dart';

import '../mocks/mock_data/mock_response.dart';
import '../mocks/mocks.dart';

void main() {
  late MockPotdRepository mockPotdRepository;
  late MockSavePotdUsecase mockSavePotdUsecase;
  late GetPictureOfTheDayUsecase getPotdUsecase;

  setUpAll(() {
    registerMocks();
    mockPotdRepository = MockPotdRepository();
    mockSavePotdUsecase = MockSavePotdUsecase();
    getPotdUsecase =
        GetPictureOfTheDayUsecase(mockPotdRepository, mockSavePotdUsecase);
  });
  group('GetPictureOfTheDayUsecase =>', () {
    test('should return a List<PotdModel> when call is called', () async {
      when(() => mockSavePotdUsecase.call(any())).thenAnswer((_) async {});

      when(() => mockPotdRepository.getPictureOfTheDayList(
            startDate: MockData.startDate,
            endDate: MockData.endDate,
          )).thenAnswer((_) async => MockData.mockResponse);

      final result = await getPotdUsecase.call(
        startDate: MockData.startDate,
        endDate: MockData.endDate,
      );

      expect(result, isA<BaseResponse>());
      expect(result.data?.length, equals(2));
      expect(result.status, true);
      verify(() => mockSavePotdUsecase.call(any())).called(1);
    });

    test(
        'should catch error when there is a DioException and return false as status',
        () async {
      when(() => mockSavePotdUsecase.call(any())).thenAnswer((_) async {});

      when(() => mockPotdRepository.getPictureOfTheDayList(
            startDate: MockData.startDate,
            endDate: MockData.endDate,
          )).thenThrow(
        DioException.badResponse(
          statusCode: 400,
          requestOptions: RequestOptions(),
          response: Response(requestOptions: RequestOptions(), data: {
            'error': {"message": "You are not allowed to get this data"}
          }),
        ),
      );

      final result = await getPotdUsecase.call(
        startDate: MockData.startDate,
        endDate: MockData.endDate,
      );

      verifyNever(() => mockSavePotdUsecase.call(any()));
      expect(result, isA<BaseResponse>());
      expect(result.data, isNull);
      expect(result.status, false);
      expect(result.message, "You are not allowed to get this data");
    });
  });
}
