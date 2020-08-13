import 'package:flutter/foundation.dart';
import 'package:ocean_builder/core/models/weather_flow_data.dart';
import 'package:ocean_builder/core/models/weather_flow_device_observation.dart';
import 'package:ocean_builder/core/repositories/local_weather_data_repository.dart';

class LocalWeatherDataProvider extends ChangeNotifier {
  LocalWeatherDataRepository _localWeatherDataRepository =
      LocalWeatherDataRepository();

  WeatherFlowData _localweatherData;
  WeatherFlowData get weatherData => _localweatherData;

  WeatherFlowDeviceObservationData _deviceObservationData;
  WeatherFlowDeviceObservationData get deviceObservationData => _deviceObservationData;

  Future<WeatherFlowData> fetchStationObservationData() async {
    notifyListeners();
    try {
      final WeatherFlowData weatherData =
          await _localWeatherDataRepository.getStationObservationData();
      _localweatherData = weatherData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return weatherData;
  }

    Future<WeatherFlowDeviceObservationData> fetchDeviceObservationData() async {
    notifyListeners();
    try {
      final WeatherFlowDeviceObservationData deviceObservationData =
          await _localWeatherDataRepository.getDeviceObservationData();
      _deviceObservationData = deviceObservationData;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return deviceObservationData;
  }
}
