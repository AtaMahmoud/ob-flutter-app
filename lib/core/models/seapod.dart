import 'package:json_annotation/json_annotation.dart';
import 'package:ocean_builder/core/models/control_data.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/permission.dart';

part 'seapod.g.dart';

@JsonSerializable()
class SeaPod {
  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'SeaPodName')
  String obName;
  String ownerId;
  String exteriorFinish;
  @JsonKey(name: 'exterioirColor')
  String exteriorColor;
  @JsonKey(name: 'sparFinish')
  String sparFinishing;
  String sparDesign;
  String deckEnclosure;

  String bedAndLivingRoomEnclousure;
  String power;

  int seaPodOrientation;

  @JsonKey(nullable: true)
  List<String> powerUtilities;
  String underWaterRoomFinishing;
  String underWaterWindows;

  @JsonKey(nullable: true)
  List<String> soundSystem;

  @JsonKey(nullable: true)
  List<String> masterBedroomfloorFinishing;

  String masterBedroominteriorWallColor;

  String livingRoomloorFinishing;
  String livingRoominteriorWallColor;

  String kitchenfloorFinishing;
  String kitcheninteriorWallColor;

  String entryStairs;
  bool hasFathometer;
  bool hasWeatherStation;
  bool hasCleanWaterLevelIndicator;

  @JsonKey(nullable: true)
  double fathometer;

  @JsonKey(nullable: true)
  double cleanWaterLevel;

  String interiorBedroomWallColor;
  String deckFloorFinishMaterials;

  @JsonKey(name: 'qrCodeImageUrl')
  String qRCodeImageUrl;

  String seaPodStatus;

  @JsonKey(name: 'users', nullable: true)
  List<OceanBuilderUser> users;

  @JsonKey(name: 'user')
  OceanBuilderUser activeUser;

  @JsonKey(name: 'data')
  ControlData controlData;

  @JsonKey(nullable: true)
  List<Scene> defaultLightiningScenes;

  @JsonKey(nullable: true)
  List<Scene> lightScenes;

  List<PermissionSet> permissionSets;

  String vessleCode;

  @JsonKey(name: '__v')
  int version;

  SeaPod(
      {this.id,
      this.ownerId,
      this.obName,
      this.exteriorFinish,
      this.exteriorColor,
      this.sparFinishing,
      this.sparDesign,
      this.deckEnclosure,
      this.bedAndLivingRoomEnclousure,
      this.power,
      this.powerUtilities,
      this.underWaterRoomFinishing,
      this.underWaterWindows,
      this.soundSystem,
      this.masterBedroomfloorFinishing,
      this.masterBedroominteriorWallColor,
      this.livingRoomloorFinishing,
      this.livingRoominteriorWallColor,
      this.kitchenfloorFinishing,
      this.kitcheninteriorWallColor,
      this.hasWeatherStation,
      this.entryStairs,
      this.hasFathometer,
      this.hasCleanWaterLevelIndicator,
      this.fathometer,
      this.cleanWaterLevel,
      this.interiorBedroomWallColor,
      this.deckFloorFinishMaterials,
      this.qRCodeImageUrl,
      this.users,
      this.defaultLightiningScenes,
      this.lightScenes,
      this.seaPodOrientation,
      this.seaPodStatus,
      this.vessleCode,
      this.controlData,
      this.version});

  factory SeaPod.fromJson(Map<String, dynamic> json) => _$SeaPodFromJson(json);

  Map<String, dynamic> toJson() => _$SeaPodToJson(this);
}
