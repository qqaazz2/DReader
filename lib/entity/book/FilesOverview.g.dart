// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesOverview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesOverview _$FilesOverviewFromJson(Map<String, dynamic> json) =>
    FilesOverview(
      (json['seriesCount'] as num).toInt(),
      (json['bookCount'] as num).toInt(),
      (json['overCount'] as num).toInt(),
      (json['unreadCount'] as num).toInt(),
      (json['readingCount'] as num).toInt(),
      (json['loveSeriesCount'] as num).toInt(),
      (json['loveBookCount'] as num).toInt(),
      (json['overSeriesCount'] as num).toInt(),
      (json['unOverSeriesCount'] as num).toInt(),
      (json['discardedSeriesCount'] as num).toInt(),
    );

Map<String, dynamic> _$FilesOverviewToJson(FilesOverview instance) =>
    <String, dynamic>{
      'seriesCount': instance.seriesCount,
      'bookCount': instance.bookCount,
      'overCount': instance.overCount,
      'unreadCount': instance.unreadCount,
      'readingCount': instance.readingCount,
      'loveSeriesCount': instance.loveSeriesCount,
      'loveBookCount': instance.loveBookCount,
      'overSeriesCount': instance.overSeriesCount,
      'unOverSeriesCount': instance.unOverSeriesCount,
      'discardedSeriesCount': instance.discardedSeriesCount,
    };
