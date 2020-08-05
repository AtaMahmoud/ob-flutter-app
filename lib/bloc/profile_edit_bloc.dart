import 'package:flutter/foundation.dart';
import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class ProfileEditBloc extends Object with Validator implements BlocBase {
  var profileInfoEditController = BehaviorSubject<bool>();
  var emergencyInfoController = BehaviorSubject<bool>();

  Observable<bool> get profileInfoEdited => profileInfoEditController.stream;

  Function(bool) get profileInfoChanged => profileInfoEditController.sink.add;

  Observable<bool> get emergencyInfoEdited => emergencyInfoController.stream;

  Function(bool) get emergencyInfoChanged => emergencyInfoController.sink.add;

  Observable<bool> get emergencyInfoCheck =>
      Observable.combineLatest2(profileInfoEdited, emergencyInfoEdited,
          (profileInfoEdited, emergencyInfoEdited) {
        debugPrint(
            '----------emergencyInfoCheck-------$emergencyInfoEdited--            profileInfoCheck ----------- $profileInfoEdited ');

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
