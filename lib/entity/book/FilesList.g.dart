// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesList _$FilesListFromJson(Map<String, dynamic> json) => FilesList(
  (json['limit'] as num).toInt(),
  (json['page'] as num).toInt(),
  (json['pages'] as num).toInt(),
  (json['count'] as num).toInt(),
  (json['data'] as List<dynamic>)
      .map((e) => FilesItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FilesListToJson(FilesList instance) => <String, dynamic>{
  'limit': instance.limit,
  'page': instance.page,
  'pages': instance.pages,
  'count': instance.count,
  'data': instance.data,
};
