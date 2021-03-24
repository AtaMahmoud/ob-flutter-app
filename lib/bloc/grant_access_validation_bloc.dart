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

  Stream<String> get firstName =>
      firstNameController.stream.transform(stringNonNullValidator);

  Stream<String> get email => emailController.stream.transform(emailValidator);

  Stream<String> get vasselCode =>
      vasselCodeController.stream.transform(vasselCodeValidator);

  Stream<String> get requestAccessAs =>
      requestAccessAsController.stream.transform(requestAccessAsValidator);

  Stream<String> get requestAccessTime =>
      requestAccessTimeController.stream.transform(requestAccessForValidator);

  Stream<String> get checkIn =>
      checkInController.stream.transform(stringNonNullValidator);

  Stream<String> get message =>
      messageController.stream.transform(stringNonNullValidator);

  Function(String) get firstNameChanged => firstNameController.sink.add;

  Function(String) get emailChanged => emailController.sink.add;

  Function(String) get vasselCodeChanged => vasselCodeController.sink.add;

  Function(String) get requestAccessAsChanged =>
      requestAccessAsController.sink.add;

  Function(String) get requestAccessTimeChanged =>
      requestAccessTimeController.sink.add;

  Function(String) get checkInChanged => checkInController.sink.add;

  Function(String) get messageChanged => messageController.sink.add;

  Stream<bool> get registrationCheck =>
      Rx.combineLatest2(firstName, email, (firstName, email) => true);

  Stream<String> get permission => permissionController.stream;

  Function(String) get permissionChanged => permissionController.sink.add;

  Stream<bool> get requestAccessCheck => Rx.combineLatest4(
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
