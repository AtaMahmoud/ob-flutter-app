// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) {
  return Room(
    floorFinishing: json['floorFinishing'] as String,
    interiorWallColor: json['interiorWallColor'] as String,
  );
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'floorFinishing': instance.floorFinishing,
      'interiorWallColor': instance.interiorWallColor,
    };
