// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesCover.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesCover _$SeriesCoverFromJson(Map<String, dynamic> json) => SeriesCover(
  (json['id'] as num).toInt(),
  json['name'] as String,
  (json['coverId'] as num).toInt(),
  json['coverPath'] as String,
);

Map<String, dynamic> _$SeriesCoverToJson(SeriesCover instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverId': instance.coverId,
      'coverPath': instance.coverPath,
    };
