import 'package:nasa_picture_of_the_day/core/utils/enums.dart';
import 'package:nasa_picture_of_the_day/features/picture_of_the_day/data/models/picture_of_the_day.dart';

class MockData {
  static PictureOfTheDay get getMockPotd => const PictureOfTheDay(
        date: '2021-09-01',
        explanation: 'This is explanataion',
        hdurl: 'https://apod.nasa.gov/apod/image/2109/NGC6914_Hubble_960.jpg',
        mediaType: MediaType.image,
        serviceVersion: 'v1',
        title: 'NGC 6914: Cosmic Hubble Space Telescope View',
        url: 'https://apod.nasa.gov/apod/image/2109/NGC6914_Hubble_960.jpg',
        copyright: 'NASA',
      );

  static Map<String, dynamic> get getMockPotdMap => getMockPotd.toJson();

  static const startDate = '2021-08-01';
  static const endDate = '2021-08-02';
  static final mockResponse = [
    const PictureOfTheDay(
        date: '2021-08-01',
        explanation: 'explanation',
        hdurl: 'hdurl',
        mediaType: MediaType.image,
        serviceVersion: 'serviceVersion',
        title: 'title of image',
        url: 'url',
        copyright: 'copyright1'),
    const PictureOfTheDay(
        mediaType: MediaType.video,
        date: '2021-08-02',
        explanation: 'explanation',
        hdurl: 'hdurl',
        serviceVersion: 'serviceVersion',
        title: 'This one is a video',
        url: 'url',
        copyright: 'copyright2'),
  ];

  static final mockResponse2 = [
    const PictureOfTheDay(
        date: '2021-08-03',
        explanation: 'explanation3',
        hdurl: 'hdurl3',
        mediaType: MediaType.image,
        serviceVersion: 'serviceVersion3',
        title: 'title3',
        url: 'url3',
        copyright: 'copyright3'),
    const PictureOfTheDay(
        mediaType: MediaType.video,
        date: '2021-08-04',
        explanation: 'explanation2',
        hdurl: 'hdurl4',
        serviceVersion: 'serviceVersion4',
        title: 'title4',
        url: 'url4',
        copyright: 'copyright4'),
  ];
}
