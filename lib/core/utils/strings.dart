/// The class [Strings] is an abstract class that contains all the strings used in the app
/// All strings are arranged in alphabetical order
/// The [Strings] class was marked as final to prevent it from being extended or implemented
abstract final class Strings {
  static const String apiKey = 'API_KEY';
  static const String back = 'Back';
  static const String genericError =
      'Something went wrong. Please try again later.';
  static const String noInternet =
      'No internet connection. Please check your connection and try again.';
  static const String potdTitle = 'NASA Picture of the Day';

  static const String resultWillAppearHere = 'Results will appear here';
  static const String searchHint = 'Search by title or date e.g 01 June 2024';
  static const String serverError = 'A server error occurred';
  static const String timeOut = 'Request timed out. Please try again later.';
}
