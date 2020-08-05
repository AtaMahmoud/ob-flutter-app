import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/fake_data.dart';

class FakeDataProvider extends ChangeNotifier{

  final _random = new Random();
  
  FakeData _fakeData = FakeData();

  FakeData get fakeData => _fakeData;

  set fakeData(FakeData val){

    _fakeData = val;
    notifyListeners();
  }

  fetchFakeData(){
    
    FakeData fakeData = FakeData();

    // normal temperature min 15 and max 30
    fakeData.insideTemperature = nextInt(15, 40);
    fakeData.drinkingWaterPercentage = nextInt(0, 101);
    fakeData.co2Percentage = nextInt(0, 101);
    fakeData.movementAngle = nextInt(0,151);
    fakeData.frostWindowsPercentage = nextInt(0, 101);
    fakeData.lowerStairsPercentage = nextInt(0, 101);
    fakeData.solarBatteryPercentage = nextInt(0, 101);
    fakeData.batteryPercentageWaterLeak = nextInt(0, 101);
    fakeData.batteryPercentageFireDetectors = nextInt(0, 101);
    fakeData.batteryPercentageC02 = nextInt(0, 101);

    _fakeData = fakeData;
    notifyListeners();

  }



int nextInt(int min, int max) => min + _random.nextInt(max - min);

double nextDouble(int min, int max) => min + _random.nextInt(max - min)+_random.nextDouble();


  Future<FakeData> getFakeData() async {
    return fakeData;
  }

}