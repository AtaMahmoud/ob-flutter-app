import 'package:json_annotation/json_annotation.dart';
part 'user_ocean_builder.g.dart';

@JsonSerializable()
class UserOceanBuilder {
  String oceanBuilderId;
  String oceanBuilderName;
  String vessleCode;
  String userType;
  String reqStatus;

  @JsonKey(fromJson: _dateTimeFromEpochUs, toJson: _dateTimeToEpochUs)
  DateTime checkInDate;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  Duration accessTime;

  @JsonKey(nullable: true)
  String accessRequestID;

  UserOceanBuilder(
      {this.oceanBuilderId,
      this.oceanBuilderName,
      this.userType,
      this.accessTime,
      this.reqStatus,
      this.checkInDate});

  factory UserOceanBuilder.fromJson(Map<String, dynamic> json) =>
      _$UserOceanBuilderFromJson(json);

  Map<String, dynamic> toJson() => _$UserOceanBuilderToJson(this);

  static Duration _fromJson(int hours) =>
      hours == null ? null : Duration(hours: hours);
  static int _toJson(Duration duration) => duration?.inHours;

  static DateTime _dateTimeFromEpochUs(int us) =>
      us == null ? null : new DateTime.fromMicrosecondsSinceEpoch(us);
  static int _dateTimeToEpochUs(DateTime dateTime) =>
      dateTime?.microsecondsSinceEpoch;

  @override
  String toString() {
    return _$UserOceanBuilderToString(this);
  }
}
