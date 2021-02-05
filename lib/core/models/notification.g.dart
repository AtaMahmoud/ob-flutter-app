// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmNotification _$FcmNotificationFromJson(Map<String, dynamic> json) {
  return FcmNotification(
    notification: json['notification'] == null
        ? null
        : NotificationTitleData.fromJson(
            json['notification'] as Map<String, dynamic>),
    data: json['data'] == null
        ? null
        : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    isRead: json['isRead'] as bool,
  );
}

Map<String, dynamic> _$FcmNotificationToJson(FcmNotification instance) =>
    <String, dynamic>{
      'notification': instance.notification,
      'data': instance.data,
      'isRead': instance.isRead,
    };

NotificationTitleData _$NotificationTitleDataFromJson(
    Map<String, dynamic> json) {
  return NotificationTitleData(
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$NotificationTitleDataToJson(
        NotificationTitleData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) {
  return NotificationData(
    clickAction: json['click_action'] as String,
    id: json['id'] as String,
    status: json['status'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    contactNo: json['contactNo'] as String,
    accessFor: json['accessFor'] as String,
    accessAs: json['accessAs'] as String,
    message: json['message'] as String,
    notificationType: json['notificationType'] as String,
    requestStatus: json['requestStatus'] as String,
    userID: json['userID'] as String,
    ownerID: json['ownerID'] as String,
    oceanBuilderId: json['oceanBuilderId'] as String,
    oceanBuilderName: json['oceanBuilderName'] as String,
    checkInDate: json['checkInDate'] as String,
  );
}

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'click_action': instance.clickAction,
      'id': instance.id,
      'status': instance.status,
      'name': instance.name,
      'email': instance.email,
      'contactNo': instance.contactNo,
      'accessAs': instance.accessAs,
      'accessFor': instance.accessFor,
      'message': instance.message,
      'notificationType': instance.notificationType,
      'requestStatus': instance.requestStatus,
      'userID': instance.userID,
      'ownerID': instance.ownerID,
      'oceanBuilderId': instance.oceanBuilderId,
      'oceanBuilderName': instance.oceanBuilderName,
      'checkInDate': instance.checkInDate,
    };
