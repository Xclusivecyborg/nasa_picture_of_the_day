import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nasa_picture_of_the_day/core/utils/colors.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';
import 'package:nasa_picture_of_the_day/core/utils/theme/text_theme.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/bloc/picture_of_the_day_bloc.dart';

class PictureOfTheDaySearchField extends StatefulWidget {
  const PictureOfTheDaySearchField({super.key});

  @override
  State<PictureOfTheDaySearchField> createState() => _TradingSearchFieldState();
}

class _TradingSearchFieldState extends State<PictureOfTheDaySearchField> {
  final _controller = TextEditingController();
  late final cubit = context.read<PictureOfTheDayCubit>();

  final _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
      cubit.setSearching(_controller.text.isNotEmpty);
      if (_controller.text.isNotEmpty) {
        return cubit.searchPOTD(_controller.text);
      }
    });
    _node.addListener(() {
      cubit.setSearching(_node.hasFocus || _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: POTDColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: .4,
          color: POTDColors.white,
        ),
      ),
      child: TextField(
        focusNode: _node,
        controller: _controller,
        decoration: InputDecoration(
          hintText: Strings.searchHint,
          hintStyle: context.textTheme.s12w400,
          prefixIcon: _controller.text.isEmpty
              ? Icon(
                  CupertinoIcons.search,
                  color: POTDColors.grey,
                  size: 30.h,
                )
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _controller.clear();
                    cubit.clearSearch();
                  },
                  child: const Icon(
                    CupertinoIcons.clear,
                    color: POTDColors.grey,
                  ),
                ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
