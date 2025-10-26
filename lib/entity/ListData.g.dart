// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListData<T> _$ListDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ListData<T>(
  (json['limit'] as num).toInt(),
  (json['page'] as num).toInt(),
  (json['pages'] as num).toInt(),
  (json['count'] as num).toInt(),
  (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
);

Map<String, dynamic> _$ListDataToJson<T>(
  ListData<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'limit': instance.limit,
  'page': instance.page,
  'pages': instance.pages,
  'count': instance.count,
  'data': instance.data?.map(toJsonT).toList(),
};
