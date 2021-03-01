// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_setting_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MqttSettingsItemAdapter extends TypeAdapter<MqttSettingsItem> {
  @override
  final int typeId = 1;

  @override
  MqttSettingsItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MqttSettingsItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      (fields[6] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MqttSettingsItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.mqttServer)
      ..writeByte(2)
      ..write(obj.mqttPort)
      ..writeByte(3)
      ..write(obj.mqttIdentifier)
      ..writeByte(4)
      ..write(obj.mqttUserName)
      ..writeByte(5)
      ..write(obj.mqttPassword)
      ..writeByte(6)
      ..write(obj.mqttTopics);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MqttSettingsItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

String _$MqttSettingsItemToString(MqttSettingsItem o) {
  return """MqttSettingsItem{key: ${o.key}, mqttServer: ${o.mqttServer}, mqttPort: ${o.mqttPort}, mqttIdentifier: ${o.mqttIdentifier}, mqttUserName: ${o.mqttUserName}, mqttPassword: ${o.mqttPassword}, mqttTopics: ${o.mqttTopics}}""";
}
