import 'package:json_annotation/json_annotation.dart';
import 'package:ocean_builder/core/models/lighting.dart';

part 'ocean_builder_user.g.dart';

@JsonSerializable()
class OceanBuilderUser {
  @JsonKey(name: '_id')
  String userId;
  String userName;
  @JsonKey(nullable: true)
  Lighting lighting;

  @JsonKey(name: 'type')
  String userType;

  String profilePicUrl;

  String reqStatus;

  @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
  DateTime checkInDate;

  @JsonKey(name: 'accessPeriod', fromJson: _fromJson, toJson: _toJson)
  Duration accessTime;

  OceanBuilderUser(
      {this.userId,
      this.userName,
      this.profilePicUrl,
      this.userType,
      this.reqStatus,
      this.lighting});

  factory OceanBuilderUser.fromJson(Map<String, dynamic> json) =>
      _$OceanBuilderUserFromJson(json);

  Map<String, dynamic> toJson() => _$OceanBuilderUserToJson(this);

  static Duration _fromJson(int hours) =>
      hours == null ? null : Duration(milliseconds: hours);
  static int _toJson(Duration duration) => duration?.inMilliseconds;

  static DateTime _dateTimeFromEpochUs(int us) =>
      us == null ? null : new DateTime.fromMicrosecondsSinceEpoch(us);
  static int _dateTimeToEpochUs(DateTime dateTime) =>
      dateTime?.microsecondsSinceEpoch;
}

/*

               users:[ {
                    "isDisabled": false,
                    "lighting": {
                        "isOn": false,
                        "lightScenes": [],
                        "_id": "5e7921d5114ab70017d1003a"
                    },
                    "_id": "5e78bb9e114ab70017d0ff2d",
                    "userName": "John Doe",
                    "profilePicUrl": "",
                    "type": "OWNER"
                    "checkIn":1586196000000,
                    "period":259200000
                }
                ]

                To show 
                Check In Date
                Or
                Expires in _n_ days. 
                In the accessmanagement screen

*/
