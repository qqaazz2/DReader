// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimeCount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeCount _$TimeCountFromJson(Map<String, dynamic> json) => TimeCount(
  (json['time'] as num).toInt(),
  (json['count'] as num).toInt(),
  (json['children'] as List<dynamic>?)
      ?.map((e) => TimeCount.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TimeCountToJson(TimeCount instance) => <String, dynamic>{
  'time': instance.time,
  'count': instance.count,
  'children': instance.children,
};
