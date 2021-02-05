// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_ocean_builder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOceanBuilder _$UserOceanBuilderFromJson(Map<String, dynamic> json) {
  return UserOceanBuilder(
    oceanBuilderId: json['oceanBuilderId'] as String,
    oceanBuilderName: json['oceanBuilderName'] as String,
    userType: json['userType'] as String,
    accessTime: UserOceanBuilder._fromJson(json['accessTime'] as int),
    reqStatus: json['reqStatus'] as String,
    checkInDate:
        UserOceanBuilder._dateTimeFromEpochUs(json['checkInDate'] as int),
  )
    ..vessleCode = json['vessleCode'] as String
    ..accessRequestID = json['accessRequestID'] as String;
}

Map<String, dynamic> _$UserOceanBuilderToJson(UserOceanBuilder instance) =>
    <String, dynamic>{
      'oceanBuilderId': instance.oceanBuilderId,
      'oceanBuilderName': instance.oceanBuilderName,
      'vessleCode': instance.vessleCode,
      'userType': instance.userType,
      'reqStatus': instance.reqStatus,
      'checkInDate': UserOceanBuilder._dateTimeToEpochUs(instance.checkInDate),
      'accessTime': UserOceanBuilder._toJson(instance.accessTime),
      'accessRequestID': instance.accessRequestID,
    };

// **************************************************************************
// ToStringGenerator
// **************************************************************************

String _$UserOceanBuilderToString(UserOceanBuilder o) {
  return """UserOceanBuilder{oceanBuilderId: ${o.oceanBuilderId}, oceanBuilderName: ${o.oceanBuilderName}, vessleCode: ${o.vessleCode}, userType: ${o.userType}, reqStatus: ${o.reqStatus}, checkInDate: ${o.checkInDate}, accessTime: ${o.accessTime}, accessRequestID: ${o.accessRequestID}}""";
}
