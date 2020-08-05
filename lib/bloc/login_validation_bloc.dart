import 'package:ocean_builder/mixins/validator.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class LoginValidationBloc extends Object with Validator implements BlocBase {
  var emailController = BehaviorSubject<String>();
  var passwordController = BehaviorSubject<String>();
  var showPasswordController = BehaviorSubject<bool>();

  Observable<String> get email =>
      emailController.stream.transform(emailValidator);

  Observable<String> get password => passwordController.stream;//.transform(passwordValidator);

  Function(String) get emailChanged => emailController.sink.add;

  Function(String) get passwordChanged => passwordController.sink.add;

  Observable<bool> get showPassword => showPasswordController.stream;

  Observable<bool> get loginCheck =>
      Observable.combineLatest2(email, password, (email, password){
        // // print('login email $email');
        // // print('login password $password');
        return true;
      });

  Observable<bool> get emailCheck => Observable.combineLatest([email], (email){return true;});    

  showPasswordChanged(bool show) => showPasswordController.sink.add(show);

  @override
  void dispose() {
    emailController.close();
    passwordController.close();
    showPasswordController.close();
  }
}
