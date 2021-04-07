import 'package:json_annotation/json_annotation.dart';

class Light {
  /* {"id":1,"status":True, "desc": "Middle Hallway", "type":"strip","group":"hallways", "color": 0x000000, "ata":"ATA 32 00-100-125"} */
  int id;
  String name;
  int color;
  bool status;
  double brightnessLevel; // min 0.0 max 1.0
  String desc;
  String type;
  String group;

  String ata;

  Light(
      {this.id,
      this.name,
      this.status,
      this.brightnessLevel,
      this.desc,
      this.type,
      this.group,
      this.color,
      this.ata});

  factory Light.fromJson(Map<String, dynamic> json) {
    return Light(
        id: json['id'],
        name: json['name'],
        brightnessLevel: json['brightnessLevel'],
        status: json['status'],
        desc: json['desc'],
        type: json['type'],
        group: json['group'],
        color: json['color'],
        ata: json['ata']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'brightnessLevel': brightnessLevel,
      'status': status,
      'desc': desc,
      'type': type,
      'group': group,
      'color': color,
      'ata': ata
    };
  }
}
