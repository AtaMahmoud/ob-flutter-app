import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';

class ColorPickerDataProvider extends ChangeNotifier{
  Color _initialColor = Color(0xFF05649B);

  Color get initialColor => _initialColor;

  set initialColor(Color val){
    _initialColor = val;
    notifyListeners();
  }

}