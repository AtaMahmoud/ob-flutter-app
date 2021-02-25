// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocean_builder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OceanBuilder _$OceanBuilderFromJson(Map json) {
  return OceanBuilder(
    oceanBuilderId: json['oceanBuilderId'] as String ?? '',
    ownerId: json['ownerId'] as String,
    obName: json['obName'] as String,
    exteriorFinish: json['exteriorFinish'] as String,
    exteriorColor: json['exteriorColor'] as String,
    sparFinishing: json['sparFinishing'] as String,
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
    masterBedroomfloorFinishing: json['masterBedroomfloorFinishing'] as String,
    masterBedroominteriorWallColor:
        json['masterBedroominteriorWallColor'] as String,
    livingRoomloorFinishing: json['livingRoomloorFinishing'] as String,
    livingRoominteriorWallColor: json['livingRoominteriorWallColor'] as String,
    kitchenfloorFinishing: json['kitchenfloorFinishing'] as String,
    kitcheninteriorWallColor: json['kitcheninteriorWallColor'] as String,
    weatherStation:
        (json['weatherStation'] as List)?.map((e) => e as String)?.toList(),
    entryStairs: json['entryStairs'] as String,
    hasFathometer: json['hasFathometer'] as bool,
    hasCleanWaterLevelIndicator: json['hasCleanWaterLevelIndicator'] as bool,
    fathometer: (json['fathometer'] as num)?.toDouble(),
    cleanWaterLevel: (json['cleanWaterLevel'] as num)?.toDouble(),
    interiorBedroomWallColor: json['interiorBedroomWallColor'] as String,
    deckFloorFinishMaterials: json['deckFloorFinishMaterials'] as String,
    qRCodeImageUrl: json['qRCodeImageUrl'] as String,
    users: (json['users'] as List)
        ?.map((e) => e == null
            ? null
            : OceanBuilderUser.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    defaultScenes: (json['defaultScenes'] as List)
        ?.map((e) => e == null
            ? null
            : Scene.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$OceanBuilderToJson(OceanBuilder instance) =>
    <String, dynamic>{
      'oceanBuilderId': instance.oceanBuilderId,
      'obName': instance.obName,
      'ownerId': instance.ownerId,
      'exteriorFinish': instance.exteriorFinish,
      'exteriorColor': instance.exteriorColor,
      'sparFinishing': instance.sparFinishing,
      'sparDesign': instance.sparDesign,
      'deckEnclosure': instance.deckEnclosure,
      'bedAndLivingRoomEnclousure': instance.bedAndLivingRoomEnclousure,
      'power': instance.power,
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
      'weatherStation': instance.weatherStation,
      'entryStairs': instance.entryStairs,
      'hasFathometer': instance.hasFathometer,
      'hasCleanWaterLevelIndicator': instance.hasCleanWaterLevelIndicator,
      'fathometer': instance.fathometer,
      'cleanWaterLevel': instance.cleanWaterLevel,
      'interiorBedroomWallColor': instance.interiorBedroomWallColor,
      'deckFloorFinishMaterials': instance.deckFloorFinishMaterials,
      'qRCodeImageUrl': instance.qRCodeImageUrl,
      'users': instance.users,
      'defaultScenes': instance.defaultScenes,
    };
