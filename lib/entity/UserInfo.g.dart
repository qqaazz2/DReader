// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      json['name'] as String,
      json['email'] as String,
      (json['mystery'] as num).toInt(),
      json['cover'] as String?,
      json['minioCover'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'mystery': instance.mystery,
      'cover': instance.cover,
      'minioCover': instance.minioCover
    };
