import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class GuestRequestValidationBloc extends Object with Validator
    implements BlocBase {

  var requestAccessTimeController = BehaviorSubject<String>();
  var requestAccessAsController = BehaviorSubject<String>();
  var permissionController = BehaviorSubject<String>();

  Stream<String> get requestAccessTime =>
      requestAccessTimeController.stream.transform(requestAccessForValidator);

  Function(String) get requestAccessTimeChanged =>
      requestAccessTimeController.sink.add;

  Stream<String> get requestAccessAs =>
      requestAccessAsController.stream.transform(requestAccessAsValidator);  

  Function(String) get requestAccessAsChanged =>
      requestAccessAsController.sink.add;   

  Stream<String> get permission => permissionController.stream;

  Function(String) get permissionChanged => permissionController.sink.add;         

  @override
  void dispose() {
    requestAccessTimeController.close();
    requestAccessAsController.close();
    permissionController.close();
  }
}
