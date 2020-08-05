import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class FcmNotification{
  NotificationTitleData notification;
  NotificationData data;
  bool isRead = false;

  FcmNotification({this.notification,this.data,this.isRead});

  factory FcmNotification.fromJson(Map<String, dynamic> json) => _$FcmNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$FcmNotificationToJson(this);

  
   
}

@JsonSerializable()
class NotificationTitleData{
  String title;
  String body;

  NotificationTitleData({this.title,this.body});

  factory NotificationTitleData.fromJson(Map<String, dynamic> json) => _$NotificationTitleDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationTitleDataToJson(this);
}

@JsonSerializable()
class NotificationData{

  /*
   {data: {click_action: FLUTTER_NOTIFICATION_CLICK, google.original_priority: high, google.delivered_priority: high, email: r@d.c, from: 889155952746, google.sent_time: 1561784427353, contactNo: 1234, status: done, collapse_key: com.ss.oceanbuilders, id: 1, accessAs: GUEST, name: r, accessFor: 3 DAYS, google.message_id: 0:1561784427358744%d1f47f29d1f47f29, google.ttl: 2419200}, notification: {}}
  */

  @JsonKey(name: 'click_action')
  String clickAction;
  String id;
  String status;
  String name;
  String email;
  String contactNo;
  String accessAs;
  String accessFor;
  String message;
  String notificationType;
  String requestStatus;
  String userID;
  String ownerID;
  String oceanBuilderId;
  String oceanBuilderName;
  String checkInDate;




  NotificationData({this.clickAction,this.id,this.status,this.name,this.email,this.contactNo,this.accessFor,this.accessAs,this.message,this.notificationType,this.requestStatus,this.userID,this.ownerID,this.oceanBuilderId,this.oceanBuilderName,this.checkInDate});

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

}