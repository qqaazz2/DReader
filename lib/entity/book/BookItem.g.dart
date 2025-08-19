// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookItem _$BookItemFromJson(Map<String, dynamic> json) => BookItem(
      (json['id'] as num).toInt(),
      (json['filesId'] as num).toInt(),
      json['filePath'] as String,
      (json['isFolder'] as num).toInt(),
      (json['progress'] as num).toDouble(),
      json['name'] as String?,
      json['author'] as String?,
      json['profile'] as String?,
      json['publishing'] as String?,
      json['status'],
      json['cover'] as String?,
      json['minioCover'] as String?,
      (json['parentId'] as num?)?.toInt(),
      (json['readTagNum'] as num).toInt(),
      json['readTime'] as String?,
    );

Map<String, dynamic> _$BookItemToJson(BookItem instance) => <String, dynamic>{
      'id': instance.id,
      'filesId': instance.filesId,
      'filePath': instance.filePath,
      'isFolder': instance.isFolder,
      'progress': instance.progress,
      'name': instance.name,
      'author': instance.author,
      'profile': instance.profile,
      'publishing': instance.publishing,
      'status': instance.status,
      'cover': instance.cover,
      'minioCover': instance.minioCover,
      'parentId': instance.parentId,
      'readTagNum': instance.readTagNum,
      'readTime': instance.readTime,
    };
