import 'package:ocean_builder/mixins/validator.dart';

import 'bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class RegistrationValidationBloc extends Object
    with Validator
    implements BlocBase {
  var firstNameController = BehaviorSubject<String>();
  var lastNameController = BehaviorSubject<String>();
  var emailController = BehaviorSubject<String>();
  var phoneController = BehaviorSubject<String>();
  var countryController = BehaviorSubject<String>();
  var vasselCodeController = BehaviorSubject<String>();
  var requestAccessAsController = BehaviorSubject<String>();
  var requestAccessTimeController = BehaviorSubject<String>();
  var checkInController = BehaviorSubject<String>();

  Observable<String> get firstName =>
      firstNameController.stream.transform(stringNonNullValidator);

  Observable<String> get lastName =>
      lastNameController.stream.transform(stringNonNullValidator);

  Observable<String> get email =>
      emailController.stream.transform(emailValidator);

  Observable<String> get phone =>
      phoneController.stream.transform(phoneValidator);

  Observable<String> get country =>
      countryController.stream.transform(countryValidator);

  Observable<String> get vasselCode =>
      vasselCodeController.stream.transform(vasselCodeValidator);

  Observable<String> get requestAccessAs =>
      requestAccessAsController.stream.transform(requestAccessAsValidator);

  Observable<String> get requestAccessTime =>
      requestAccessTimeController.stream.transform(requestAccessForValidator);

  Observable<String> get checkIn =>
      checkInController.stream.transform(stringNonNullValidator);

  Function(String) get firstNameChanged => firstNameController.sink.add;

  Function(String) get lastNameChanged => lastNameController.sink.add;

  Function(String) get emailChanged => emailController.sink.add;

  Function(String) get phoneChanged => phoneController.sink.add;

  Function(String) get countryChanged => countryController.sink.add;

  Function(String) get vasselCodeChanged => vasselCodeController.sink.add;

  Function(String) get requestAccessAsChanged =>
      requestAccessAsController.sink.add;

  Function(String) get requestAccessTimeChanged =>
      requestAccessTimeController.sink.add;

  Function(String) get checkInChanged => checkInController.sink.add;

  Observable<bool> get registrationCheck => Observable.combineLatest5(
      firstName,
      lastName,
      email,
      phone,
      country,
      (firstName, lastName, email, phone, country) => true);

  Observable<bool> get invitationRegistrationCheck => Observable.combineLatest4(
      firstName,
      lastName,
      phone,
      country,
      (firstName, lastName, phone, country) => true);

  Observable<bool> get editProfileInputCheck =>
      Observable.combineLatest4(firstName, lastName, email, phone,
          (firstName, lastName, email, phone) {
        return true;
      });

  Observable<bool> get requestAccessCheck => Observable.combineLatest3(
      requestAccessAs,
      vasselCode,
      checkIn,
      (requestAccessAs, vasselCode, checkIn) => true);

  Observable<bool> get requestAccessCheckWithAccesstime =>
      Observable.combineLatest4(
          requestAccessAs,
          vasselCode,
          requestAccessTime,
          checkIn,
          (requestAccessAs, vasselCode, requestAccessTime, checkIn) => true);

  Observable<bool> get acceptInvitationCheck =>
      vasselCode.isEmpty.asObservable();

  Observable<bool> get infoCheck =>
      Observable.combineLatest5(firstName, lastName, email, phone, country,
          (firstName, lastName, email, phone, country) {
        // // print(firstName);
        // // print(lastName);
        // // print(email);
        // // print(phone.length);
        // // print(country);
        return true;
      });

  Observable<bool> get profileCheck =>
      Observable.combineLatest4(firstName, lastName, email, phone,
          (firstName, lastName, email, phone) {
        // // print(firstName);
        // // print(lastName);
        // // print(email);
        // // print(phone.length);
        // // print(country);
        return true;
      });

  @override
  void dispose() {
    firstNameController.close();
    lastNameController.close();
    emailController.close();
    phoneController.close();
    countryController.close();
    vasselCodeController.close();
    requestAccessAsController.close();
    requestAccessTimeController.close();
    checkInController?.close();
  }
}
