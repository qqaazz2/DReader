// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthorItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorItem _$AuthorItemFromJson(Map<String, dynamic> json) => AuthorItem(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['avatar'] as String?,
);

Map<String, dynamic> _$AuthorItemToJson(AuthorItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
    };
