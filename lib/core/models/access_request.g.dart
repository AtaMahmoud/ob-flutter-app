// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessEvent _$AccessEventFromJson(Map json) {
  return AccessEvent(
    id: json['_id'] as String,
    type: json['type'] as String,
    period: json['period'] as int,
    checkIn: json['checkIn'] as int,
    status: json['status'] as String,
    isRecieved: json['isRecieved'] as bool,
    senderId: json['senderId'] as String,
    recieverId: json['recieverId'] as String,
    permissionSetId: json['permissionSetId'] as String,
    user: json['user'] == null
        ? null
        : AccessRequestUser.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    seaPod: json['seaPod'] == null
        ? null
        : AccessRequestSeaPod.fromJson((json['seaPod'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    reqMessage: json['reqMessage'] as String,
    version: json['__v'] as int,
  );
}

Map<String, dynamic> _$AccessEventToJson(AccessEvent instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'period': instance.period,
      'checkIn': instance.checkIn,
      'status': instance.status,
      'isRecieved': instance.isRecieved,
      'senderId': instance.senderId,
      'recieverId': instance.recieverId,
      'permissionSetId': instance.permissionSetId,
      '__v': instance.version,
      'user': instance.user,
      'seaPod': instance.seaPod,
      'reqMessage': instance.reqMessage,
    };

ServerNotification _$ServerNotificationFromJson(Map json) {
  return ServerNotification(
    id: json['_id'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    seen: json['seen'] as bool,
    priority: json['priority'] as int,
    data: json['data'] == null
        ? null
        : NotificationData.fromJson((json['data'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$ServerNotificationToJson(ServerNotification instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'seen': instance.seen,
      'priority': instance.priority,
      'data': instance.data,
    };

NotificationData _$NotificationDataFromJson(Map json) {
  return NotificationData(
    id: json['_id'] as String,
    type: json['type'] as String,
    period: json['period'] as int,
    checkIn: json['checkIn'] as int,
    status: json['status'] as String,
    isRecieved: json['isRecieved'] as bool,
    senderId: json['senderId'] as String,
    recieverId: json['recieverId'] as String,
    permissionSetId: json['permissionSetId'] as String,
    seaPod: json['seaPod'] == null
        ? null
        : AccessRequestSeaPod.fromJson((json['seaPod'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    user: json['user'] == null
        ? null
        : AccessRequestUser.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    version: json['__v'] as int,
  )..isRecived = json['isRecived'] as bool;
}

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'period': instance.period,
      'isRecived': instance.isRecived,
      'checkIn': instance.checkIn,
      'status': instance.status,
      'isRecieved': instance.isRecieved,
      'senderId': instance.senderId,
      'recieverId': instance.recieverId,
      'permissionSetId': instance.permissionSetId,
      '__v': instance.version,
      'user': instance.user,
      'seaPod': instance.seaPod,
    };

AccessRequestUser _$AccessRequestUserFromJson(Map json) {
  return AccessRequestUser(
    id: json['_id'] as String,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    email: json['email'] as String,
    mobileNumber: json['mobileNumber'] as String,
  );
}

Map<String, dynamic> _$AccessRequestUserToJson(AccessRequestUser instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
    };

AccessRequestSeaPod _$AccessRequestSeaPodFromJson(Map json) {
  return AccessRequestSeaPod(
    id: json['_id'] as String,
    name: json['name'] as String,
    vessleCode: json['vessleCode'] as String,
  );
}

Map<String, dynamic> _$AccessRequestSeaPodToJson(
        AccessRequestSeaPod instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'vessleCode': instance.vessleCode,
    };
