import 'package:flutter/material.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class SmartHomeServerRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  String _getTopicList = 'https://seapod.technoid.info:8000/api/topics';

  String _allSensorData = 'https://seapod.technoid.info:8000/api/events';
  String _getSensorDataBetweenDates =
      'https://seapod.technoid.info:8000/api/events/';
  String _getSensorDataById = 'https://seapod.technoid.info:8000/api/events/';

  final Map<String, dynamic> _headers = {
    "x-auth-token": Config.IOT_SERVER_API_KEY,
  };


  Future<List<IotTopic>> getAllTopicData() async {
    List<IotTopic> iotTopicList = [];
    final response =
        await _apiBaseHelper.get(url: _getTopicList, headers: _headers);
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      IotTopic iotTopic = IotTopic.fromJson(json);
      iotTopicList.add(iotTopic);
    }).toList();

    return iotTopicList;
  }

  Future<List<IotEventData>> getAllSensorData() async {
    List<IotEventData> iotEventDataList = [];
    final response =
        await _apiBaseHelper.get(url: _allSensorData, headers: _headers);
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      IotEventData iotEventData = IotEventData.fromJson(json);
      iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  }

  Future<List<IotEventData>> getSensorDataBetweenDates() async {
    List<IotEventData> iotEventDataList = [];

    final Map<String, dynamic> _params = {
      "time_start": DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 3))),
      "time_end": DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    final response = await _apiBaseHelper.get(
        url: _getSensorDataBetweenDates,
        headers: _headers,
        parameters: _params);
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      IotEventData iotEventData = IotEventData.fromJson(json);
      iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  }

  Future<List<IotEventData>> getSensorDataById(eventID) async {
    List<IotEventData> iotEventDataList = [];

    final Map<String, dynamic> _params = {
      "eventId": eventID,
    };

    final response = await _apiBaseHelper.get(
        url: _getSensorDataById, headers: _headers, parameters: _params);
    
    debugPrint('-getSensorDataById-');
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      IotEventData iotEventData = IotEventData.fromJson(json);
      iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  }
}
