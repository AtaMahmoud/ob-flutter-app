// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessEvents _$AccessEventsFromJson(Map json) {
  return AccessEvents(
    sentInvitations: (json['sentInvitations'] as List)
        ?.map((e) => e == null
            ? null
            : AccessEvent.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    receivedInvitations: (json['receivedInvitations'] as List)
        ?.map((e) => e == null
            ? null
            : AccessEvent.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    sentRequests: (json['sentRequests'] as List)
        ?.map((e) => e == null
            ? null
            : AccessEvent.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    receivedRequests: (json['receivedRequests'] as List)
        ?.map((e) => e == null
            ? null
            : AccessEvent.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$AccessEventsToJson(AccessEvents instance) =>
    <String, dynamic>{
      'sentInvitations': instance.sentInvitations,
      'receivedInvitations': instance.receivedInvitations,
      'sentRequests': instance.sentRequests,
      'receivedRequests': instance.receivedRequests,
    };
