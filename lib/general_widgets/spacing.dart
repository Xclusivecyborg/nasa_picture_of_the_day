import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class Spacing extends StatelessWidget {
  const Spacing({super.key});
}

final class HSpacing extends Spacing {
  const HSpacing(this.size,{super.key });
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size.w);
  }
}

final class VSpacing extends Spacing {
  const VSpacing( this.size,{super.key, });
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size.h);
  }
}
