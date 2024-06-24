import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:nasa_picture_of_the_day/core/services/local_storage/local_storage.dart';
import 'package:nasa_picture_of_the_day/core/services/local_storage/storage_keys.dart';
import 'package:nasa_picture_of_the_day/core/services/network/network_client.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/repository/picture_of_the_day_repository.dart';

@Singleton(as: PictureOfTheDayRepository)
class PictureOFTheDayRepositoryImpl implements PictureOfTheDayRepository {
  final NetworkClient _networkClient;
  final LocalStorage _localStorage;

  PictureOFTheDayRepositoryImpl(this._networkClient, this._localStorage);

  @override
  Future<List<PictureOfTheDay>> getPictureOfTheDayList({
    required String startDate,
    required String endDate,
  }) async {
    final response = await _networkClient.getPotdList({
      'start_date': startDate,
      'end_date': endDate,
    });
    return response;
  }

  @override
  List<PictureOfTheDay> retrievePotd() {
    try {
      final potdList = _localStorage.get(StorageKeys.potdList);
      if (potdList != null) {
        final data = (jsonDecode(potdList) as List)
            .map((e) => PictureOfTheDay.fromJson(e))
            .toList();
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> savePotd(List<PictureOfTheDay> entity) async {
    final potdList = retrievePotd();
    bool isSavedLocally = (potdList.firstOrNull)?.date == entity.first.date;
    return await _localStorage.put(
      StorageKeys.potdList,
      jsonEncode(
        [
          if (!isSavedLocally) ...potdList,
          ...entity,
        ],
      ),
    );
  }
}
