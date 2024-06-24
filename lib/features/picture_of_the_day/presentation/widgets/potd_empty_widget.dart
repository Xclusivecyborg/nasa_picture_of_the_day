import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';
import 'package:nasa_picture_of_the_day/core/utils/theme/text_theme.dart';
import 'package:nasa_picture_of_the_day/general_widgets/spacing.dart';

class PictureOfTheDayEmptyWidget extends StatelessWidget {
  const PictureOfTheDayEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.search,
            size: 80.h,
            color: Colors.grey,
          ),
          const VSpacing(20),
          Text(
            Strings.resultWillAppearHere,
            style: context.textTheme.s14w400,
          ),
        ],
      ),
    );
  }
}
