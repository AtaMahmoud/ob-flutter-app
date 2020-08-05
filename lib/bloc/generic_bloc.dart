import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class GenericBloc<T> implements BlocBase {
  var controller = BehaviorSubject<T>();

  Observable<T> get stream => controller.stream;

  StreamSink<T> get sink => controller.sink;

  GenericBloc(T data) {
    sink.add(data);
  }

  @override
  void dispose() {
    controller.close();
  }
}
