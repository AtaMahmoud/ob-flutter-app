import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';

class DesignDataProvider extends ChangeNotifier{
  OceanBuilder _oceanBuilder = OceanBuilder();

  OceanBuilder get oceanBuilder => _oceanBuilder;

  set oceanBuilder(OceanBuilder val){
    _oceanBuilder = val;
    notifyListeners();
  }

}