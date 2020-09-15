// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lighting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lighting _$LightingFromJson(Map json) {
  return Lighting(
    id: json['_id'] as String,
    isLightON: json['isOn'] as bool,
    intensity: (json['intensity'] as num)?.toDouble() ?? 0.0,
    selectedScene: json['selectedScene'] as String,
    sceneList: (json['lightScenes'] as List)
        ?.map((e) => e == null
            ? null
            : Scene.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$LightingToJson(Lighting instance) => <String, dynamic>{
      '_id': instance.id,
      'isOn': instance.isLightON,
      'intensity': instance.intensity,
      'selectedScene': instance.selectedScene,
      'lightScenes': instance.sceneList?.map((e) => e?.toJson())?.toList(),
    };

Scene _$SceneFromJson(Map json) {
  return Scene(
    id: json['_id'] as String,
    userId: json['userId'] as String,
    seapodId: json['seapodId'] as String,
    source: json['source'] as String,
    name: json['sceneName'] as String,
    rooms: (json['rooms'] as List)
        ?.map((e) => e == null
            ? null
            : Room.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$SceneToJson(Scene instance) => <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'seapodId': instance.seapodId,
      'source': instance.source,
      'sceneName': instance.name,
      'rooms': instance.rooms?.map((e) => e?.toJson())?.toList(),
    };

Room _$RoomFromJson(Map json) {
  return Room(
    id: json['_id'] as String,
    roomName: json['label'] as String,
    lightModes: (json['moodes'] as List)
        ?.map((e) => e == null
            ? null
            : Light.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      '_id': instance.id,
      'label': instance.roomName,
      'moodes': instance.lightModes?.map((e) => e?.toJson())?.toList(),
    };

Light _$LightFromJson(Map json) {
  return Light(
    id: json['_id'] as String,
    lightName: json['lightName'] as String,
    lightColor: json['lightColor'] as String,
    status: json['status'] as bool,
    brightness: json['brightness'] as int,
  );
}

Map<String, dynamic> _$LightToJson(Light instance) => <String, dynamic>{
      '_id': instance.id,
      'lightName': instance.lightName,
      'lightColor': instance.lightColor,
      'status': instance.status,
      'brightness': instance.brightness,
    };
