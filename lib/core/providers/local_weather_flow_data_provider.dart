import 'package:flutter/foundation.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
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
      debugPrint('device observation data -----  ${_deviceObservationData.obs.length}');
      StormGlassData stormGlassData = StormGlassData();
      List<HourData> hours = [];
      for(int i=0;i< _deviceObservationData.obs.length; i++){
        DeviceObservation deviceObservation = _deviceObservationData.obs[i];
        HourData hourData = HourData();
        hourData.time = DateTime.fromMillisecondsSinceEpoch(deviceObservation.epoch.toInt()).toIso8601String();

        // air temperature
        AttributeList attributeList = AttributeList();
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.airTemperature));
        hourData.airTemperatureList = attributeList;

        // pressure
        attributeList = AttributeList();
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.pressure));
        hourData.barometricPressureList = attributeList;

        // humidity
        attributeList = AttributeList();
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.relativeHumidity));
        hourData.humidityList = attributeList;

        // precipitation
        attributeList = AttributeList();
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.rainAccumulation));
        hourData.precipitationList = attributeList;

        // precipitation
        attributeList = AttributeList();
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.s));
        hourData.seaLevelList = attributeList;

      }

      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return deviceObservationData;
  }
}
