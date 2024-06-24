import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nasa_picture_of_the_day/core/utils/colors.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/presentation/widgets/potd_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PictureOfTheDayVideoPlayer extends StatefulWidget {
  const PictureOfTheDayVideoPlayer({
    super.key,
    required this.url,
    this.fullScreen = false,
  });
  final String url;
  final bool fullScreen;

  @override
  State<PictureOfTheDayVideoPlayer> createState() =>
      _PictureOfTheDayVideoPlayerState();
}

class _PictureOfTheDayVideoPlayerState
    extends State<PictureOfTheDayVideoPlayer> {
  late YoutubePlayerController _controller;
  void listener() {}
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  static String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.fullScreen
        ? Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: PictureOfTheDayNetworkImage(
                  imageUrl: getThumbnail(
                    videoId: YoutubePlayer.convertUrlToId(widget.url) ?? '',
                  ),
                  fit: BoxFit.cover,
                  height: 900,
                  width: 900,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: POTDColors.white,
                      blurRadius: 15,
                      spreadRadius: .1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow,
                  size: 60.h,
                  color: Colors.black,
                ),
              )
            ],
          )
        : Center(
            child: Stack(
            children: [
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
                onReady: () {
                  // _controller.addListener(listener);
                },
              ),
            ],
          ));
  }
}
