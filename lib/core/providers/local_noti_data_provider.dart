import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/local_noti_data.dart';

class LocalNotiDataProvider extends ChangeNotifier{
  
  LocalNotification _localNotification = LocalNotification();

  LocalNotification get localNotification => _localNotification;

  set localNotification(LocalNotification val){
    _localNotification = val;
    notifyListeners();
  }

}