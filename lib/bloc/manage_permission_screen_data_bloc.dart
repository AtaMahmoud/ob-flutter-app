import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class ManagePermissionScreenDataBloc extends Object with Validator
    implements BlocBase {

  var selectedSeapodController = BehaviorSubject<String>();

  Stream<String> get selectedSeaPodId =>
      selectedSeapodController.stream;//.transform(requestAccessForValidator);

  Function(String) get selectedSeaPodIdChanged =>
      selectedSeapodController.sink.add;


  @override
  void dispose() {
    selectedSeapodController.close();
  }
}
