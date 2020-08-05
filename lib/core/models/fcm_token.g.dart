// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmToken _$FcmTokenFromJson(Map json) {
  return FcmToken(
    createdAt: FcmToken._fromJson(json['createdAt'] as int),
    platform: json['platform'] as String,
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$FcmTokenToJson(FcmToken instance) => <String, dynamic>{
      'createdAt': FcmToken._toJson(instance.createdAt),
      'platform': instance.platform,
      'token': instance.token,
    };
