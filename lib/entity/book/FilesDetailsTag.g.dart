// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesDetailsTag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesDetailsTag _$FilesDetailsTagFromJson(Map<String, dynamic> json) =>
    FilesDetailsTag(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['tagId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FilesDetailsTagToJson(FilesDetailsTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagId': instance.tagId,
    };
