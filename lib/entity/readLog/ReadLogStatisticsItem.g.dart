// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReadLogStatisticsItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadLogStatisticsItem _$ReadLogStatisticsItemFromJson(
  Map<String, dynamic> json,
) => ReadLogStatisticsItem(
  json['date'] as String,
  (json['minutes'] as num).toInt(),
);

Map<String, dynamic> _$ReadLogStatisticsItemToJson(
  ReadLogStatisticsItem instance,
) => <String, dynamic>{'date': instance.date, 'minutes': instance.minutes};
