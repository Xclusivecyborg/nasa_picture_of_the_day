import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nasa_picture_of_the_day/core/services/local_storage/storage_keys.dart';
import 'package:nasa_picture_of_the_day/core/utils/colors.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';
import 'package:nasa_picture_of_the_day/dependency_injection/injector.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/view/picture_of_the_day_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(StorageKeys.appBox);

  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
  }
}
