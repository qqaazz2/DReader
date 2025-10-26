// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LogData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogData _$LogDataFromJson(Map<String, dynamic> json) => LogData(
  (json['id'] as num).toInt(),
  json['time'] as String,
  json['message'] as String,
  json['level'] as String,
  json['callerClass'] as String,
);

Map<String, dynamic> _$LogDataToJson(LogData instance) => <String, dynamic>{
  'id': instance.id,
  'time': instance.time,
  'message': instance.message,
  'level': instance.level,
  'callerClass': instance.callerClass,
};
