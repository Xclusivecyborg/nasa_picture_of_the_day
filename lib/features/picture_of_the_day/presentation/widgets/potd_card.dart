import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasa_picture_of_the_day/core/utils/colors.dart';
import 'package:nasa_picture_of_the_day/core/utils/enums.dart';
import 'package:nasa_picture_of_the_day/core/utils/extensions/extensions.dart';
import 'package:nasa_picture_of_the_day/core/utils/theme/text_theme.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_network_image.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_video_player.dart';
import 'package:nasa_picture_of_the_day/general_widgets/spacing.dart';

class PictureOfTheDayCard extends StatelessWidget {
  const PictureOfTheDayCard({
    super.key,
    required this.image,
    required this.value,
  });

  final PictureOfTheDay image;
  final double value;

  @override
  Widget build(BuildContext context) {
    final scale = 1 - ((value).abs() * .15);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: POTDColors.white.withOpacity(.5),
                  blurRadius: 15,
                  spreadRadius: .1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Transform.scale(
                    scale: scale * 1.2,
                    child: switch (image.mediaType) {
                      MediaType.video => PictureOfTheDayVideoPlayer(
                          url: image.url ?? '',
                        ),
                      _ => PictureOfTheDayNetworkImage(
                          imageUrl: image.url ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              image.title ?? '',
                              style: context.textTheme.s25w500,
                            ),
                          ),
                          const VSpacing(10),
                          POTDDate(image: image)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class POTDDate extends StatelessWidget {
  const POTDDate({
    super.key,
    required this.image,
  });
  final PictureOfTheDay image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          CupertinoIcons.calendar_today,
          color: POTDColors.white,
        ),
        const HSpacing(10),
        Material(
          color: Colors.transparent,
          child: Text(
            image.date?.toNiceDate ?? '',
            style: context.textTheme.s14w400,
          ),
        ),
      ],
    );
  }
}
