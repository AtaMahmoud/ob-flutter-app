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

    Future<StormGlassData> fetchDeviceObservationData() async {
    notifyListeners();
     StormGlassData stormGlassData = StormGlassData();
    try {
      final WeatherFlowDeviceObservationData deviceObservationData =
          await _localWeatherDataRepository.getDeviceObservationData();
      _deviceObservationData = deviceObservationData;
      debugPrint('device observation data -----  ${_deviceObservationData.obs.length}');
     
      List<HourData> hours = [];
      for(int i=0;i< _deviceObservationData.obs.length; i++){
        DeviceObservation deviceObservation = _deviceObservationData.obs[i];
        HourData hourData = HourData();

        hourData.time = DateTime.fromMillisecondsSinceEpoch(deviceObservation.epoch.toInt()).toIso8601String();

        // air temperature
        AttributeList attributeList = AttributeList();
        List<AtrributeData> attributeDataList = [];

        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.airTemperature.toDouble()));
        hourData.airTemperatureList = attributeList;

        // pressure
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.pressure.toDouble()));
        hourData.barometricPressureList = attributeList;

        // humidity
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.relativeHumidity.toDouble()));
        hourData.humidityList = attributeList;

        // precipitation
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.rainAccumulation.toDouble()));
        hourData.precipitationList = attributeList;

        // precipitation
        // attributeList = AttributeList();
        // attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.));
        // hourData.seaLevelList = attributeList;

        // wind speed
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.windAvg.toDouble()));
        hourData.windSpeedList = attributeList;

        // wind gust
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.windGust.toDouble()));
        hourData.windGustList = attributeList;

        // wind direction
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.windDirection.toDouble()));
        hourData.windDirectionList = attributeList;

        // wind direction
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.windDirection.toDouble()));
        hourData.windDirectionList = attributeList;

        //feels like
        // attributeList = AttributeList();
        // attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.));
        // hourData. = attributeList;

        // wave height -- missing
        // water temperature -- missing
        // visibility -- missing
        // significant wave -- missing
        // swell height -- missing 
        // swell direciton
        // swell period
        // tides 
        hours.add(hourData);

      }
      stormGlassData.hours = hours;

      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return stormGlassData;
  }
}
