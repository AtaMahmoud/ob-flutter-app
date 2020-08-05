import 'package:flutter/material.dart';

class SelectedOBIdProvider extends ChangeNotifier{
  String _obId = '';
  String _vesselCode = '';

  String get selectedObId => _obId;
  String get selectedVesselCode => _vesselCode;

  set selectedObId(String val){
    _obId = val;
    notifyListeners();
  }

  set selectedSeaPodVesselCode(String val){
    _vesselCode = val;
    notifyListeners();
  }

}