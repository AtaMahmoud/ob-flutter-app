import 'dart:async';

import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/helper/method_helper.dart';

mixin Validator {


  var stringNonNullValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name != null && name.length > 2 && name.length <= 30) sink.add(name);
    else
      sink.addError('Please enter a valid name');
  });

  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if ((email != null && email.length > 0) &&
        MethodHelper.isEmailValid(email)) sink.add(email);
    else
      sink.addError('Please enter a valid email address');
  });

  var phoneValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if ((phone != null && phone.length > 0 && MethodHelper.isPhoneValid(phone))) sink.add(phone);
    else
      sink.addError('Please enter a valid phone number');
  });

  var countryValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (country, sink) {
    if (country != null && country != ListHelper.getCountryList()[0])
      sink.add(country);
    else
      sink.addError('Please select a valid country');
  });

  var vasselCodeValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (code, sink) {
        if (code != null)//if (code != null && code.length == 4)
          sink.add(code);
        else
          sink.addError('Please enter a valid code');
      });
  
  var requestAccessAsValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (accessAs, sink) {
        if (accessAs != null && accessAs != ListHelper.getAccessAsList()[0])
          sink.add(accessAs);
        else
          sink.addError('Please select a valid option');
      });
  var requestAccessForValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (accessFor, sink) {
        if (accessFor != null && accessFor != ListHelper.getAccessTimeList()[0])
          sink.add(accessFor);
        else
          sink.addError('Please select a valid option');
      });

  /*
  ^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$
  Password must 
  - Have at least 8 characters - [First Word Should Be Capital and the last character should be a symbol] 
  - Contain characters from at least 3 of the following categories: 
  - English uppercase letters (A-Z) 
  - English lowercase letters (a-z) 
  - numbers (0-9) 
  - Non-alphanumeric symbols (e.g.: !, #, $, %, Space) 
  - Unicode characters
  */

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if ((password != null && MethodHelper.isPasswordValid(password)))
          {
            sink.add(password);
            
            }
        else
          sink.addError('Password must\n1. Have at least 8 characters\n2. Contain at least one characters from  each one of the following categories:\n   - English uppercase letters (A-Z)\n   - English lowercase letters (a-z)\n   - Numbers (0-9)\n3. Contain non-alphanumeric symbols (e.g.: !, #, \$, %, Space)');
      });


  var seaPodNameValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (seaPodName, sink) {
    if ((seaPodName != null && seaPodName.length > 0) && MethodHelper.isSeaPodNameAvailable(seaPodName)) 
       {
          sink.add(seaPodName);
       }
    else
      sink.addError('SeaPod name is not available');
  });

  
}
