import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_picture_of_the_day/core/exception_handler/app_exception_handler.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_utils.dart/base_response.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/repository/picture_of_the_day_repository.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/save_picture_of_the_day_usecase.dart';


@Singleton()
class GetPictureOfTheDayUsecase {
  final PictureOfTheDayRepository repository;
  final SavePictureOfTheDayUsecase savePotdUsecase;
  GetPictureOfTheDayUsecase._(this.repository, this.savePotdUsecase);

  static GetPictureOfTheDayUsecase? _instance;

  factory GetPictureOfTheDayUsecase(PictureOfTheDayRepository repository,
      SavePictureOfTheDayUsecase savePotdUsecase) {
    return _instance ??=
        GetPictureOfTheDayUsecase._(repository, savePotdUsecase);
  }

  Future<BaseResponse<List<PictureOfTheDay>>> call({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await repository.getPictureOfTheDayList(
        startDate: startDate,
        endDate: endDate,
      );
      final reversedResponse = response.reversed.toList();
      await savePotdUsecase.call(reversedResponse);
      return (
        status: true,
        data: reversedResponse,
        message: 'Fetched data successfully',
      );
    } on DioException catch (e) {
      return AppExceptionHandler.handleException(e);
    }
  }
}
