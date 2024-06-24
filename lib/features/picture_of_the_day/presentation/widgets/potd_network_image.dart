import 'package:cached_network_image/cached_network_image.dart';

class PictureOfTheDayNetworkImage extends CachedNetworkImage {
  PictureOfTheDayNetworkImage({
    super.key,
    required super.imageUrl,
    super.fit,
    super.errorWidget,
    super.width,
    super.height,
  });
}
