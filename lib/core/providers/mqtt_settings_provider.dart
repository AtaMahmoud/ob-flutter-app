import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ocean_builder/core/models/mqtt_setting_item.dart';

class MqttSettingsProvider with ChangeNotifier {
  String _mqttSettings = 'mqttSettings';

  List _mqttSettingsList = <String>[];

  MqttSettingsItem _selectedMqttSettings;

  MqttSettingsItem get selectedMqttSettings => _selectedMqttSettings;

  set selectedMqttSettings(MqttSettingsItem val) {
    _selectedMqttSettings = val;
    notifyListeners();
  }

  List get mqttSettingsList => _mqttSettingsList;

  addMqttSettingsItem(MqttSettingsItem mqttSettingsItem) async {
    var box = await Hive.openBox<MqttSettingsItem>(_mqttSettings);

    if (mqttSettingsItem == null) return;

    mqttSettingsItem.key = DateTime.now().millisecondsSinceEpoch.toString();

    box.put(mqttSettingsItem.key, mqttSettingsItem);

    print('mqtt settings item added');

    notifyListeners();
  }

  getMqttSettings() async {
    final box = await Hive.openBox<MqttSettingsItem>(_mqttSettings);

    _mqttSettingsList = box.values.toList();

    notifyListeners();
  }

  updateMqttSettingsItemByIndex(int index, MqttSettingsItem mqttSettingsItem) {
    final box = Hive.box<MqttSettingsItem>(_mqttSettings);

    box.putAt(index, mqttSettingsItem);

    notifyListeners();
  }

  updateMqttSettingsItem(MqttSettingsItem mqttSettingsItem) {
    final box = Hive.box<MqttSettingsItem>(_mqttSettings);

    box.put(mqttSettingsItem.key, mqttSettingsItem);

    notifyListeners();
  }

  deleteMqttSettingsItemByIndex(int index) {
    final box = Hive.box<String>(_mqttSettings);

    box.deleteAt(index);

    getMqttSettings();

    notifyListeners();
  }

  deleteMqttSettingsItem(MqttSettingsItem mqttSettingsItem) {
    final box = Hive.box<String>(_mqttSettings);

    box.delete(mqttSettingsItem.key);

    getMqttSettings();

    notifyListeners();
  }
}
