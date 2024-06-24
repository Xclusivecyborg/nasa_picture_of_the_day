import 'package:flutter/cupertino.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/view/picture_of_the_day_detail.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_card.dart';
import 'package:nasa_picture_of_the_day/general_widgets/infinite_scroller.dart';
import 'package:nasa_picture_of_the_day/general_widgets/spacing.dart';

class PictureOfTheDayList extends StatefulWidget {
  const PictureOfTheDayList({
    super.key,
    required this.images,
    required this.onLoadMore,
    required this.isLoadMore,
    required this.isDone,
    required this.canLoadMore,
  });

  final List<PictureOfTheDay> images;
  final void Function() onLoadMore;
  final bool isLoadMore;
  final bool isDone;
  final bool canLoadMore;

  @override
  State<PictureOfTheDayList> createState() => _PictureOfTheDayListState();
}

class _PictureOfTheDayListState extends State<PictureOfTheDayList> {
  late final ScrollController controller;
  double _currentIndexOffset = 0;

  late final height = MediaQuery.sizeOf(context).height;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleIndexListener();
    });
  }

  void _handleIndexListener() {
    controller.addListener(() {
      setState(() {});
      _currentIndexOffset = controller.offset / (height * .6);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InfiniteScroller(
      padding: const EdgeInsets.all(25),
      controller: controller,
      isLoadMore: widget.isLoadMore,
      canLoadMore: widget.canLoadMore,
      onLoadMore: widget.onLoadMore,
      separatorBuilder: (context, index) => const VSpacing(0),
      items: widget.images,
      itemBuilder: (context, index) {
        double value = (index - _currentIndexOffset);
        final item = (widget.images)[index];
        return GestureDetector(
          key: Key(item.date ?? ''),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) {
                  return PictureOfTheDayDetail(
                    image: item,
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: item.title ?? ' ',
            flightShuttleBuilder: (flightContext, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              final Hero toHero = toHeroContext.widget as Hero;
              return toHero.child;
            },
            child: SizedBox(
              height: height * .6,
              width: MediaQuery.sizeOf(context).width,
              child: PictureOfTheDayCard(
                image: item,
                value: value,
                key: ValueKey(item.date),
              ),
            ),
          ),
        );
      },
    );
  }
}
