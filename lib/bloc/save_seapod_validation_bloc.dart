import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class SaveSeaPodValidationBloc extends Object
    with Validator
    implements BlocBase {
  var emailController = BehaviorSubject<String>();
  var seaPodNameController = BehaviorSubject<String>();

  Stream<String> get email => emailController.stream.transform(emailValidator);

  Stream<String> get seaPodName =>
      seaPodNameController.transform(seaPodNameValidator);

  Function(String) get emailChanged => emailController.sink.add;

  Function(String) get seaPodNameChanged => seaPodNameController.sink.add;

  Stream<bool> get loginCheck =>
      Rx.combineLatest2(email, seaPodName, (email, seaPodName) {
        print(' email $email');
        print('seapod name $seaPodName');
        return true;
      });

  @override
  void dispose() {
    emailController.close();
    seaPodNameController.close();
  }
}
