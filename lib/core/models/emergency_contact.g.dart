// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyContact _$EmergencyContactFromJson(Map json) {
  return EmergencyContact(
    id: json['_id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phone: json['mobileNumber'] as String,
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$EmergencyContactToJson(EmergencyContact instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'mobileNumber': instance.phone,
      'email': instance.email,
    };
