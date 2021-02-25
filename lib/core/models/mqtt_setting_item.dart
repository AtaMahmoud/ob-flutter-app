import 'package:hive/hive.dart';

part 'mqtt_setting_item.g.dart';

@HiveType(typeId: 1)
class MqttSettingsItem {
  @HiveField(0)
  final String mqttServer;
  @HiveField(1)
  final String mqttPort;
  @HiveField(2)
  final String mqttIdentifier;
  @HiveField(3)
  final String mqttUserName;
  @HiveField(4)
  final String mqttPassword;
  @HiveField(5)
  final List<String> mqttTopics;
  MqttSettingsItem(this.mqttServer, this.mqttPort, this.mqttIdentifier,
      this.mqttUserName, this.mqttPassword, this.mqttTopics);
}

/*     
    "mqttServer":"mqtt.technoid.info",
    "mqttPort":1883,
    "mqttIdentifier":"ob_app",
    "mqttUserName":"byron",
    "mqttPassword":"ferret",
    "mqttTopic":"byron/gauge", 
    
*/
