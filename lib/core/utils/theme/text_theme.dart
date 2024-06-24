import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nasa_picture_of_the_day/core/utils/colors.dart';

extension ThemeText on TextTheme {
  TextStyle get s14w400 => GoogleFonts.montserrat(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: POTDColors.white,
      );
  TextStyle get s12w400 => GoogleFonts.montserrat(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: POTDColors.white,
      );

  TextStyle get s25w500 => GoogleFonts.montserrat(
        fontSize: 25.sp,
        fontWeight: FontWeight.w500,
        color: POTDColors.white,
      );
}

extension Build on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
