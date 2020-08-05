import 'package:json_annotation/json_annotation.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';

part 'reg_with_seapod.g.dart';

@JsonSerializable()
class RegWithSeaPod{

  @JsonKey(name:'user')
  RegUser user;
  @JsonKey(name:'seaPod')
  RegSeaPod seaPod;
  
  RegWithSeaPod({this.user,this.seaPod});

  factory RegWithSeaPod.fromJson(Map<String, dynamic> json) => _$RegWithSeaPodFromJson(json);

  Map<String, dynamic> toJson() => _$RegWithSeaPodToJson(this);
}

@JsonSerializable()
class RegUser{
String firstName;
String lastName;
String email;
String mobileNumber;
String password;
String country;
RegUser({this.firstName,this.lastName,this.country,this.email,this.mobileNumber,this.password});

factory RegUser.fromJson(Map<String, dynamic> json) => _$RegUserFromJson(json);

Map<String, dynamic> toJson() => _$RegUserToJson(this);

}

@JsonSerializable()
class RegSeaPod{

@JsonKey(name: 'SeaPodName')
String seaPodName;
String exteriorFinish;
String exterioirColor;
String sparFinish;
String sparDesign;
String deckEnclosure;
String bedAndLivingRoomEnclousure;
String power;
String underWaterRoomFinishing;
String underWaterWindows;
List<String> soundSystem;
List<String> powerUtilities;
List<String> masterBedroomFloorFinishing;
String masterBedroomInteriorWallColor;
String livingRoomloorFinishing;
String livingRoomInteriorWallColor;
String kitchenfloorFinishing;
String kitchenInteriorWallColor;
bool hasWeatherStation;
bool entryStairs;
bool hasFathometer;
bool hasCleanWaterLevelIndicator;
String interiorBedroomWallColor;
String deckFloorFinishMaterial;
String seaPodStatus;

  RegSeaPod({this.seaPodName,this.exteriorFinish,this.exterioirColor,this.sparDesign,this.bedAndLivingRoomEnclousure,this.deckEnclosure,this.deckFloorFinishMaterial,this.entryStairs,this.hasCleanWaterLevelIndicator,this.hasFathometer,this.hasWeatherStation,this.interiorBedroomWallColor,this.kitchenfloorFinishing,this.kitchenInteriorWallColor,this.livingRoomInteriorWallColor,this.livingRoomloorFinishing,this.masterBedroomFloorFinishing,this.masterBedroomInteriorWallColor,this.power,this.powerUtilities,this.seaPodStatus,this.soundSystem,this.sparFinish,this.underWaterRoomFinishing,this.underWaterWindows});

  factory RegSeaPod.fromJson(Map<String, dynamic> json) => _$RegSeaPodFromJson(json);

  Map<String, dynamic> toJson() => _$RegSeaPodToJson(this);


}

