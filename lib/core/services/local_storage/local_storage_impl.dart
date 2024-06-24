import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_picture_of_the_day/core/services/local_storage/local_storage.dart';
import 'package:nasa_picture_of_the_day/core/services/local_storage/storage_keys.dart';

@Singleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl(
    @Named('hive_interface') this.interface,
  );
  final HiveInterface interface;

  @override
  Future<void> put(dynamic key, dynamic value) async {
    return await interface.box(StorageKeys.appBox).put(key, value);
  }

  @override
  dynamic get<T>(String key) {
    return interface.box(StorageKeys.appBox).get(key);
  }
}
