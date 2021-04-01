import 'package:hive/hive.dart';

part 'mqtt_setting_item.g.dart';

@HiveType(typeId: 1)
class MqttSettingsItem {
  @HiveField(0)
  String key;
  @HiveField(1)
  String mqttServer;
  @HiveField(2)
  String mqttPort;
  @HiveField(3)
  String mqttIdentifier;
  @HiveField(4)
  String mqttUserName;
  @HiveField(5)
  String mqttPassword;
  @HiveField(6)
  List<String> mqttTopics = [];
  MqttSettingsItem(
      this.key,
      this.mqttServer,
      this.mqttPort,
      this.mqttIdentifier,
      this.mqttUserName,
      this.mqttPassword,
      this.mqttTopics);
  MqttSettingsItem.private();

  validate() {
    return mqttServer != null &&
        mqttPort != null &&
        mqttIdentifier != null &&
        mqttPassword != null &&
        mqttTopics.length >= 0;
  }

  @override
  String toString() {
    return _$MqttSettingsItemToString(this);
  }
}

/*     
    "mqttServer":"mqtt.technoid.info",
    "mqttPort":1883,
    "mqttIdentifier":"ob_app",
    "mqttUserName":"byron",
    "mqttPassword":"ferret",
    "mqttTopic":"byron/gauge", 
    
*/
