// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesCoverList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesCoverList _$SeriesCoverListFromJson(Map<String, dynamic> json) =>
    SeriesCoverList(
      (json['list'] as List<dynamic>?)
          ?.map((e) => SeriesCover.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeriesCoverListToJson(SeriesCoverList instance) =>
    <String, dynamic>{'list': instance.list};
