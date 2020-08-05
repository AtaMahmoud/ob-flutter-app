// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seapod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeaPod _$SeaPodFromJson(Map json) {
  return SeaPod(
    id: json['_id'] as String,
    ownerId: json['ownerId'] as String,
    obName: json['SeaPodName'] as String,
    exteriorFinish: json['exteriorFinish'] as String,
    exteriorColor: json['exterioirColor'] as String,
    sparFinishing: json['sparFinish'] as String,
    sparDesign: json['sparDesign'] as String,
    deckEnclosure: json['deckEnclosure'] as String,
    bedAndLivingRoomEnclousure: json['bedAndLivingRoomEnclousure'] as String,
    power: json['power'] as String,
    powerUtilities:
        (json['powerUtilities'] as List)?.map((e) => e as String)?.toList(),
    underWaterRoomFinishing: json['underWaterRoomFinishing'] as String,
    underWaterWindows: json['underWaterWindows'] as String,
    soundSystem:
        (json['soundSystem'] as List)?.map((e) => e as String)?.toList(),
    masterBedroomfloorFinishing: (json['masterBedroomfloorFinishing'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    masterBedroominteriorWallColor:
        json['masterBedroominteriorWallColor'] as String,
    livingRoomloorFinishing: json['livingRoomloorFinishing'] as String,
    livingRoominteriorWallColor: json['livingRoominteriorWallColor'] as String,
    kitchenfloorFinishing: json['kitchenfloorFinishing'] as String,
    kitcheninteriorWallColor: json['kitcheninteriorWallColor'] as String,
    hasWeatherStation: json['hasWeatherStation'] as bool,
    entryStairs: json['entryStairs'] as String,
    hasFathometer: json['hasFathometer'] as bool,
    hasCleanWaterLevelIndicator: json['hasCleanWaterLevelIndicator'] as bool,
    fathometer: (json['fathometer'] as num)?.toDouble(),
    cleanWaterLevel: (json['cleanWaterLevel'] as num)?.toDouble(),
    interiorBedroomWallColor: json['interiorBedroomWallColor'] as String,
    deckFloorFinishMaterials: json['deckFloorFinishMaterials'] as String,
    qRCodeImageUrl: json['qrCodeImageUrl'] as String,
    users: (json['users'] as List)
        ?.map((e) => e == null
            ? null
            : OceanBuilderUser.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    defaultLightiningScenes: (json['defaultLightiningScenes'] as List)
        ?.map((e) => e == null
            ? null
            : Scene.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    lightScenes: (json['lightScenes'] as List)
        ?.map((e) => e == null
            ? null
            : Scene.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    seaPodOrientation: json['seaPodOrientation'] as int,
    seaPodStatus: json['seaPodStatus'] as String,
    vessleCode: json['vessleCode'] as String,
    controlData: json['data'] == null
        ? null
        : ControlData.fromJson((json['data'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    version: json['__v'] as int,
  )
    ..activeUser = json['user'] == null
        ? null
        : OceanBuilderUser.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..permissionSets = (json['permissionSets'] as List)
        ?.map((e) => e == null
            ? null
            : PermissionSet.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

Map<String, dynamic> _$SeaPodToJson(SeaPod instance) => <String, dynamic>{
      '_id': instance.id,
      'SeaPodName': instance.obName,
      'ownerId': instance.ownerId,
      'exteriorFinish': instance.exteriorFinish,
      'exterioirColor': instance.exteriorColor,
      'sparFinish': instance.sparFinishing,
      'sparDesign': instance.sparDesign,
      'deckEnclosure': instance.deckEnclosure,
      'bedAndLivingRoomEnclousure': instance.bedAndLivingRoomEnclousure,
      'power': instance.power,
      'seaPodOrientation': instance.seaPodOrientation,
      'powerUtilities': instance.powerUtilities,
      'underWaterRoomFinishing': instance.underWaterRoomFinishing,
      'underWaterWindows': instance.underWaterWindows,
      'soundSystem': instance.soundSystem,
      'masterBedroomfloorFinishing': instance.masterBedroomfloorFinishing,
      'masterBedroominteriorWallColor': instance.masterBedroominteriorWallColor,
      'livingRoomloorFinishing': instance.livingRoomloorFinishing,
      'livingRoominteriorWallColor': instance.livingRoominteriorWallColor,
      'kitchenfloorFinishing': instance.kitchenfloorFinishing,
      'kitcheninteriorWallColor': instance.kitcheninteriorWallColor,
      'entryStairs': instance.entryStairs,
      'hasFathometer': instance.hasFathometer,
      'hasWeatherStation': instance.hasWeatherStation,
      'hasCleanWaterLevelIndicator': instance.hasCleanWaterLevelIndicator,
      'fathometer': instance.fathometer,
      'cleanWaterLevel': instance.cleanWaterLevel,
      'interiorBedroomWallColor': instance.interiorBedroomWallColor,
      'deckFloorFinishMaterials': instance.deckFloorFinishMaterials,
      'qrCodeImageUrl': instance.qRCodeImageUrl,
      'seaPodStatus': instance.seaPodStatus,
      'users': instance.users,
      'user': instance.activeUser,
      'data': instance.controlData,
      'defaultLightiningScenes': instance.defaultLightiningScenes,
      'lightScenes': instance.lightScenes,
      'permissionSets': instance.permissionSets,
      'vessleCode': instance.vessleCode,
      '__v': instance.version,
    };
