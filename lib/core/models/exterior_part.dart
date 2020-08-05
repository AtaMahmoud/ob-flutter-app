import 'package:json_annotation/json_annotation.dart';
part 'exterior_part.g.dart';

@JsonSerializable()
class ExteriorPart{

  String exteriorFinish;
  String exteriorColor;
  String sparFinishing;
  String sparDesign;
  String deckEnclosure;

  ExteriorPart({this.exteriorFinish,this.exteriorColor,this.sparFinishing,this.sparDesign,this.deckEnclosure});

  factory ExteriorPart.fromJson(Map<String, dynamic> json) => _$ExteriorPartFromJson(json);

  Map<String, dynamic> toJson() => _$ExteriorPartToJson(this);  

}