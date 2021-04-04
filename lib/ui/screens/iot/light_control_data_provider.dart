import 'package:flutter/material.dart';
import 'package:ocean_builder/core/providers/base_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/repositories/smart_home_node_repository.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';
import 'package:ocean_builder/ui/screens/iot/repo/light_control_repo.dart';

class LightControlDataProvider extends BaseProvider {
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

  LightControlRepo _smartHomeServerRepository = LightControlRepo();

  Future<List<Light>> getAllLigts() async {
    notifyListeners();
    List<Light> lights = [];
    try {
      lights = await _smartHomeServerRepository.getLights();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return lights;
  }

  Future<Light> getLightById(int id) async {
    notifyListeners();
    Light light = Light();
    try {
      light = await _smartHomeServerRepository.getLightById(id);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return light;
  }

  Future<ResponseStatus> addnewLight(Light light) async {
    notifyListeners();
    var response;
    try {
      response = await _smartHomeServerRepository.addLight(light);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return response;
  }

  Future<ResponseStatus> updateLight(Light light) async {
    notifyListeners();
    var response;
    try {
      response = await _smartHomeServerRepository.updateLight(light);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return response;
  }

  Future<ResponseStatus> deleteLight(int id) async {
    notifyListeners();
    ResponseStatus responseStatus;
    try {
      responseStatus = await _smartHomeServerRepository.deleteLight(id);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return responseStatus;
  }
}
