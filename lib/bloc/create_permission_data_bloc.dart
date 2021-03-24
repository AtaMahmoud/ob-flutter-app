import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class CreatePermissionDataBloc extends Object with Validator
    implements BlocBase {

  var permissionSetNameController = BehaviorSubject<String>();

  Stream<String> get permissionSetName =>
      permissionSetNameController.stream;//.transform(requestAccessForValidator);

  Function(String) get permissionSetNameChanged =>
      permissionSetNameController.sink.add;


  @override
  void dispose() {
    permissionSetNameController.close();
  }
}
