// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exterior_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExteriorPart _$ExteriorPartFromJson(Map<String, dynamic> json) {
  return ExteriorPart(
    exteriorFinish: json['exteriorFinish'] as String,
    exteriorColor: json['exteriorColor'] as String,
    sparFinishing: json['sparFinishing'] as String,
    sparDesign: json['sparDesign'] as String,
    deckEnclosure: json['deckEnclosure'] as String,
  );
}

Map<String, dynamic> _$ExteriorPartToJson(ExteriorPart instance) =>
    <String, dynamic>{
      'exteriorFinish': instance.exteriorFinish,
      'exteriorColor': instance.exteriorColor,
      'sparFinishing': instance.sparFinishing,
      'sparDesign': instance.sparDesign,
      'deckEnclosure': instance.deckEnclosure,
    };
