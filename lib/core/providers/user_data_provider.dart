import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/user.dart';

class UserDataProvider extends ChangeNotifier{
  User _user = User();

  User get user => _user;

  set user(User val){
    _user = val;
    notifyListeners();
  }

}