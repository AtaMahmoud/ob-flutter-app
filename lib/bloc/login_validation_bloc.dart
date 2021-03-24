import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class LoginValidationBloc extends Object with Validator implements BlocBase {
  var emailController = BehaviorSubject<String>();
  var passwordController = BehaviorSubject<String>();
  var showPasswordController = BehaviorSubject<bool>();

  Stream<String> get email => emailController.stream.transform(emailValidator);

  Stream<String> get password =>
      passwordController.stream; //.transform(passwordValidator);

  Function(String) get emailChanged => emailController.sink.add;

  Function(String) get passwordChanged => passwordController.sink.add;

  Stream<bool> get showPassword => showPasswordController.stream;

  Stream<bool> get loginCheck =>
      Rx.combineLatest2(email, password, (email, password) {
        // // print('login email $email');
        // // print('login password $password');
        return true;
      });

  Stream<bool> get emailCheck => Rx.combineLatest([email], (email) {
        return true;
      });

  showPasswordChanged(bool show) => showPasswordController.sink.add(show);

  @override
  void dispose() {
    emailController.close();
    passwordController.close();
    showPasswordController.close();
  }
}
