
import 'package:flutter/material.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/w_weather_o_data.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:intl/intl.dart';

class WOWRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  // final Map<String, dynamic> _headers = {
  //    "Authorization": Config.WORLD_WEATHER_ONLINE_API_KEY,
  // };

  //  2019-09-16T00:00:00+00:00

     Map<String, dynamic> _paramsWeatherToday = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'num_of_days':3,
     'fx':'yes',
     'format':'json',
     'tp':24,
  };



     Map<String, dynamic> _paramsWeatherNext7Days = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'num_of_days':7,
     'fx':'yes',
     'format':'json',
     'tp':1,
     'tide':'yes',
    //  'extra':'utcDateTime'
  };

     Map<String, dynamic> _paramsWeatherPrev7Days = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'date':DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 3))),
     'enddate':DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 1))),
     'format':'json',
     'tp':1,
     'tide':'yes',
    //  'extra':'utcDateTime'
  };


    Map<String, dynamic> _paramsWeatherNext2Days = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'num_of_days':2,
     'fx':'yes',
     'format':'json',
     'tp':1,
     'tide':'yes',
  };

     Map<String, dynamic> _paramsWeatherPrev1Days = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'date':DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 2))),
     'enddate':DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 1))),
     'format':'json',
     'tp':1,
     'tide':'yes',
  };




      Map<String, dynamic> _paramsMarineNext7Days = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'fx':'yes',
     'format':'json',
     'tp':1,
     'tide':'yes',
  };

     Map<String, dynamic> _paramsMarinePrev1DayAgo = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'date':DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 1))),
     'format':'json',
     'tp':1,
     'tide':'yes',
  };

  Map<String, dynamic> _paramsMarinePrev2DayAgo = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'date':DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 2))),
     'format':'json',
     'tp':1,
     'tide':'yes',
  };

    Map<String, dynamic> _paramsMarinePrev3DayAgo = {
     'q': '9.616966,-79.591037',
     'key':Config.WORLD_WEATHER_ONLINE_API_KEY,
     'date':DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 3))),
     'format':'json',
     'tp':1,
     'tide':'yes',
  };


  Future<WorldWeatherOnlineData> getTodayWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WOW_WEATHER_DATA,
      parameters: _paramsWeatherToday,
    );
    //  // print('printing respomse of getTodayWeatherData');
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    // // debugPrint('weather online data -- '+ weatherOnlineData.data.weathers[0].hours.length.toString());
    return weatherOnlineData;
  }

    Future<WorldWeatherOnlineData> getPrev7DaysWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_PAST_WOW_WEATHER_DATA,
      parameters: _paramsWeatherPrev7Days,
    );
    // // print('printing respomse of getPrev7DaysWeatherData');
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }

    Future<WorldWeatherOnlineData> getNext7DaysWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WOW_WEATHER_DATA,
      parameters: _paramsWeatherNext7Days,
    );
    // // print('printing respomse of getNext7DaysWeatherData');
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }

    Future<WorldWeatherOnlineData> getPrev1DaysWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_PAST_WOW_WEATHER_DATA,
      parameters: _paramsWeatherPrev1Days,
    );
    // // print('printing respomse of getPrev1DaysWeatherData');
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }

    Future<WorldWeatherOnlineData> getNext2DaysWeatherData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WOW_WEATHER_DATA,
      parameters: _paramsWeatherNext2Days,
    );
    
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }

    Future<WorldWeatherOnlineData> getPrev7DaysMarineData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WOW_MARINE_DATA,
      parameters: _paramsWeatherPrev7Days,
    );
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }

  Future<WorldWeatherOnlineData> getNext7DaysMarineData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WOW_MARINE_DATA,
      parameters: _paramsMarineNext7Days,
    );
    // // print('printing respomse of getNext7DaysMarineData');
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }


  Future<WorldWeatherOnlineData> getPrev1DaysMarineData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_PAST_WOW_MARINE_DATA,
      parameters: _paramsMarinePrev1DayAgo,
    );
    // // print('printing respomse of getPrev1DaysMarineData');
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }

  Future<WorldWeatherOnlineData> getNext2DaysMarineData() async {
    final response = await _apiBaseHelper.get(
      url: Config.GET_WOW_MARINE_DATA,
      parameters: _paramsMarineNext7Days,
    );
    // // print(response);
    WorldWeatherOnlineData weatherOnlineData = WorldWeatherOnlineData.fromJson(response);
    return weatherOnlineData;
  }






}
