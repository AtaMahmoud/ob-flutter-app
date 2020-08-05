import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class PermissionEditBloc extends Object with Validator
    implements BlocBase {

  var permissionEditController = BehaviorSubject<bool>();



  Observable<bool> get permissionEdited =>
      permissionEditController.stream;

  Function(bool) get permissionChanged => 
      permissionEditController.sink.add;

   

  @override
  void dispose() {
    permissionEditController.close();
  }
}
