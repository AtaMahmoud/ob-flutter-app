import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';

class StormGlassRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  final Map<String, dynamic> _headers = {
    "Authorization": Config.STORM_GLASS_API_KEY,
  };

  //  2019-09-16T00:00:00+00:00

  Map<String, dynamic> _paramsToday = {
    'lat': '23.77400',
    'lng': '90.40364',
    //  'params':'airTemperature',
    'start': new DateTime.now()
        .subtract(Duration(hours: DateTime.now().hour + 1))
        .toIso8601String(), //new DateFormat("dd-MM-yyyy").format(new DateTime.now()),//'2019-09-16T00:00:00',
    'end': DateTime.now()
        .add(Duration(hours: 23 - DateTime.now().hour))
        .toIso8601String(), //'2019-09-16T23:00:00',
    'source': 'sg'
  };

  Map<String, dynamic> _params = {
    'lat': '23.77400',
    'lng': '90.40364',
    //  'params':'airTemperature,waterTemperature',
    'start': DateTime.now()
        .subtract(Duration(days: 7))
        .toIso8601String(), //'2019-09-17T00:00:00',
    'end': DateTime.now()
        .add(Duration(days: 7))
        .toIso8601String(), //'2019-09-17T23:00:00',
    'source': 'sg'
  };

  Map<String, dynamic> _paramsNext7Days = {
    'lat': '23.77400',
    'lng': '90.40364',
    //  'params':'airTemperature,waterTemperature',
    'start': new DateTime.now()
        .subtract(Duration(hours: DateTime.now().hour + 1))
        .toIso8601String(),
    'end': DateTime.now()
        .add(Duration(days: 7))
        .toIso8601String(), //'2019-09-17T23:00:00',
    'source': 'sg'
  };

  Map<String, dynamic> _paramsTide = {
    'lat': '23.77400',
    'lng': '90.40364',
    'start': DateTime.now()
        .subtract(Duration(days: 7))
        .toIso8601String(), //'2019-09-17T00:00:00',
    'end': DateTime.now()
        .add(Duration(days: 7))
        .toIso8601String(), //'2019-09-17T23:00:00',
  };

  Map<String, dynamic> _paramsUvIndex = {
    'lat': '23.77400',
    'lng': '90.40364',
    'start': DateTime.now()
        .subtract(Duration(days: 7))
        .toIso8601String(), //'2019-09-17T00:00:00',
    'end': DateTime.now()
        .add(Duration(days: 7))
        .toIso8601String(), //'2019-09-17T23:00:00',
  };

  setParams({
    String lat,
    String lng,
    String params,
    String startTime,
    String endTime,
  }) {
    _params = {
      'lat': lat,
      'lng': lng,
      'params': params,
      'start': startTime,
      'end': endTime,
    };
  }

  Future<StormGlassData> getWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WEATHER_DATA,
      parameters: _params,
      headers: _headers,
    );
    StormGlassData stormGlassData = StormGlassData.fromJson(response);
    print(stormGlassData.hours.length);
    return stormGlassData;
  }

  Future<StormGlassData> getTodayWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WEATHER_DATA,
      parameters: _paramsToday,
      headers: _headers,
    );
    StormGlassData stormGlassData = StormGlassData.fromJson(response);
    return stormGlassData;
  }

  Future<StormGlassData> getNext7DaysWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WEATHER_DATA,
      parameters: _paramsNext7Days,
      headers: _headers,
    );
    print(response);
    StormGlassData stormGlassData = StormGlassData.fromJson(response);
    return stormGlassData;
  }

  Future<TideData> getTideData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_TIDE_DATA,
      parameters: _paramsTide,
      headers: _headers,
    );
    print(response);
    TideData tideData = TideData.fromJson(response);
    print(tideData.extremas.length);
    return tideData;
  }

  Future<UvIndexData> getUvIndexWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_UVINDEX_DATA,
      parameters: _paramsUvIndex,
      headers: _headers,
    );
    print(response);
    UvIndexData uvIndexData = UvIndexData.fromJson(response);
    return uvIndexData;
  }
}
