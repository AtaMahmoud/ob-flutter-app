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
      for(int i=0;i < _deviceObservationData.obs.length; i = i+12){
      
       var chunk = _deviceObservationData.obs.sublist(i,i+12<_deviceObservationData.obs.length ? i+12 : _deviceObservationData.obs.length);
        double sumAirTemp = 0.0;
        double sunmPressure = 0.0;
        double sumRelativeHumidity = 0.0;
        double sumRainAccumulation = 0.0;
        double sumWindAvg = 0.0;
        double sumWindGust = 0.0;
        double sumWindDirection = 0.0;
        double sumSolarRadiation = 0.0;
        double sumUvIndex = 0.0;

        int counter = 0;
      chunk.map((e){

        print(counter++);
      sumAirTemp = sumAirTemp + e.airTemperature.toDouble();
      sunmPressure = sunmPressure + e.pressure.toDouble();
      sumRelativeHumidity = sumRelativeHumidity + e.relativeHumidity.toDouble();
      sumRainAccumulation = sumRainAccumulation + e.rainAccumulation.toDouble();
      sumWindAvg = sumWindAvg + e.windAvg.toDouble();
      sumWindGust = sumWindGust + e.windGust.toDouble();
      sumWindDirection = sumWindDirection + e.windDirection.toDouble();
      sumSolarRadiation = sumSolarRadiation + e.solarRadiation.toDouble();
      sumUvIndex = sumUvIndex + e.unIndex.toDouble();

      }).toList();
      var avgAirTemp = sumAirTemp / chunk.length;
      var avgPressure = sunmPressure / chunk.length;
      var avgRltvHumidity = sumRelativeHumidity / chunk.length;
      var avgRainAccumulation = sumRainAccumulation / chunk.length;
      var avgWindAvg = sumWindAvg / chunk.length;
      var avgWindGust = sumWindGust / chunk.length;
      var avgWindDirection = sumWindDirection / chunk.length;
      var avgSolarRad = sumSolarRadiation / chunk.length;
      var avgUvIndex = sumUvIndex / chunk.length;

        DeviceObservation deviceObservation = _deviceObservationData.obs[i];
        HourData hourData = HourData();
        // debugPrint('-------------------------- device observation time ----- ${deviceObservation.epoch}');
        hourData.time = DateTime.fromMillisecondsSinceEpoch(deviceObservation.epoch.toInt()*1000).toIso8601String();

        // air temperature
        AttributeList attributeList = AttributeList();
        List<AtrributeData> attributeDataList = [];

        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgAirTemp));
        hourData.airTemperatureList = attributeList;

        // pressure
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgPressure));
        hourData.barometricPressureList = attributeList;

        // humidity
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgRltvHumidity));
        hourData.humidityList = attributeList;

        // precipitation
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgRainAccumulation));
        hourData.precipitationList = attributeList;

        // precipitation
        // attributeList = AttributeList();
        // attributeList.attributeDataList.add(AtrributeData(value: deviceObservation.));
        // hourData.seaLevelList = attributeList;

        // wind speed
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgWindAvg));
        hourData.windSpeedList = attributeList;

        // wind gust
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgWindGust));
        hourData.windGustList = attributeList;

        // wind direction
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgWindDirection));
        hourData.windDirectionList = attributeList;

        // solar radiation
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgSolarRad));
        hourData.solarRadiation = attributeList;

        // uv  index
        attributeList = AttributeList();
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgUvIndex));
        hourData.solarRadiation = attributeList;



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
