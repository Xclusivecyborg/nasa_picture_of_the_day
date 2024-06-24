import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';

abstract interface class PictureOfTheDayRepository {
  Future<List<PictureOfTheDay>> getPictureOfTheDayList({
    required String startDate,
    required String endDate,
  });

  Future<void> savePotd(List<PictureOfTheDay> entity);
  List<PictureOfTheDay> retrievePotd();
}
