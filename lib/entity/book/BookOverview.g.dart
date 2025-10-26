// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookOverview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookOverview _$BookOverviewFromJson(Map<String, dynamic> json) => BookOverview(
  (json['seriesCount'] as num).toInt(),
  (json['bookCount'] as num).toInt(),
  (json['overCount'] as num).toInt(),
  (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$BookOverviewToJson(BookOverview instance) =>
    <String, dynamic>{
      'seriesCount': instance.seriesCount,
      'bookCount': instance.bookCount,
      'overCount': instance.overCount,
      'unreadCount': instance.unreadCount,
    };
