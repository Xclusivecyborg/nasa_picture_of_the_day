abstract class LocalStorage {
  Future<void> put(dynamic key, dynamic value);
  dynamic get<T>(String key);
}
