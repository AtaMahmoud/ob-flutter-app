import 'package:flutter/foundation.dart';
import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class ProfileEditBloc extends Object with Validator implements BlocBase {
  var profileInfoEditController = BehaviorSubject<bool>();
  var emergencyInfoController = BehaviorSubject<bool>();

  Stream<bool> get profileInfoEdited => profileInfoEditController.stream;

  Function(bool) get profileInfoChanged => profileInfoEditController.sink.add;

  Stream<bool> get emergencyInfoEdited => emergencyInfoController.stream;

  Function(bool) get emergencyInfoChanged => emergencyInfoController.sink.add;

  Stream<bool> get emergencyInfoCheck =>
      Rx.combineLatest2(profileInfoEdited, emergencyInfoEdited,
          (profileInfoEdited, emergencyInfoEdited) {
        if (profileInfoEdited == true || emergencyInfoEdited == true)
          return true;
        else
          return false;
      });

  @override
  void dispose() {
    profileInfoEditController.close();
    emergencyInfoController.close();
  }
}
