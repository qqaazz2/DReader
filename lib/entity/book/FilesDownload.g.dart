// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesDownload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesDownload _$FilesDownloadFromJson(Map<String, dynamic> json) =>
    FilesDownload(
      json['hash'] as String,
      (json['status'] as num).toInt(),
      json['cover'] as String?,
      json['name'] as String,
      json['filesId'] as String,
      (json['progress'] as num).toDouble(),
      (json['readTagNum'] as num).toInt(),
      (json['readStatus'] as num).toInt(),
    );

Map<String, dynamic> _$FilesDownloadToJson(FilesDownload instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'status': instance.status,
      'cover': instance.cover,
      'name': instance.name,
      'filesId': instance.filesId,
      'progress': instance.progress,
      'readTagNum': instance.readTagNum,
      'readStatus': instance.readStatus,
    };
