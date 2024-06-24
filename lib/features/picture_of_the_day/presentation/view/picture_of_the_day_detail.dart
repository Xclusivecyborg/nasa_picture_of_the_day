import 'package:flutter/material.dart';
import 'package:nasa_picture_of_the_day/core/utils/colors.dart';
import 'package:nasa_picture_of_the_day/core/utils/enums.dart';
import 'package:nasa_picture_of_the_day/core/utils/strings.dart';
import 'package:nasa_picture_of_the_day/core/utils/theme/text_theme.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_card.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_network_image.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_video_player.dart';
import 'package:nasa_picture_of_the_day/general_widgets/spacing.dart';

class PictureOfTheDayDetail extends StatefulWidget {
  const PictureOfTheDayDetail({super.key, required this.image});
  final PictureOfTheDay image;

  @override
  State<PictureOfTheDayDetail> createState() => _PictureOfTheDayDetailState();
}

class _PictureOfTheDayDetailState extends State<PictureOfTheDayDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: POTDColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  Text(
                    Strings.back,
                    style: context.textTheme.s25w500,
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: widget.image.title ?? '',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Transform.scale(
                            scale: 1,
                            child: widget.image.mediaType == MediaType.video
                                ? PictureOfTheDayVideoPlayer(
                                    url: widget.image.url ?? '',
                                    fullScreen: true,
                                  )
                                : PictureOfTheDayNetworkImage(
                                    fit: BoxFit.fill,
                                    width: MediaQuery.sizeOf(context).width,
                                    imageUrl: widget.image.url ?? '',
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VSpacing(30),
                          Text(
                            widget.image.title ?? '',
                            style: context.textTheme.s25w500,
                          ),
                          POTDDate(image: widget.image),
                          const VSpacing(20),
                          Text(
                            widget.image.explanation ?? '',
                            style: context.textTheme.s14w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
