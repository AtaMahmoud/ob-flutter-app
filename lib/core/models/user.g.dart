// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    userID: json['_id'] as String,
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    country: json['country'] as String,
    phone: json['mobileNumber'] as String,
    profileImageUrl: json['profileImageUrl'] as String,
    isVerified: json['isVerified'] as bool,
    userOceanBuilder: (json['userOceanBuilder'] as List)
        ?.map((e) => e == null
            ? null
            : UserOceanBuilder.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    password: json['password'] as String,
    requestAccessTime: json['requestAccessTime'] as String,
    token: json['token'] == null
        ? null
        : FcmToken.fromJson((json['token'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    lightiningScenes: (json['lightiningScenes'] as List)
        ?.map((e) => e == null
            ? null
            : Scene.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    notifications: (json['notifications'] as List)
        ?.map((e) => e == null
            ? null
            : ServerNotification.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    checkInDate: User._dateTimeFromEpochUs(json['checkInDate'] as int),
    emergencyContact: json['emergencyContact'] == null
        ? null
        : EmergencyContact.fromJson((json['emergencyContact'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    seaPods: (json['seaPods'] as List)
        ?.map((e) => e == null
            ? null
            : SeaPod.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    version: json['__v'] as int,
  )
    ..xAuthToken = json['xAuthToken'] as String
    ..userType = json['userType'] as String
    ..emergencyContacts = (json['emergencyContacts'] as List)
        ?.map((e) => e == null
            ? null
            : EmergencyContact.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..accessRequests = (json['accessRequests'] as List)
        ?.map((e) => e == null
            ? null
            : AccessEvent.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..accessInvitations = (json['accessInvitation'] as List)
        ?.map((e) => e == null
            ? null
            : AccessEvent.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.userID,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'country': instance.country,
      'mobileNumber': instance.phone,
      'profileImageUrl': instance.profileImageUrl,
      'isVerified': instance.isVerified,
      'xAuthToken': instance.xAuthToken,
      'userType': instance.userType,
      'requestAccessTime': instance.requestAccessTime,
      'password': instance.password,
      'checkInDate': User._dateTimeToEpochUs(instance.checkInDate),
      'userOceanBuilder': instance.userOceanBuilder,
      'notifications': instance.notifications,
      'token': instance.token,
      'lightiningScenes': instance.lightiningScenes,
      'emergencyContact': instance.emergencyContact,
      'emergencyContacts': instance.emergencyContacts,
      '__v': instance.version,
      'seaPods': instance.seaPods,
      'accessRequests': instance.accessRequests,
      'accessInvitation': instance.accessInvitations,
    };
