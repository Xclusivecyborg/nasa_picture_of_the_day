import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture_of_the_day/core/services/local_storage/local_storage.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_client.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/repository/picture_of_the_day_repository.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/get_picture_of_the_day_usecase.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/retrieve_picture_of_the_day_usecase.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/save_picture_of_the_day_usecase.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/bloc/picture_of_the_day_bloc.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockPotdRepository extends Mock implements PictureOfTheDayRepository {}

class MockSavePotdUsecase extends Mock implements SavePictureOfTheDayUsecase {}

class MockGetPotdUsecase extends Mock implements GetPictureOfTheDayUsecase {}

class MockRetrievePotdUsecase extends Mock
    implements RetrievePictureOfTheDayUsecase {}

class MockHiveInterface extends Mock implements HiveInterface {}

final gt = GetIt.instance;
void registerMocks() {
  gt.registerSingleton<MockNetworkClient>(MockNetworkClient());
  gt.registerSingleton<MockHiveInterface>(MockHiveInterface());
  gt.registerSingleton<MockLocalStorage>(MockLocalStorage());
  gt.registerSingleton<MockPotdRepository>(MockPotdRepository());
  gt.registerSingleton<MockSavePotdUsecase>(MockSavePotdUsecase());
  gt.registerSingleton<MockGetPotdUsecase>(MockGetPotdUsecase());
  gt.registerSingleton<MockRetrievePotdUsecase>(MockRetrievePotdUsecase());
  gt.registerFactory(
    () => PictureOfTheDayCubit(
      gt<MockGetPotdUsecase>(),
      gt<MockRetrievePotdUsecase>(),
    ),
  );
}
