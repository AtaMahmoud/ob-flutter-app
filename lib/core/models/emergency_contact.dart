import 'package:json_annotation/json_annotation.dart';

part 'emergency_contact.g.dart';

@JsonSerializable()
class EmergencyContact{

  @JsonKey(name: '_id')
  String id;
  String firstName;
  String lastName;
  @JsonKey(name: 'mobileNumber')
  String phone;
  String email;

  EmergencyContact({this.id,this.firstName,this.lastName,this.phone,this.email});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => _$EmergencyContactFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactToJson(this);

}