import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';

class SmartHomeConfigBloc extends Object implements BlocBase {
  var mqttServerController = BehaviorSubject<String>();
  Stream<String> get mqttServer => mqttServerController.stream;
  Function(String) get mqttServerChanged => mqttServerController.sink.add;

  var mqttPortController = BehaviorSubject<String>();
  Stream<String> get mqttPort => mqttPortController.stream;
  Function(String) get mqttPortChanged => mqttPortController.sink.add;

  var mqttIdentifierController = BehaviorSubject<String>();
  Stream<String> get mqttIdentifier => mqttIdentifierController.stream;
  Function(String) get mqttIdentifierChanged =>
      mqttIdentifierController.sink.add;

  var mqttUserController = BehaviorSubject<String>();
  Stream<String> get mqttUser => mqttUserController.stream;
  Function(String) get mqttUserChanged => mqttUserController.sink.add;

  var mqttPasswordController = BehaviorSubject<String>();
  Stream<String> get mqttPassword => mqttPasswordController.stream;
  Function(String) get mqttPasswordChanged => mqttPasswordController.sink.add;

  var mqttTopicController = BehaviorSubject<String>();
  Stream<String> get mqttTopic => mqttTopicController.stream;
  Function(String) get mqttTopicChanged => mqttTopicController.sink.add;

  @override
  void dispose() {
    mqttServerController.close();
    mqttPortController.close();
    mqttIdentifierController.close();
    mqttUserController.close();
    mqttPasswordController.close();
    mqttTopicController.close();
  }
}
