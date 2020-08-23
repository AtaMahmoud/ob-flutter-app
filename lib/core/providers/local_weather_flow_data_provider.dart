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
  WeatherFlowDeviceObservationData get deviceObservationData =>
      _deviceObservationData;

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
      List<HourData> hours = [];
      for (int i = 0; i < _deviceObservationData.obs.length; i = i + 12) {
        var chunk = _deviceObservationData.obs.sublist(
            i,
            i + 12 < _deviceObservationData.obs.length
                ? i + 12
                : _deviceObservationData.obs.length);
        double sumAirTemp = 0.0;
        double sunmPressure = 0.0;
        double sumRelativeHumidity = 0.0;
        double sumRainAccumulation = 0.0;
        double sumWindAvg = 0.0;
        double sumWindGust = 0.0;
        double sumWindDirection = 0.0;
        double sumSolarRadiation = 0.0;
        double sumUvIndex = 0.0;

        chunk.map((e) {
          sumAirTemp = sumAirTemp + e.airTemperature.toDouble();
          sunmPressure = sunmPressure + e.pressure.toDouble();
          sumRelativeHumidity =
              sumRelativeHumidity + e.relativeHumidity.toDouble();
          sumRainAccumulation =
              sumRainAccumulation + e.rainAccumulation.toDouble();
          sumWindAvg = sumWindAvg + e.windAvg.toDouble();
          sumWindGust = sumWindGust + e.windGust.toDouble();
          sumWindDirection = sumWindDirection + e.windDirection.toDouble();
          sumSolarRadiation = sumSolarRadiation + e.solarRadiation.toDouble();
          sumUvIndex = sumUvIndex + e.unIndex.toDouble();
        }).toList();
        var avgAirTemp =
            double.parse((sumAirTemp / chunk.length).toStringAsFixed(2));
        var avgPressure =
            double.parse((sunmPressure / chunk.length).toStringAsFixed(2));
        var avgRltvHumidity = double.parse(
            (sumRelativeHumidity / chunk.length).toStringAsFixed(2));
        var avgRainAccumulation = double.parse(
            (sumRainAccumulation / chunk.length).toStringAsFixed(2));
        var avgWindAvg =
            double.parse((sumWindAvg / chunk.length).toStringAsFixed(2));
        var avgWindGust =
            double.parse((sumWindGust / chunk.length).toStringAsFixed(2));
        var avgWindDirection =
            double.parse((sumWindDirection / chunk.length).toStringAsFixed(2));
        var avgSolarRad =
            double.parse((sumSolarRadiation / chunk.length).toStringAsFixed(2));
        var avgUvIndex =
            double.parse((sumUvIndex / chunk.length).toStringAsFixed(2));

        DeviceObservation deviceObservation = _deviceObservationData.obs[i];
        HourData hourData = HourData();
        hourData.time = DateTime.fromMillisecondsSinceEpoch(
                deviceObservation.epoch.toInt() * 1000)
            .toIso8601String();

        // air temperature
        AttributeList attributeList = AttributeList();
        List<AtrributeData> attributeDataList = [];

        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgAirTemp));
        hourData.airTemperatureList = attributeList;

        // pressure
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgPressure));
        hourData.barometricPressureList = attributeList;

        // humidity
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList
            .add(AtrributeData(value: avgRltvHumidity));
        hourData.humidityList = attributeList;

        // precipitation
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList
            .add(AtrributeData(value: avgRainAccumulation));
        hourData.precipitationList = attributeList;

        // wind speed
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgWindAvg));
        hourData.windSpeedList = attributeList;

        // wind gust
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgWindGust));
        hourData.windGustList = attributeList;

        // wind direction
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList
            .add(AtrributeData(value: avgWindDirection));
        hourData.windDirectionList = attributeList;

        // solar radiation
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgSolarRad));
        hourData.solarRadiation = attributeList;

        // uv  index
        attributeList = AttributeList();
        attributeDataList = [];
        attributeList.attributeDataList = attributeDataList;
        attributeList.attributeDataList.add(AtrributeData(value: avgUvIndex));
        hourData.unIndex = attributeList;

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
