// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesDetailsItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesDetailsItem _$FilesDetailsItemFromJson(Map<String, dynamic> json) =>
    FilesDetailsItem(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['cover'] as String?,
      (json['overStatus'] as num).toInt(),
      (json['status'] as num).toInt(),
      (json['love'] as num).toInt(),
      (json['filesId'] as num).toInt(),
      (json['isFolder'] as num).toInt(),
      json['lastReadTime'] as String?,
      json['profile'] as String?,
      json['date'] as String?,
      json['originalName'] as String?,
      json['filePath'] as String,
      (json['bgmId'] as num?)?.toInt(),
      (json['parentId'] as num).toInt(),
      (json['filesAuthors'] as List<dynamic>)
          .map((e) => FilesDetailsAuthor.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['filesTags'] as List<dynamic>)
          .map((e) => FilesDetailsTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilesDetailsItemToJson(FilesDetailsItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cover': instance.cover,
      'overStatus': instance.overStatus,
      'status': instance.status,
      'love': instance.love,
      'filesId': instance.filesId,
      'isFolder': instance.isFolder,
      'lastReadTime': instance.lastReadTime,
      'profile': instance.profile,
      'date': instance.date,
      'originalName': instance.originalName,
      'filePath': instance.filePath,
      'bgmId': instance.bgmId,
      'parentId': instance.parentId,
      'filesAuthors': instance.filesAuthors,
      'filesTags': instance.filesTags,
    };
