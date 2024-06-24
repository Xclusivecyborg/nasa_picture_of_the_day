import 'package:equatable/equatable.dart';
import 'package:nasa_picture_of_the_day/core/utils/enums.dart';

class PictureOfTheDay extends Equatable {
  const PictureOfTheDay({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
  });

  final String? copyright;
  final String? date;
  final String? explanation;
  final String? hdurl;
  final MediaType? mediaType;
  final String? serviceVersion;
  final String? title;
  final String? url;

  factory PictureOfTheDay.fromJson(Map<String, dynamic> json) {
    return PictureOfTheDay(
      copyright: json["copyright"],
      date: json["date"],
      explanation: json["explanation"],
      hdurl: json["hdurl"],
      mediaType: MediaType.fromString(json["media_type"]),
      serviceVersion: json["service_version"],
      title: json["title"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'copyright': copyright,
      'date': date,
      'explanation': explanation,
      'hdurl': hdurl,
      'media_type': mediaType,
      'service_version': serviceVersion,
      'title': title,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [
        copyright,
        date,
        explanation,
        hdurl,
        mediaType,
        serviceVersion,
        title,
        url,
      ];
}
