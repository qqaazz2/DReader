// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesDetailsAuthor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesDetailsAuthor _$FilesDetailsAuthorFromJson(Map<String, dynamic> json) =>
    FilesDetailsAuthor(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['authorId'] as num).toInt(),
    );

Map<String, dynamic> _$FilesDetailsAuthorToJson(FilesDetailsAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'authorId': instance.authorId,
    };
