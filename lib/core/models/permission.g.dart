// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionSet _$PermissionSetFromJson(Map json) {
  return PermissionSet(
    id: json['_id'] as String,
    isDefault: json['isDefault'] as bool,
    permissionSetName: json['Name'] as String,
    permissionGroups: (json['Sets'] as List)
        ?.map((e) => e == null
            ? null
            : PermissionGroup.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$PermissionSetToJson(PermissionSet instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'isDefault': instance.isDefault,
      'Name': instance.permissionSetName,
      'Sets': instance.permissionGroups,
    };

PermissionGroup _$PermissionGroupFromJson(Map json) {
  return PermissionGroup(
    id: json['_id'] as String,
    name: json['Name'] as String,
    permissions: (json['Permissions'] as List)
        ?.map((e) => e == null
            ? null
            : Permission.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$PermissionGroupToJson(PermissionGroup instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'Name': instance.name,
      'Permissions': instance.permissions,
    };

Permission _$PermissionFromJson(Map json) {
  return Permission(
    id: json['_id'] as String,
    name: json['Name'] as String,
    status: json['Status'] as String,
  );
}

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'Name': instance.name,
      'Status': instance.status,
    };
