import 'package:injectable/injectable.dart';
import 'package:nasa_picture_of_the_day/core/cubit/safe_cubit.dart';
import 'package:nasa_picture_of_the_day/core/exception_handler/generic_exception.dart';
import 'package:nasa_picture_of_the_day/core/utils/async_value.dart';
import 'package:nasa_picture_of_the_day/core/utils/extensions/extensions.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/get_picture_of_the_day_usecase.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/domain/usecases/retrieve_picture_of_the_day_usecase.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/bloc/picture_of_the_day_state.dart';

@Injectable()
class PictureOfTheDayCubit extends SafeCubit<PictureOfTheDayState> {
  PictureOfTheDayCubit(this._usecase, this._retrievePotdUsecase)
      : super(PictureOfTheDayState.initial());

  final GetPictureOfTheDayUsecase _usecase;
  final RetrievePictureOfTheDayUsecase _retrievePotdUsecase;
  DateTime lastAvailableDate = DateTime(1995, 06, 16);

  Future<void> getPictureOfTheDayList({
    bool loadMore = false,
    bool refresh = false,
  }) async {
    try {
      setLoadState(loadMore: loadMore, refresh: refresh);

      final response = await _usecase.call(
        startDate: state.startDate,
        endDate: state.endDate,
      );

      var (:data, :message, status: status) = response;

      if (!status) throw message.toException;

      ///This ensures that once the last available date is reached, the
      ///load more feature is disabled
      final composedData = switch ((data?.length ?? 0) < 20 &&
          state.startDate.toDateTime.compareTo(lastAvailableDate) <= 0) {
        true => AsyncValue.done([...?state.potdList.value, ...?data]),
        _ =>
          AsyncValue.data([if (loadMore) ...?state.potdList.value, ...?data]),
      };

      emit(state.copyWith(potdList: composedData));
    } catch (e) {
      emit(state.copyWith(
        potdList: AsyncValue.error(e.toString(), getPotdList),
      ));
    }
  }

  void setLoadState({required bool loadMore, required bool refresh}) {
    if (refresh) emit(PictureOfTheDayState.initial());
    if (loadMore) {
      emit(
        state.copyWith(
          potdList: AsyncValue.loadMore(state.potdList.value ?? []),
          startDate: startDateAndEndDateIfLoadMore().$1,
          endDate: startDateAndEndDateIfLoadMore().$2,
        ),
      );
    } else {
      emit(state.copyWith(potdList: AsyncValue.loading()));
    }
  }

  (String startDate, String endDate) startDateAndEndDateIfLoadMore() {
    final startDate = state.startDate.toDateTime
        .subtract(const Duration(days: 20))
        .toIso8601String();

    final endDate = state.startDate.toDateTime
        .subtract(const Duration(days: 1))
        .toIso8601String();

    /// This ensures that the startDate is not less than 1995-06-16
    /// as stated in the NASA API documentation
    final sD = switch (startDate.toDateTime.compareTo(lastAvailableDate) <= 0) {
      true => lastAvailableDate.toIso8601String(),
      false => startDate,
    };

    /// This ensures that the endDate is not less than 1995-06-16
    /// as stated in the NASA API documentation
    final eD = switch (endDate.toDateTime.compareTo(lastAvailableDate) <= 0) {
      true => lastAvailableDate.toIso8601String(),
      false => endDate,
    };
    return (sD.getYMD, eD.getYMD);
  }

  List<PictureOfTheDay> get getPotdList {
    ///Fetch data from local storage if available in case of network failure
    final potdList = (state.potdList.value ?? []);
    return potdList.isEmpty ? _retrievePotdUsecase.call() : potdList;
  }

  void searchPOTD(String query) {
    final filteredList = state.potdList.value?.where(
      (element) {
        bool titleMatch = (element.title ?? '').toLowerCase().contains(
              query.toLowerCase(),
            );
        final date = (element.date ?? '').toNiceFullDate.toLowerCase();
        bool dateMatch = date.contains(
          query.toLowerCase(),
        );
        return titleMatch || dateMatch;
      },
    ).toList();
    emit(state.copyWith(filteredList: filteredList));
  }

  void clearSearch() {
    emit(state.copyWith(filteredList: [], isSearching: false));
  }

  void setSearching(bool isSearching) {
    emit(state.copyWith(isSearching: isSearching));
  }
}
