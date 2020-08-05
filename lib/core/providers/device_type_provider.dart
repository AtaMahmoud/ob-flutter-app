import 'package:flutter/material.dart';

class DeviceTypeProvider extends ChangeNotifier{
  bool _isTablet = false;

  bool get isTablet => _isTablet;

  set isTablet(bool value) {
    _isTablet = value;
    notifyListeners();
  }

}