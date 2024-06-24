import 'package:equatable/equatable.dart';
import 'package:nasa_picture_of_the_day/core/utils/async_value.dart';
import 'package:nasa_picture_of_the_day/core/utils/extensions/extensions.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';

class PictureOfTheDayState extends Equatable {
  final AsyncValue<List<PictureOfTheDay>> potdList;
  final List<PictureOfTheDay> filteredList;
  final String startDate, endDate;
  final bool isSearching;
  const PictureOfTheDayState({
    required this.potdList,
    required this.startDate,
    required this.endDate,
    required this.filteredList,
    required this.isSearching,
  });
  factory PictureOfTheDayState.initial() {
    return PictureOfTheDayState(
      potdList: AsyncValue.initial(),
      startDate: DateTime.now()
          .subtract(const Duration(days: 19))
          .toIso8601String()
          .getYMD,
      endDate: DateTime.now().toIso8601String().getYMD,
      filteredList: const [],
      isSearching: false,
    );
  }
  PictureOfTheDayState copyWith({
    AsyncValue<List<PictureOfTheDay>>? potdList,
    String? startDate,
    String? endDate,
    List<PictureOfTheDay>? filteredList,
    bool? isSearching,
  }) {
    return PictureOfTheDayState(
      potdList: potdList ?? this.potdList,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      filteredList: filteredList ?? this.filteredList,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object> get props => [potdList, filteredList, endDate, isSearching];
}
