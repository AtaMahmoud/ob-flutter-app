import 'package:flutter/material.dart';

class QrCodeDataProvider extends ChangeNotifier{
  String _qrCodeData = '';

  String get qrCodeData => _qrCodeData;

  set qrCodeData(String val){
    _qrCodeData = val;
    notifyListeners();
  }

}