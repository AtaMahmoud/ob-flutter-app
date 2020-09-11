import 'package:json_annotation/json_annotation.dart';

part 'lighting.g.dart';

@JsonSerializable(explicitToJson: true)
class Lighting {
  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'isOn')
  bool isLightON;

  @JsonKey(nullable: true, defaultValue: 0.0)
  double intensity;

  @JsonKey(nullable: true)
  String selectedScene;

  @JsonKey(name: 'lightScenes')
  List<Scene> sceneList;

  Lighting(
      {this.isLightON, this.intensity, this.selectedScene, this.sceneList});

  factory Lighting.fromJson(Map<String, dynamic> json) =>
      _$LightingFromJson(json);

  Map<String, dynamic> toJson() => _$LightingToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Scene {
  // String "source": "user",
  @JsonKey(name: '_id', nullable: true)
  String id;

  String userId;

  String seapodId;

  @JsonKey(name: 'source', nullable: true)
  String source;

  @JsonKey(name: 'sceneName')
  String name;

  List<Room> rooms;

  Scene({this.id, this.name, this.rooms});

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

  Map<String, dynamic> toJson() => _$SceneToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Room {
  @JsonKey(name: '_id', nullable: true)
  String id;

  @JsonKey(name: 'label')
  String roomName;

  Light light;

  @JsonKey(nullable: true, name: 'moodes')
  List<Light> lightModes;

  Room({this.roomName, this.light, this.lightModes});

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

@JsonSerializable()
class Light {
  @JsonKey(nullable: true)
  String lightName;

  @JsonKey(nullable: true)
  String lightColor;

  @JsonKey(nullable: true)
  bool status;

  @JsonKey(nullable: true)
  int brightness;


  Light({this.lightName, this.lightColor,this.status,this.brightness});

  factory Light.fromJson(Map<String, dynamic> json) => _$LightFromJson(json);

  Map<String, dynamic> toJson() => _$LightToJson(this);
}
