// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesContent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesContent _$SeriesContentFromJson(Map<String, dynamic> json) =>
    SeriesContent(
      seriesItem: json['seriesItem'] == null
          ? null
          : SeriesItem.fromJson(json['seriesItem'] as Map<String, dynamic>),
      bookItem: (json['bookItem'] as List<dynamic>?)
          ?.map((e) => BookItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeriesContentToJson(SeriesContent instance) =>
    <String, dynamic>{
      'seriesItem': instance.seriesItem,
      'bookItem': instance.bookItem,
    };
