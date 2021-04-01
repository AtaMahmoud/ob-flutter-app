import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class LightSceneBloc extends Object with Validator
    implements BlocBase {

  var lightSceneController = BehaviorSubject<String>();
  var lightRoomController = BehaviorSubject<String>();

  Stream<String> get lightScene =>
      lightSceneController.stream.transform(stringNonNullValidator);

  Function(String) get lightSceneChanged =>
      lightSceneController.sink.add;

  Stream<String> get lightRoom =>
      lightRoomController.stream.transform(stringNonNullValidator);

  Function(String) get lightRoomChanged =>
      lightRoomController.sink.add;

  @override
  void dispose() {
    lightSceneController.close();
    lightRoomController.close();
  }
}
