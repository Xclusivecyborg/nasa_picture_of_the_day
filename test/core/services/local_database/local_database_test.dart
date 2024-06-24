import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/mocks.dart';

void main() {
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
  });

  group('LocalStorage', () {
    test('should save data to local storage', () {
      const key = 'testKey';
      const value = 'testValue';
      when(() => mockLocalStorage.put(key, value)).thenAnswer((_) async {
      });
      mockLocalStorage.put(key, value);

      verify(() => mockLocalStorage.put(key, value)).called(1);
    });

    test('should retrieve data from local storage', () {
      const key = 'testKey';
      const value = 'testValue';
      when(() => mockLocalStorage.get(key)).thenReturn(value);

      final result = mockLocalStorage.get(key);

      expect(result, equals(value));
      verify(() => mockLocalStorage.get(key)).called(1);
    });
  });
}
