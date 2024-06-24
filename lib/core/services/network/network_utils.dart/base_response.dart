/// Base response typedef for all API responses
/// This harnesses the power of Dart records
typedef BaseResponse<T> = ({bool status, T? data, String message});
