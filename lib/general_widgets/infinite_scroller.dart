import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nasa_picture_of_the_day/general_widgets/app_loader.dart';
import 'package:nasa_picture_of_the_day/general_widgets/spacing.dart';

class InfiniteScroller extends StatefulWidget {
  const InfiniteScroller({
    required this.items,
    required this.onLoadMore,
    required this.isLoadMore,
    required this.canLoadMore,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.controller,
    this.padding,
    super.key,
  });
  final List<dynamic> items;
  final void Function() onLoadMore;
  final bool isLoadMore;
  final bool canLoadMore;
  final Widget? Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  @override
  State<InfiniteScroller> createState() => _InfiniteScrollerState();
}

class _InfiniteScrollerState extends State<InfiniteScroller> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0 &&
            widget.canLoadMore) {
          widget.onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        controller: widget.controller,
        padding: widget.padding,
        shrinkWrap: true,
        separatorBuilder: widget.separatorBuilder,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              widget.itemBuilder(context, index) ?? const SizedBox(),
              if (index == widget.items.length - 1 && widget.isLoadMore) ...[
                const VSpacing(20),
                const SafeArea(child: AppLoader()),
              ],
              if (index == widget.items.length - 1) const VSpacing(100),
            ],
          );
        },
      ),
    );
  }
}
