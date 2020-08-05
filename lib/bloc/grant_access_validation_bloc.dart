import 'package:ocean_builder/mixins/validator.dart';

import 'bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class GrantAccessValidationBloc extends Object
    with Validator
    implements BlocBase {
  var firstNameController = BehaviorSubject<String>();
  var emailController = BehaviorSubject<String>();
  var vasselCodeController = BehaviorSubject<String>();
  var requestAccessAsController = BehaviorSubject<String>();
  var requestAccessTimeController = BehaviorSubject<String>();
  var checkInController = BehaviorSubject<String>();
  var messageController = BehaviorSubject<String>();
  var permissionController = BehaviorSubject<String>();

  Observable<String> get firstName =>
      firstNameController.stream.transform(stringNonNullValidator);

  Observable<String> get email =>
      emailController.stream.transform(emailValidator);

  Observable<String> get vasselCode =>
      vasselCodeController.stream.transform(vasselCodeValidator);

  Observable<String> get requestAccessAs =>
      requestAccessAsController.stream.transform(requestAccessAsValidator);

  Observable<String> get requestAccessTime =>
      requestAccessTimeController.stream.transform(requestAccessForValidator);

  Observable<String> get checkIn =>
      checkInController.stream.transform(stringNonNullValidator);

  Observable<String> get message => messageController.stream.transform(stringNonNullValidator);    

  Function(String) get firstNameChanged => firstNameController.sink.add;

  Function(String) get emailChanged => emailController.sink.add;

  Function(String) get vasselCodeChanged => vasselCodeController.sink.add;

  Function(String) get requestAccessAsChanged =>
      requestAccessAsController.sink.add;

  Function(String) get requestAccessTimeChanged =>
      requestAccessTimeController.sink.add;

  Function(String) get checkInChanged => checkInController.sink.add;

  Function(String) get messageChanged => messageController.sink.add;

  Observable<bool> get registrationCheck =>
      Observable.combineLatest2(firstName, email, (firstName, email) => true);

  Observable<String> get permission => permissionController.stream;

  Function(String) get permissionChanged => permissionController.sink.add;    

  Observable<bool> get requestAccessCheck => Observable.combineLatest4(
      requestAccessAs,
      requestAccessTime,
      vasselCode,
      checkIn,
      (requestAccessAs, requestAccessTime, vasselCode, checkIn) => true);

  @override
  void dispose() {
    firstNameController.close();
    emailController.close();
    vasselCodeController.close();
    requestAccessAsController.close();
    requestAccessTimeController.close();
    checkInController?.close();
    messageController?.close();
    permissionController?.close();
  }
}
