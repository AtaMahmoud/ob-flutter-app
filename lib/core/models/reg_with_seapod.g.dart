// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reg_with_seapod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegWithSeaPod _$RegWithSeaPodFromJson(Map json) {
  return RegWithSeaPod(
    user: json['user'] == null
        ? null
        : RegUser.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    seaPod: json['seaPod'] == null
        ? null
        : RegSeaPod.fromJson((json['seaPod'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$RegWithSeaPodToJson(RegWithSeaPod instance) =>
    <String, dynamic>{
      'user': instance.user,
      'seaPod': instance.seaPod,
    };

RegUser _$RegUserFromJson(Map json) {
  return RegUser(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    country: json['country'] as String,
    email: json['email'] as String,
    mobileNumber: json['mobileNumber'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$RegUserToJson(RegUser instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'password': instance.password,
      'country': instance.country,
    };

RegSeaPod _$RegSeaPodFromJson(Map json) {
  return RegSeaPod(
    seaPodName: json['SeaPodName'] as String,
    exteriorFinish: json['exteriorFinish'] as String,
    exterioirColor: json['exterioirColor'] as String,
    sparDesign: json['sparDesign'] as String,
    bedAndLivingRoomEnclousure: json['bedAndLivingRoomEnclousure'] as String,
    deckEnclosure: json['deckEnclosure'] as String,
    deckFloorFinishMaterial: json['deckFloorFinishMaterial'] as String,
    entryStairs: json['entryStairs'] as bool,
    hasCleanWaterLevelIndicator: json['hasCleanWaterLevelIndicator'] as bool,
    hasFathometer: json['hasFathometer'] as bool,
    hasWeatherStation: json['hasWeatherStation'] as bool,
    interiorBedroomWallColor: json['interiorBedroomWallColor'] as String,
    kitchenfloorFinishing: json['kitchenfloorFinishing'] as String,
    kitchenInteriorWallColor: json['kitchenInteriorWallColor'] as String,
    livingRoomInteriorWallColor: json['livingRoomInteriorWallColor'] as String,
    livingRoomloorFinishing: json['livingRoomloorFinishing'] as String,
    masterBedroomFloorFinishing: (json['masterBedroomFloorFinishing'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    masterBedroomInteriorWallColor:
        json['masterBedroomInteriorWallColor'] as String,
    power: json['power'] as String,
    powerUtilities:
        (json['powerUtilities'] as List)?.map((e) => e as String)?.toList(),
    seaPodStatus: json['seaPodStatus'] as String,
    soundSystem:
        (json['soundSystem'] as List)?.map((e) => e as String)?.toList(),
    sparFinish: json['sparFinish'] as String,
    underWaterRoomFinishing: json['underWaterRoomFinishing'] as String,
    underWaterWindows: json['underWaterWindows'] as String,
  );
}

Map<String, dynamic> _$RegSeaPodToJson(RegSeaPod instance) => <String, dynamic>{
      'SeaPodName': instance.seaPodName,
      'exteriorFinish': instance.exteriorFinish,
      'exterioirColor': instance.exterioirColor,
      'sparFinish': instance.sparFinish,
      'sparDesign': instance.sparDesign,
      'deckEnclosure': instance.deckEnclosure,
      'bedAndLivingRoomEnclousure': instance.bedAndLivingRoomEnclousure,
      'power': instance.power,
      'underWaterRoomFinishing': instance.underWaterRoomFinishing,
      'underWaterWindows': instance.underWaterWindows,
      'soundSystem': instance.soundSystem,
      'powerUtilities': instance.powerUtilities,
      'masterBedroomFloorFinishing': instance.masterBedroomFloorFinishing,
      'masterBedroomInteriorWallColor': instance.masterBedroomInteriorWallColor,
      'livingRoomloorFinishing': instance.livingRoomloorFinishing,
      'livingRoomInteriorWallColor': instance.livingRoomInteriorWallColor,
      'kitchenfloorFinishing': instance.kitchenfloorFinishing,
      'kitchenInteriorWallColor': instance.kitchenInteriorWallColor,
      'hasWeatherStation': instance.hasWeatherStation,
      'entryStairs': instance.entryStairs,
      'hasFathometer': instance.hasFathometer,
      'hasCleanWaterLevelIndicator': instance.hasCleanWaterLevelIndicator,
      'interiorBedroomWallColor': instance.interiorBedroomWallColor,
      'deckFloorFinishMaterial': instance.deckFloorFinishMaterial,
      'seaPodStatus': instance.seaPodStatus,
    };
