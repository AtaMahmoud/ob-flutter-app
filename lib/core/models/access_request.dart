import 'package:json_annotation/json_annotation.dart';

part 'access_request.g.dart';

@JsonSerializable()
class AccessEvent {
  @JsonKey(name: '_id')
  String id;
  String type;
  int period;
  int checkIn;
  String status;
  bool isRecieved;
  String senderId;
  String recieverId;
  String permissionSetId;
  @JsonKey(name: '__v')
  int version;
  AccessRequestUser user;
  AccessRequestSeaPod seaPod;

  @JsonKey(nullable: true)
  String reqMessage;

  @JsonKey(ignore: true)
  String accesEventType;

  AccessEvent(
      {this.id,
      this.type,
      this.period,
      this.checkIn,
      this.status,
      this.isRecieved,
      this.senderId,
      this.recieverId,
      this.permissionSetId,
      this.user,
      this.seaPod,
      this.accesEventType,
      this.reqMessage,
      this.version});

  factory AccessEvent.fromJson(Map<String, dynamic> json) =>
      _$AccessEventFromJson(json);

  Map<String, dynamic> toJson() => _$AccessEventToJson(this);
}

@JsonSerializable()
class ServerNotification {
  @JsonKey(name: '_id')
  String id;
  String title;
  String message;
  bool seen;
  int priority;
  NotificationData data;

  ServerNotification(
      {this.id, this.title, this.message, this.seen, this.priority, this.data});

  factory ServerNotification.fromJson(Map<String, dynamic> json) =>
      _$ServerNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$ServerNotificationToJson(this);
}

@JsonSerializable()
class NotificationData {
  @JsonKey(name: '_id')
  String id;
  String type;
  int period;
  bool isRecived;
  int checkIn;
  String status;
  bool isRecieved;
  String senderId;
  String recieverId;
  String permissionSetId;
  @JsonKey(name: '__v')
  int version;
  AccessRequestUser user;
  AccessRequestSeaPod seaPod;

  NotificationData(
      {this.id,
      this.type,
      this.period,
      this.checkIn,
      this.status,
      this.isRecieved,
      this.senderId,
      this.recieverId,
      this.permissionSetId,
      this.seaPod,
      this.user,
      this.version});

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}

@JsonSerializable()
class AccessRequestUser {
  @JsonKey(name: '_id')
  String id;
  String name;
  String imageUrl;
  String email;
  String mobileNumber;

  AccessRequestUser(
      {this.id, this.name, this.imageUrl, this.email, this.mobileNumber});

  factory AccessRequestUser.fromJson(Map<String, dynamic> json) =>
      _$AccessRequestUserFromJson(json);

  Map<String, dynamic> toJson() => _$AccessRequestUserToJson(this);
}

@JsonSerializable()
class AccessRequestSeaPod {
  @JsonKey(name: '_id')
  String id;
  String name;
  String vessleCode;

  AccessRequestSeaPod({this.id, this.name, this.vessleCode});

  factory AccessRequestSeaPod.fromJson(Map<String, dynamic> json) =>
      _$AccessRequestSeaPodFromJson(json);

  Map<String, dynamic> toJson() => _$AccessRequestSeaPodToJson(this);
}

class NotificationList {
  final List<ServerNotification> notifications;

  NotificationList({
    this.notifications,
  });

  factory NotificationList.fromJson(List<dynamic> parsedJson) {
    List<ServerNotification> notifications = new List<ServerNotification>();
    notifications =
        parsedJson.map((i) => ServerNotification.fromJson(i)).toList();

    return new NotificationList(notifications: notifications);
  }
}
