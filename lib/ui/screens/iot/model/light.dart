import 'package:json_annotation/json_annotation.dart';

class Light {
  /* {"id":1,"status":True, "desc": "Middle Hallway", "type":"strip","group":"hallways", "color": 0x000000, "ata":"ATA 32 00-100-125"} */
  int id;
  bool status;
  String desc;
  String type;
  String group;
  int color;
  String ata;

  Light(
      {this.id,
      this.status,
      this.desc,
      this.type,
      this.group,
      this.color,
      this.ata});

  factory Light.fromJson(Map<String, dynamic> json) {
    return Light(
        id: json['id'],
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
      'status': status,
      'desc': desc,
      'type': type,
      'group': group,
      'color': color,
      'ata': ata
    };
  }
}
