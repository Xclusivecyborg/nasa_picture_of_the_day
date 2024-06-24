import 'package:injectable/injectable.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/repository/picture_of_the_day_repository.dart';

@Singleton()
class SavePictureOfTheDayUsecase {
  final PictureOfTheDayRepository repository;

  SavePictureOfTheDayUsecase(this.repository);

  Future<void> call(List<PictureOfTheDay> entity) async {
    return await repository.savePotd(entity);
  }
}
