/// The class [NetworkRoutes] is an abstract class that contains all the
/// strings used for network requests in the app
/// The [NetworkRoutes] class was marked as final to prevent it from being extended or implemented
/// 
/// 
abstract final class NetworkRoutes {
  static const String baseUrl = 'https://api.nasa.gov';
  static const String apod = '/planetary/apod';
}
