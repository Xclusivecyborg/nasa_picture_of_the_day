import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture_of_the_day/core/utils/async_value.dart';
import 'package:nasa_picture_of_the_day/core/utils/extensions/extensions.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/bloc/picture_of_the_day_bloc.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/bloc/picture_of_the_day_state.dart';

import '../mocks/mock_data/mock_response.dart';
import '../mocks/mocks.dart';

void main() {
  late PictureOfTheDayCubit potdCubit;
  late MockGetPotdUsecase getPotdUsecase;
  late MockRetrievePotdUsecase retrievePotdUsecase;

  setUp(() {
    getPotdUsecase = MockGetPotdUsecase();
    retrievePotdUsecase = MockRetrievePotdUsecase();
    potdCubit = PictureOfTheDayCubit(
      getPotdUsecase,
      retrievePotdUsecase,
    );
  });

  tearDown(() {
    potdCubit.close();
  });

  group('POTDCubit', () {
    test('initial state is POTDState.initial', () {
      expect(potdCubit.state, equals(PictureOfTheDayState.initial()));
    });

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''when getPictureOfTheDayList is successfully  called, 
       => state.potdList is  not empty
       => state.potdList.isSuccess is true''',
      build: () => potdCubit,
      act: (cubit) async {
        when(() => getPotdUsecase.call(
                startDate: cubit.state.startDate, endDate: cubit.state.endDate))
            .thenAnswer((_) async => (
                  data: MockData.mockResponse,
                  status: true,
                  message: 'Fetched',
                ));

        await cubit.getPictureOfTheDayList();
      },
      verify: (bloc) {
        verify(() => getPotdUsecase.call(
              startDate: bloc.state.startDate,
              endDate: bloc.state.endDate,
            )).called(1);

        expect(bloc.state.potdList.value?.length, equals(2));
        expect(bloc.state.potdList.isSuccess, true);
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify data is fetched locally if call is unsuccessful due to any error when
         state.value is empty''',
      build: () => potdCubit,
      act: (cubit) async {
        when(() => getPotdUsecase.call(
              startDate: cubit.state.startDate,
              endDate: cubit.state.endDate,
            )).thenAnswer((_) async => (
              data: <PictureOfTheDay>[],
              status: false,
              message: 'An error occurred',
            ));

        when(() => retrievePotdUsecase.call())
            .thenReturn(MockData.mockResponse);

        await cubit.getPictureOfTheDayList();
      },
      verify: (bloc) {
        verify(() => getPotdUsecase.call(
              startDate: bloc.state.startDate,
              endDate: bloc.state.endDate,
            )).called(1);

        verify(() => retrievePotdUsecase.call()).called(1);
        expect(bloc.state.potdList.value?.length, equals(2));
        expect(bloc.state.potdList.isError, true);
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify when loadMore is true and getPotdList is successful
         [POTDSTATE.potdlist.value] increases by 2''',
      build: () => potdCubit,
      seed: () {
        return potdCubit.state.copyWith(
          potdList: AsyncValue.data(MockData.mockResponse),
        );
      },
      act: (cubit) async {
        when(() => getPotdUsecase.call(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
            )).thenAnswer((_) async => (
              data: MockData.mockResponse2,
              status: true,
              message: 'Fetched',
            ));

        await cubit.getPictureOfTheDayList(loadMore: true);
      },
      verify: (bloc) {
        verify(() => getPotdUsecase.call(
              startDate: bloc.state.startDate,
              endDate: bloc.state.endDate,
            )).called(1);

        verifyNever(() => retrievePotdUsecase.call());

        expect(bloc.state.potdList.value?.length, equals(4));
        expect(bloc.state.potdList.isSuccess, true);
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify when loadMore is true 
         [POTDSTATE.potdlist.loadmore] equals LoadState.loadmore''',
      build: () => potdCubit,
      seed: () {
        return potdCubit.state.copyWith(
          potdList: AsyncValue.data(MockData.mockResponse),
        );
      },
      act: (cubit) {
        when(() => getPotdUsecase.call(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
            )).thenAnswer((_) async => (
              data: MockData.mockResponse2,
              status: true,
              message: 'Fetched',
            ));

        cubit.getPictureOfTheDayList(loadMore: true);
        expect(potdCubit.state.potdList.isLoadMore, true);
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify startDateAndEndDateIfLoadMore returns
      => startdat 21 days before state.startDate
      => enddate 1 day before state.startDate''',
      build: () => potdCubit,
      act: (cubit) async {
        final startDateAndEndDate = cubit.startDateAndEndDateIfLoadMore();
        expect(
          is20Daysbefore(
            cubit.state.startDate.toDateTime,
            startDateAndEndDate.$1.toDateTime,
          ),
          true,
        );
        expect(
          is1DayBefore(
            cubit.state.startDate.toDateTime,
            startDateAndEndDate.$2.toDateTime,
          ),
          true,
        );
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify startDateAndEndDateIfLoadMore 
      => startDate is never less than 1995-06-16
      => enddate is never less than 1995-06-16''',
      build: () => potdCubit,
      seed: () {
        return potdCubit.state.copyWith(
          startDate: '1995-04-01',
          endDate: '1995-04-30',
        );
      },
      act: (cubit) async {
        final startDateAndEndDate = cubit.startDateAndEndDateIfLoadMore();
        expect(
          startDateAndEndDate.$1,
          equals('1995-06-16'),
        );
        expect(
          startDateAndEndDate.$2,
          equals('1995-06-16'),
        );
      },
    );
    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify when refresh is true.
        => state is reset to initial state
        => state.potdList is loading''',
      build: () => potdCubit,
      act: (cubit) {
        cubit.setLoadState(refresh: true, loadMore: false);
      },
      expect: () => [
        PictureOfTheDayState.initial(),
        PictureOfTheDayState.initial().copyWith(
          potdList: AsyncValue.loading(),
        )
      ],
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify when clearSearch is called .
        => state.filteredList is empty,
        => state.isSearching is false''',
      build: () => potdCubit,
      seed: () {
        return potdCubit.state.copyWith(
          filteredList: MockData.mockResponse,
          isSearching: true,
        );
      },
      act: (cubit) {
        expect(cubit.state.filteredList.isNotEmpty, true);
        expect(cubit.state.isSearching, true);
        cubit.clearSearch();
        expect(cubit.state.filteredList.isEmpty, true);
        expect(cubit.state.isSearching, false);
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify when setSearching is called,
        => state.isSearching is equal to the value passed''',
      build: () => potdCubit,
      act: (cubit) {
        cubit.setSearching(true);
        expect(cubit.state.isSearching, true);
        cubit.setSearching(false);
        expect(cubit.state.isSearching, false);
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify when searchPOTD is called with a valid title,
        => state.filteredList is not empty''',
      build: () => potdCubit,
      seed: () {
        return potdCubit.state.copyWith(
          potdList: AsyncValue.data(MockData.mockResponse),
        );
      },
      act: (cubit) {
        cubit.searchPOTD('title');
      },
      verify: (bloc) {
        expect(bloc.state.filteredList.isNotEmpty, true);
      },
    );

    blocTest<PictureOfTheDayCubit, PictureOfTheDayState>(
      '''verify when searchPOTD is called with a valid date,
        => state.filteredList is not empty''',
      build: () => potdCubit,
      seed: () {
        return potdCubit.state.copyWith(
          potdList: AsyncValue.data(MockData.mockResponse),
        );
      },
      act: (cubit) {
        cubit.searchPOTD('01 August 2021');
      },
      verify: (bloc) {
        expect(bloc.state.filteredList.isNotEmpty, true);
      },
    );
  });
}

bool is20Daysbefore(DateTime date, DateTime date2) {
  final difference = date.difference(date2).inDays;
  return difference == 20;
}

bool is1DayBefore(DateTime date, DateTime date2) {
  final difference = date.difference(date2).inDays;
  return difference == 1;
}
