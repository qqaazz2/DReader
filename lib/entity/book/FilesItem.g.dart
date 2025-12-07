// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesItem _$FilesItemFromJson(Map<String, dynamic> json) => FilesItem(
  (json['id'] as num).toInt(),
  (json['love'] as num).toInt(),
  json['cover'] as String?,
  json['name'] as String,
  (json['overStatus'] as num).toInt(),
  (json['status'] as num).toInt(),
  (json['filesId'] as num).toInt(),
  (json['isFolder'] as num).toInt(),
  (json['parentId'] as num).toInt(),
  json['filePath'] as String,
);

Map<String, dynamic> _$FilesItemToJson(FilesItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'overStatus': instance.overStatus,
  'status': instance.status,
  'love': instance.love,
  'cover': instance.cover,
  'filesId': instance.filesId,
  'isFolder': instance.isFolder,
  'parentId': instance.parentId,
  'filePath': instance.filePath,
};
