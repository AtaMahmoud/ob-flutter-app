import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class SmartHomeConfigBloc extends Object implements BlocBase {
  var mqttServerController = BehaviorSubject<String>();

  Observable<String> get mqttServer => mqttServerController.stream;

  Function(String) get mqttServerChanged => mqttServerController.sink.add;

  @override
  void dispose() {
    mqttServerController.close();
  }
}
