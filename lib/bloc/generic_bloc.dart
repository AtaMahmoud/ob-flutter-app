import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class GenericBloc<T> implements BlocBase {
  var controller = BehaviorSubject<T>();

  StreamTransformer<T, T> streamTransformer;
  //  =
  //     StreamTransformer<T, T>.fromHandlers(
  //   handleData: (data, sink) {
  //     sink.add(data);
  //   },
  // );

  // Observable<T> get stream => controller.stream;

  Observable<T> get stream {
    if (streamTransformer != null) {
      return controller.stream.transform(streamTransformer);
    } else {
      return controller.stream;
    }
  }

  StreamSink<T> get sink => controller.sink;

  Function(T) get changed => controller.sink.add;

  GenericBloc.named(StreamTransformer streamTransformer) {
    this.streamTransformer = streamTransformer;
  }

  GenericBloc(T data) {
    sink.add(data);
  }

  @override
  void dispose() {
    controller.close();
  }

  void setStreamTransformer(strTrnsfrmr) {
    this.streamTransformer = strTrnsfrmr;
  }
}
