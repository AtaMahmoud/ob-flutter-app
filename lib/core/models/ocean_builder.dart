import 'package:json_annotation/json_annotation.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';

part 'ocean_builder.g.dart';

@JsonSerializable()
class OceanBuilder {
  @JsonKey(defaultValue: '')
  String oceanBuilderId;

  String obName;
  String ownerId;
  // ExteriorPart exteriorPart;
  // skiping using nested models for now
  String exteriorFinish;
  String exteriorColor;
  String sparFinishing;
  String sparDesign;
  String deckEnclosure;

  String bedAndLivingRoomEnclousure;
  String power;

  @JsonKey(nullable: true)
  List<String> powerUtilities;
  String underWaterRoomFinishing;
  String underWaterWindows;

  @JsonKey(nullable: true)
  List<String> soundSystem;

  // Room masterBedroomSpecifications;
  // Room livingRoomFloorSpecifications;
  // Room kitchenFloorSpecifications;
  String masterBedroomfloorFinishing;
  String masterBedroominteriorWallColor;

  String livingRoomloorFinishing;
  String livingRoominteriorWallColor;

  String kitchenfloorFinishing;
  String kitcheninteriorWallColor;

  @JsonKey(nullable: true)
  List<String> weatherStation;

  String entryStairs;
  bool hasFathometer;
  bool hasCleanWaterLevelIndicator;

  @JsonKey(nullable: true) 
  double fathometer;

  @JsonKey(nullable: true)
  double cleanWaterLevel;

  String interiorBedroomWallColor;
  String deckFloorFinishMaterials;
  String qRCodeImageUrl;

  @JsonKey(nullable: true)
  List<OceanBuilderUser> users;

  @JsonKey(nullable: true)
  List<Scene> defaultScenes;

  OceanBuilder(
      {
      this.oceanBuilderId,
      this.ownerId,
      this.obName,
      this.exteriorFinish,this.exteriorColor,this.sparFinishing,this.sparDesign,this.deckEnclosure,
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
      this.weatherStation,
      this.entryStairs,
      this.hasFathometer,
      this.hasCleanWaterLevelIndicator,
      this.fathometer,
      this.cleanWaterLevel,
      this.interiorBedroomWallColor,
      this.deckFloorFinishMaterials,
      this.qRCodeImageUrl,
      this.users,
      this.defaultScenes
      });

  factory OceanBuilder.fromJson(Map<String, dynamic> json) =>
      _$OceanBuilderFromJson(json);

  Map<String, dynamic> toJson() => _$OceanBuilderToJson(this);
}

