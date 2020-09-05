import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class SmartHomeServerRepository{

  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  String _allSensorData = 'http://opensteading.ddns.net:8000/api/events';
  String _getSensorDataBetweenDates = 'http://opensteading.ddns.net:8000/api/events/';
  String _getSensorDataById = 'http://opensteading.ddns.net:8000/api/events/';

  Future<List<IotEventData>> getAllSensorData() async {
    List<IotEventData> iotEventDataList = [];
    final response = await _apiBaseHelper.get(
      url: _allSensorData,
    );
    print(response);
    var responseMap = response.data as List;
    
    responseMap.map((json) {
    IotEventData iotEventData = IotEventData.fromJson(json);
    iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  
  }

    Future<List<IotEventData>> getSensorDataBetweenDates() async {
    List<IotEventData> iotEventDataList = [];

  final Map<String, dynamic> _params = {
    "time_start": DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
    "time_end": DateTime.now().toIso8601String(),
  };

    final response = await _apiBaseHelper.get(
      url: _getSensorDataBetweenDates,
      parameters: _params
    );
    print(response);
    var responseMap = response.data as List;
    
    responseMap.map((json) {
    IotEventData iotEventData = IotEventData.fromJson(json);
    iotEventDataList.add(iotEventData);
    }).toList();

    return iotEventDataList;
  
  }

}