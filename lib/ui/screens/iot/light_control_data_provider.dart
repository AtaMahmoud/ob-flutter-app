import 'package:flutter/material.dart';
import 'package:ocean_builder/core/providers/base_provider.dart';
import 'package:ocean_builder/core/repositories/smart_home_node_repository.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';



class LightControlDataProvider extends BaseProvider{


  String _receivedText = '';
  String _historyText = '';
  List<Light> _lightDataList = [];

  // temporary
  String _ledStatus = "";

  // MqttServerClient _client;

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText = _historyText + '\n\n' + _receivedText;
    notifyListeners();
  }


  void setSensorData(Light sensorData) {
    _lightDataList.add(sensorData);
    notifyListeners();
  }

  void setLedStatus(String ledStat) {
    _ledStatus = ledStat;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  List<Light> get sensorDataList => _lightDataList;
  String get ledControl => _ledStatus;


// nodejs server

  SmartHomeServerRepository _smartHomeServerRepository =
      SmartHomeServerRepository();

  Future<List<Light>> fetchAllTopicsData() async {
    notifyListeners();
    List<Light> allTopicData = [];
    try {
      allTopicData = await _smartHomeServerRepository.getAllTopicData();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allTopicData;
  }

  Future<List<Light>> fetchAllSensorData() async {
    notifyListeners();
    List<Light> allSensorData = [];
    try {
      allSensorData = await _smartHomeServerRepository.getAllSensorData();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allSensorData;
  }

  Future<List<Light>> fetchSensorDataById(int id) async {
    notifyListeners();
    List<Light> allSensorData = [];
    try {
      allSensorData = await _smartHomeServerRepository.getSensorDataById(id);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allSensorData;
  }

  Future<List<Light>> fetchSensorDataByTopic(String topic) async {
    notifyListeners();
    List<Light> allSensorData = [];
    topic = topic.replaceAll(new RegExp(r'\/'), '%2F');
    debugPrint('Parsed topic ----- $topic');
    try {
      allSensorData =
          await _smartHomeServerRepository.getSensorDataByTopic(topic);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allSensorData;
  }

  Future<List<Light>> fetchSensorDataBetweenDates(
      String topic, String startDate, String endDate) async {
    notifyListeners(); 
    List<Light> allSensorData = [];
    topic = topic.replaceAll(new RegExp(r'\/'), '%2F');
    debugPrint('Parsed topic ----- $topic');

    try {
      allSensorData = await _smartHomeServerRepository
          .getTopicsDataBetweenDates(topic, startDate, endDate);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allSensorData;
  }

  
}