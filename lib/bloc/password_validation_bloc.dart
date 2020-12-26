import 'package:ocean_builder/mixins/validator.dart';
import 'bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class PasswordValidationBloc extends Object with Validator implements BlocBase {
  var passwordController = BehaviorSubject<String>();
  var confirmPasswordController = BehaviorSubject<String>();
  var showPasswordController = BehaviorSubject<bool>();
  var showConfirmPasswordController = BehaviorSubject<bool>();

  late String pass;

  Observable<String> get password => passwordController.stream.transform(passwordValidator);

  Observable<String> get confirmPassword => confirmPasswordController.stream.transform(passwordValidator);

  Observable<bool> get showPassword => showPasswordController.stream;

  Observable<bool> get showConfirmPassword =>
      showConfirmPasswordController.stream;

  passwordChanged(String password) {
    pass = password;
    passwordController.sink.add(password);
  }

  confirmPasswordChanged(String confirmPassword) {
     confirmPasswordController.sink.add(confirmPassword);
     if(confirmPassword.length >= 8){

      if (confirmPassword == pass) {
        confirmPasswordController.sink.add(confirmPassword);
      } else {
        confirmPasswordController.sink.addError('Passwords did\'t match!');
      }
      
     }
    
  }

  showPasswordChanged(bool show) => showPasswordController.sink.add(show);

  showConfirmPasswordChanged(bool show) =>
      showConfirmPasswordController.sink.add(show);

  Observable<bool> get passwordCheck => Observable.combineLatest2(
      password,
      confirmPassword,
      (password, confirmPassword) => password == confirmPassword);

  @override
  void dispose() {
    passwordController.close();
    confirmPasswordController.close();
    showConfirmPasswordController.close();
    showPasswordController.close();
  }
}
