import 'package:json_annotation/json_annotation.dart';


part 'permission.g.dart';

@JsonSerializable()
class PermissionSet {

  @JsonKey(name: '_id')
  String id;
  bool isDefault;
  @JsonKey(name: 'Name')
  String permissionSetName;
  @JsonKey(name: 'Sets')
  List<PermissionGroup> permissionGroups;

  PermissionSet({this.id, this.isDefault, this.permissionSetName, this.permissionGroups});

  factory PermissionSet.fromJson(Map<String, dynamic> json) => _$PermissionSetFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionSetToJson(this);
}

@JsonSerializable()
class PermissionGroup {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Permissions')
  List<Permission> permissions;

  PermissionGroup({this.id, this.name, this.permissions});

    factory PermissionGroup.fromJson(Map<String, dynamic> json) => _$PermissionGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionGroupToJson(this);
}

@JsonSerializable()
class Permission {
  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'Name')
  String name;

  @JsonKey(name: 'Status')
  String status;

  Permission({this.id, this.name, this.status});

  factory Permission.fromJson(Map<String, dynamic> json) => _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
