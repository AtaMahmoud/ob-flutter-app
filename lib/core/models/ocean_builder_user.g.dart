// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocean_builder_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OceanBuilderUser _$OceanBuilderUserFromJson(Map<String, dynamic> json) {
  return OceanBuilderUser(
    userId: json['_id'] as String,
    userName: json['userName'] as String,
    profilePicUrl: json['profilePicUrl'] as String,
    userType: json['type'] as String,
    reqStatus: json['reqStatus'] as String,
    lighting: json['lighting'] == null
        ? null
        : Lighting.fromJson(json['lighting'] as Map<String, dynamic>),
  )
    ..checkInDate =
        OceanBuilderUser._dateTimeFromEpochUs(json['checkInDate'] as int)
    ..accessTime = OceanBuilderUser._fromJson(json['accessPeriod'] as int);
}

Map<String, dynamic> _$OceanBuilderUserToJson(OceanBuilderUser instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'userName': instance.userName,
      'lighting': instance.lighting,
      'type': instance.userType,
      'profilePicUrl': instance.profilePicUrl,
      'reqStatus': instance.reqStatus,
      'checkInDate': OceanBuilderUser._dateTimeToEpochUs(instance.checkInDate),
      'accessPeriod': OceanBuilderUser._toJson(instance.accessTime),
    };
