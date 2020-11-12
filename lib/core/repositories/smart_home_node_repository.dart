import 'package:flutter/material.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:intl/intl.dart';

class SmartHomeServerRepository {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  String _getTopicList = 'https://seapod.technoid.info:8000/api/topics';

  String _allSensorData = 'https://seapod.technoid.info:8000/api/events';
  String _getSensorDataBetweenDates(
          String topic, String startDate, String endDate) =>
      'https://seapod.technoid.info:8000/api/events/$topic/$startDate/to/$endDate';
  String _getSensorDataById(String id) =>
      'https://seapod.technoid.info:8000/api/events/$id';
  String _getSensorDataByTopic(topicName) =>
      'https://seapod.technoid.info:8000/api/events/topics/$topicName';

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

  Future<List<IotEventData>> getSensorDataById(eventID) async {
    List<IotEventData> iotEventDataList = [];

    final response = await _apiBaseHelper.get(
        url: _getSensorDataById(eventID), headers: _headers);

    debugPrint('-getSensorDataById-');
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      IotEventData iotEventData = IotEventData.fromJson(json);
      iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  }

  Future<List<IotEventData>> getSensorDataByTopic(topic) async {
    List<IotEventData> iotEventDataList = [];

    final response = await _apiBaseHelper.get(
        url: _getSensorDataByTopic(topic), headers: _headers);

    debugPrint('-_getSensorDataByTopic-');
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      IotEventData iotEventData = IotEventData.fromJson(json);
      iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  }

  Future<List<IotEventData>> getTopicsDataBetweenDates(
      String topic, String startDate, String endDate) async {
    List<IotEventData> iotEventDataList = [];

    final response = await _apiBaseHelper.get(
        url: _getSensorDataBetweenDates(topic, startDate, endDate),
        headers: _headers);
    debugPrint('-getTopicsDataBetweenDates-');
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      IotEventData iotEventData = IotEventData.fromJson(json);
      iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  }
}
