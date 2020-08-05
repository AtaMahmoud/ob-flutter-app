import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_token.g.dart';

@JsonSerializable()
class FcmToken{
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  Timestamp createdAt;
  String platform;
  String token;

  FcmToken({this.createdAt,this.platform,this.token});

  factory FcmToken.fromJson(Map<String, dynamic> json) => _$FcmTokenFromJson(json);

  Map<String, dynamic> toJson() => _$FcmTokenToJson(this);

  static Timestamp _fromJson(int milisec) => Timestamp.fromMillisecondsSinceEpoch(milisec);
  static int _toJson(Timestamp time) => time.millisecondsSinceEpoch;

}