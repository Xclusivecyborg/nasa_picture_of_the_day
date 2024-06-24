import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nasa_picture_of_the_day/core/utils/enums.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';
import 'package:nasa_picture_of_the_day/core/utils/theme/text_theme.dart';
import 'package:nasa_picture_of_the_day/dependency_injection/injector.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/bloc/picture_of_the_day_bloc.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/bloc/picture_of_the_day_state.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/view/picture_of_the_day_list.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_empty_widget.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_error_card.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_search_field.dart';
import 'package:nasa_picture_of_the_day/general_widgets/app_loader.dart';

class PictureOfTheDayView extends StatelessWidget {
  const PictureOfTheDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PictureOfTheDayCubit>(),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View();
  @override
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> {
  late final PictureOfTheDayCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<PictureOfTheDayCubit>(context)
      ..getPictureOfTheDayList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          Strings.potdTitle,
          style: context.textTheme.s14w400,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10, 20.w, 10.h),
            child: const PictureOfTheDaySearchField(),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<PictureOfTheDayCubit, PictureOfTheDayState>(
          builder: (context, state) {
            final PictureOfTheDayState(:filteredList, :potdList, :isSearching) =
                state;
            final listToDisplay =
                isSearching ? filteredList : potdList.value ?? [];
            return switch (potdList.loadState) {
              LoadState.loading => const AppLoader(),
              LoadState.error when state.potdList.value?.isEmpty == true =>
                PictureOfTheDayErrorCard(
                  onRetry: () => _cubit.getPictureOfTheDayList(),
                  errorMessage: state.potdList.error ?? '',
                ),
              _ when isSearching && filteredList.isEmpty =>
                const PictureOfTheDayEmptyWidget(),
              _ => RefreshIndicator(
                  onRefresh: () => _cubit.getPictureOfTheDayList(refresh: true),
                  child: PictureOfTheDayList(
                    images: listToDisplay,
                    onLoadMore: () =>
                        _cubit.getPictureOfTheDayList(loadMore: true),
                    isLoadMore: potdList.isLoadMore,
                    isDone: potdList.isDone,
                    canLoadMore: !potdList.isDone && !isSearching,
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
