import 'package:flutter/foundation.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/repositories/smart_home_node_repository.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class SmartHomeDataProvider extends ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  List<SensorData> _sensorDataList = [];

  // temporary
  String _ledStatus = "";

  // MqttServerClient _client;

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText = _historyText + '\n\n' + _receivedText;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  void setSensorData(SensorData sensorData) {
    _sensorDataList.add(sensorData);
    notifyListeners();
  }

  void setLedStatus(String ledStat) {
    _ledStatus = ledStat;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  List<SensorData> get sensorDataList => _sensorDataList;
  String get ledControl => _ledStatus;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

// nodejs server

  SmartHomeServerRepository _smartHomeServerRepository =
      SmartHomeServerRepository();

  Future<List<IotTopic>> fetchAllTopicsData() async {
    notifyListeners();
    List<IotTopic> allTopicData = [];
    try {
      allTopicData = await _smartHomeServerRepository.getAllTopicData();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allTopicData;
  }

  Future<List<IotEventData>> fetchAllSensorData() async {
    notifyListeners();
    List<IotEventData> allSensorData = [];
    try {
      allSensorData = await _smartHomeServerRepository.getAllSensorData();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allSensorData;
  }

  Future<List<IotEventData>> fetchSensorDataById(int id) async {
    notifyListeners();
    List<IotEventData> allSensorData = [];
    try {
      allSensorData = await _smartHomeServerRepository.getSensorDataById(id);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allSensorData;
  }

  Future<List<IotEventData>> fetchSensorDataByTopic(String topic) async {
    notifyListeners();
    List<IotEventData> allSensorData = [];
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

  Future<List<IotEventData>> fetchSensorDataBetweenDates(
      String topic, String startDate, String endDate) async {
    notifyListeners(); 
    List<IotEventData> allSensorData = [];
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

class SensorData {
  String roomName;
  String sensorName;
  String sensorData;

  SensorData({this.roomName, this.sensorName, this.sensorData});
}
