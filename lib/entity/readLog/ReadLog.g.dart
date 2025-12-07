// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReadLog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadLog _$ReadLogFromJson(Map<String, dynamic> json) => ReadLog(
  (json['id'] as num).toInt(),
  json['time'] as String,
  (json['filesId'] as num).toInt(),
  (json['seconds'] as num).toInt(),
);

Map<String, dynamic> _$ReadLogToJson(ReadLog instance) => <String, dynamic>{
  'id': instance.id,
  'time': instance.time,
  'filesId': instance.filesId,
  'seconds': instance.seconds,
};
