// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesList _$SeriesListFromJson(Map<String, dynamic> json) => SeriesList(
      (json['limit'] as num).toInt(),
      (json['page'] as num).toInt(),
      (json['pages'] as num).toInt(),
      (json['count'] as num).toInt(),
      (json['data'] as List<dynamic>)
          .map((e) => SeriesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeriesListToJson(SeriesList instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
      'pages': instance.pages,
      'count': instance.count,
      'data': instance.data,
    };
