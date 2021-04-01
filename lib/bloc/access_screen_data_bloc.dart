import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class AccessScreenDataBloc extends Object with Validator
    implements BlocBase {

  var accessTimeController = BehaviorSubject<String>();
  var accessAsController = BehaviorSubject<String>();
  var permissionController = BehaviorSubject<String>();

  Stream<String> get accessTime =>
      accessTimeController.stream;//.transform(requestAccessForValidator);

  Function(String) get accessTimeChanged =>
      accessTimeController.sink.add;

  Stream<String> get accessAs =>    accessAsController.stream;

  Function(String) get accessAsChanged => accessAsController.sink.add; 

  Stream<String> get permission => permissionController.stream;

  Function(String) get permissionChanged => permissionController.sink.add;

  @override
  void dispose() {
    accessTimeController.close();
    accessAsController.close();
    permissionController.close();
  }
}
