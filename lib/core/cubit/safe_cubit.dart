
import 'package:bloc/bloc.dart';

class SafeCubit<T> extends Cubit<T> {
  SafeCubit(super.state);

  @override
  void emit(T state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}