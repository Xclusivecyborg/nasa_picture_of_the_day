// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:nasa_picture_of_the_day/core/utils/enums.dart';

class AsyncValue<T> extends Equatable {
  final T? value;
  final String? error;
  final LoadState loadState;

  const AsyncValue._({
    this.value,
    this.error,
    this.loadState = LoadState.initial,
  });

  factory AsyncValue.loading() =>
      const AsyncValue._(loadState: LoadState.loading);

  factory AsyncValue.data(T value) =>
      AsyncValue._(value: value, loadState: LoadState.success);

  factory AsyncValue.error(String error, [T? data]) =>
      AsyncValue._(error: error, loadState: LoadState.error, value: data);

  factory AsyncValue.initial() =>
      const AsyncValue._(loadState: LoadState.initial);

  factory AsyncValue.loadMore(T value) =>
      AsyncValue._(loadState: LoadState.loadMore, value: value);

  factory AsyncValue.done(T value) =>
      AsyncValue._(loadState: LoadState.done, value: value);

  bool get isLoading => loadState == LoadState.loading;

  bool get isLoadMore => loadState == LoadState.loadMore;

  bool get isInitial => loadState == LoadState.initial;

  bool get isSuccess => loadState == LoadState.success;

  bool get isError => loadState == LoadState.error;

  bool get isDone => loadState == LoadState.done;

  @override
  List<Object?> get props => [value, error, loadState];
}
