import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_picture_of_the_day/core/utils/colors.dart';
import 'package:nasa_picture_of_the_day/core/utils/enums.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';
import 'package:nasa_picture_of_the_day/dependency_injection/injector.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/view/picture_of_the_day_detail.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/view/picture_of_the_day_list.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/view/picture_of_the_day_view.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_card.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_error_card.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_network_image.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_search_field.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_video_player.dart';
import 'package:nasa_picture_of_the_day/general_widgets/app_loader.dart';

import '../mocks/mock_data/mock_response.dart';
import '../mocks/mocks.dart';

void main() {
  setUpAll(() async {
    registerMocks();
  });

  group('Picture Of The Day View', () {
    final defaultWidget = ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, c) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            title: Strings.potdTitle,
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: POTDColors.backgroundColor,
            ),
            home: const PictureOfTheDayView(),
          ),
        );
      },
    );

    testWidgets('End to End Test - Case Successful Response from APOD endpoint',
        (WidgetTester tester) async {
      // ensure the test environment is initialized
      TestWidgetsFlutterBinding.ensureInitialized();

      // ensure the screen size is available for responsive UI testing
      await ScreenUtil.ensureScreenSize();

      // mock the response from the APOD endpoint
      when(() => getIt<MockGetPotdUsecase>().call(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => (
            data: MockData.mockResponse,
            status: true,
            message: 'Fetched',
          ));

      // mock the response from the retrievePotd usecase
      when(() => getIt<MockRetrievePotdUsecase>().call())
          .thenReturn(MockData.mockResponse);

      // build the PictureOfTheDayView widget
      await tester.pumpWidget(defaultWidget);

      // verify the appbar [by the title]
      //search field, and the AppLoader widget are the only widgets rendered
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(PictureOfTheDaySearchField), findsOneWidget);
      expect(find.byType(AppLoader), findsOneWidget);
      expect(find.byType(PictureOfTheDayErrorCard), findsNothing);

      await tester.pumpAndSettle();

      // verify the appbar title and the List of  widget are the only widgets rendered
      //when the request is successful
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(AppLoader), findsNothing);
      expect(find.byType(PictureOfTheDayList), findsOneWidget);

      final firstItem = find.byKey(Key(MockData.mockResponse.first.date ?? ""));

      // verify the first item in the list is rendered
      expect(firstItem, findsOneWidget);

      await tester.tap(firstItem);

      await tester.pumpAndSettle();

      /// verify the [PictureOfTheDayDetail] widget is rendered
      expect(find.byType(PictureOfTheDayDetail), findsOneWidget);

      //verify that the image/video, title, date, and explanation are rendered
      if (MockData.mockResponse.first.mediaType == MediaType.image) {
        expect(find.byType(PictureOfTheDayNetworkImage), findsOneWidget);
      } else {
        expect(find.byType(PictureOfTheDayVideoPlayer), findsOneWidget);
      }
      expect(
          find.text(MockData.mockResponse.first.title ?? ""), findsOneWidget);
      expect(find.byType(POTDDate), findsOneWidget);
      expect(
        find.text(MockData.mockResponse.first.explanation ?? ''),
        findsOneWidget,
      );
    });

    testWidgets('End to End Test - Case Error Response from APOD endpoint',
        (WidgetTester tester) async {
      // ensure the test environment is initialized
      TestWidgetsFlutterBinding.ensureInitialized();

      // ensure the screen size is available for responsive UI testing
      await ScreenUtil.ensureScreenSize();

      // mock the response from the APOD endpoint
      when(() => getIt<MockGetPotdUsecase>().call(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => (
            data: null,
            status: false,
            message: Strings.genericError,
          ));

      // mock the response from the retrievePotd usecase
      when(() => getIt<MockRetrievePotdUsecase>().call()).thenReturn([]);

      // build the PictureOfTheDayView widget
      await tester.pumpWidget(defaultWidget);

      /// verify the appbar [by the title]
      /// search field, and the AppLoader widget are the only widgets rendered
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(PictureOfTheDaySearchField), findsOneWidget);
      expect(find.byType(AppLoader), findsOneWidget);
      expect(find.byType(PictureOfTheDayErrorCard), findsNothing);

      await tester.pumpAndSettle();

      /// verify the [PictureOfTheDayErrorCard] with the error text are the only
      /// widgets rendered
      /// when the request is not successful
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(PictureOfTheDayErrorCard), findsOneWidget);
      expect(find.text(Strings.genericError), findsOneWidget);
      expect(find.byType(PictureOfTheDayList), findsNothing);
    });

    testWidgets('''End to End Test - Case Error Response from APOD endpoint. 
              => Verify Offline Support''', (WidgetTester tester) async {
      // ensure the test environment is initialized
      TestWidgetsFlutterBinding.ensureInitialized();

      // ensure the screen size is available for responsive UI testing
      await ScreenUtil.ensureScreenSize();

      // mock the response from the APOD endpoint
      when(() => getIt<MockGetPotdUsecase>().call(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => (
            data: null,
            status: false,
            message: Strings.noInternet,
          ));

      // mock the response from the retrievePotd usecase
      when(() => getIt<MockRetrievePotdUsecase>().call())
          .thenReturn(MockData.mockResponse2);

      // build the PictureOfTheDayView widget
      await tester.pumpWidget(defaultWidget);

      /// verify the appbar [by the title]
      /// search field, and the AppLoader widget are the only widgets rendered
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(PictureOfTheDaySearchField), findsOneWidget);
      expect(find.byType(AppLoader), findsOneWidget);

      await tester.pumpAndSettle();

      // verify the appbar title and the List of  widget are the only widgets rendered
      //when there is an error but there's data in the local storage
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(AppLoader), findsNothing);
      expect(find.byType(PictureOfTheDayErrorCard), findsNothing);
      expect(find.byType(PictureOfTheDayList), findsOneWidget);
    });

    testWidgets('''End to End Test - Case Successful Response from APOD endpoint
              => Verify Search Field Functionality''',
        (WidgetTester tester) async {
      // ensure the test environment is initialized
      TestWidgetsFlutterBinding.ensureInitialized();

      // ensure the screen size is available for responsive UI testing
      await ScreenUtil.ensureScreenSize();

      // mock the response from the APOD endpoint
      when(() => getIt<MockGetPotdUsecase>().call(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => (
            data: MockData.mockResponse,
            status: true,
            message: 'Fetched',
          ));

      // mock the response from the retrievePotd usecase
      when(() => getIt<MockRetrievePotdUsecase>().call())
          .thenReturn(MockData.mockResponse);

      // build the PictureOfTheDayView widget
      await tester.pumpWidget(defaultWidget);

      // verify the appbar [by the title]
      //search field, and the AppLoader widget are the only widgets rendered
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(PictureOfTheDaySearchField), findsOneWidget);
      expect(find.byType(AppLoader), findsOneWidget);
      expect(find.byType(PictureOfTheDayErrorCard), findsNothing);

      await tester.pumpAndSettle();

      /// verify the appbar title and the List of  widget are the only widgets rendered
      ///when the request is successful
      expect(find.text(Strings.potdTitle), findsOneWidget);
      expect(find.byType(AppLoader), findsNothing);
      expect(find.byType(PictureOfTheDayList), findsOneWidget);

      final searchField = find.byType(PictureOfTheDaySearchField);

      /// verify the search field is rendered
      expect(searchField, findsOneWidget);

      /// enter a date in the search field
      await tester.enterText(searchField, '01 august 2021');

      /// tap the done button on the keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      //verify items whose date is 01 august 2021 are rendered
      expect(find.byKey(const Key('2021-08-01')), findsOneWidget);
    });
  });
}
