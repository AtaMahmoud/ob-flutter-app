import 'package:flutter/foundation.dart';
import 'package:ocean_builder/core/models/w_weather_o_data.dart';
import 'package:ocean_builder/core/repositories/wow_repository.dart';

class WOWDataProvider extends ChangeNotifier {
  WOWRepository _wowRepository = WOWRepository();

  WorldWeatherOnlineData _weatherData;
  WorldWeatherOnlineData get weatherData => _weatherData;

  Future<WorldWeatherOnlineData> fetchWeatherData() async {
    notifyListeners();
    WorldWeatherOnlineData weatherData = WorldWeatherOnlineData();
    try {
      final WorldWeatherOnlineData prev7DaysweatherData = await _wowRepository.getPrev7DaysWeatherData();
      // print(prev7DaysweatherData.data.weathers.length);

      final WorldWeatherOnlineData next7DaysweatherData = await _wowRepository.getNext7DaysWeatherData();
      // print(next7DaysweatherData.data.weathers.length);

      prev7DaysweatherData.data.weathers.addAll(next7DaysweatherData.data.weathers);

      
      weatherData = prev7DaysweatherData;

      // print(prev7DaysweatherData.data.weathers.length);
          
          
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      // print('error in fetchWeatherData');
      // print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }


    Future<WorldWeatherOnlineData> fetcLongTermhWeatherData() async {
    notifyListeners();
     WorldWeatherOnlineData weatherData = WorldWeatherOnlineData();
    try {
      final WorldWeatherOnlineData prev7DaysweatherData = await _wowRepository.getPrev7DaysWeatherData();
      // print(prev7DaysweatherData.data.weathers.length);

      final WorldWeatherOnlineData next7DaysweatherData = await _wowRepository.getNext7DaysWeatherData();
      // print(next7DaysweatherData.data.weathers.length);

      prev7DaysweatherData.data.weathers.addAll(next7DaysweatherData.data.weathers);

      
      weatherData = prev7DaysweatherData;

      // print(prev7DaysweatherData.data.weathers.length);
          
          
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      // print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }


  Future<WorldWeatherOnlineData> fetchMarineData() async {
    notifyListeners();
    WorldWeatherOnlineData weatherData = WorldWeatherOnlineData();
    try {
      final WorldWeatherOnlineData prev7DaysweatherData = await _wowRepository.getPrev1DaysMarineData();
      // print(prev7DaysweatherData.data.weathers.length);

      final WorldWeatherOnlineData next7DaysweatherData = await _wowRepository.getNext7DaysMarineData();
      // print(next7DaysweatherData.data.weathers.length);

      prev7DaysweatherData.data.weathers.addAll(next7DaysweatherData.data.weathers);

      
      weatherData = prev7DaysweatherData;

      // print(prev7DaysweatherData.data.weathers.length);
          
          
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      // print('error in geting marine data');
      // print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }

    Future<WorldWeatherOnlineData> fetchLongTermMarineData() async {
    notifyListeners();
    try {
      final WorldWeatherOnlineData prev7DaysweatherData = await _wowRepository.getPrev7DaysMarineData();
      // print(prev7DaysweatherData.data.weathers.length);

      final WorldWeatherOnlineData next7DaysweatherData = await _wowRepository.getNext7DaysMarineData();
      // print(next7DaysweatherData.data.weathers.length);

      prev7DaysweatherData.data.weathers.addAll(next7DaysweatherData.data.weathers);

      
      final WorldWeatherOnlineData weatherData = prev7DaysweatherData;

      // print(prev7DaysweatherData.data.weathers.length);
          
          
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      // print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }




  Future<WorldWeatherOnlineData> fetchTodayWeatherData() async {
    notifyListeners();
    WorldWeatherOnlineData weatherData = WorldWeatherOnlineData();
    try {
      weatherData = await _wowRepository.getTodayWeatherData();
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      // print('error in geting today weather data');
      // print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }

    Future<WorldWeatherOnlineData> fetchNext7DaysWeatherData() async {
    notifyListeners();
    WorldWeatherOnlineData weatherData = WorldWeatherOnlineData();
    try {
      weatherData = await _wowRepository.getNext7DaysWeatherData();
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      // print('error in fetching Next7DaysWeatherData');
      // print(e.toString());
      // print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }

}
