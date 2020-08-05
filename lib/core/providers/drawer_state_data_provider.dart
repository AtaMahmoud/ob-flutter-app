import 'package:flutter/material.dart';

class SwiperDataProvider extends ChangeNotifier{
  
  int _currentIndex = 0;

  int get currentScreenIndex => _currentIndex;

  set currentScreenIndex(int val){
    _currentIndex = val;
    notifyListeners();
  }

}