import 'package:hive/hive.dart';
import 'package:to_string/to_string.dart';

part 'mqtt_setting_item.g.dart';

@ToString()
@HiveType(typeId: 1)
class MqttSettingsItem {
  @HiveField(0)
  String mqttServer;
  @HiveField(1)
  String mqttPort;
  @HiveField(2)
  String mqttIdentifier;
  @HiveField(3)
  String mqttUserName;
  @HiveField(4)
  String mqttPassword;
  @HiveField(5)
  List<String> mqttTopics = [];
  MqttSettingsItem(this.mqttServer, this.mqttPort, this.mqttIdentifier,
      this.mqttUserName, this.mqttPassword, this.mqttTopics);
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
