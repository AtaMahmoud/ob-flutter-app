import 'package:flutter/foundation.dart';
import 'package:ocean_builder/core/models/weather_flow_data.dart';
import 'package:ocean_builder/core/repositories/local_weather_data_repository.dart';

class LocalWeatherDataProvider extends ChangeNotifier {
  LocalWeatherDataRepository _stormGlassRepository =
      LocalWeatherDataRepository();

  WeatherFlowData _weatherData;
  WeatherFlowData get weatherData => _weatherData;

  Future<WeatherFlowData> fetchStationObservationData() async {
    notifyListeners();
    try {
      final WeatherFlowData weatherData =
          await _stormGlassRepository.getStationObservationData();
      _weatherData = weatherData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }
}
