// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookList _$BookListFromJson(Map<String, dynamic> json) => BookList(
  (json['limit'] as num).toInt(),
  (json['page'] as num).toInt(),
  (json['pages'] as num).toInt(),
  (json['count'] as num).toInt(),
  (json['data'] as List<dynamic>?)
      ?.map((e) => BookItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BookListToJson(BookList instance) => <String, dynamic>{
  'limit': instance.limit,
  'page': instance.page,
  'pages': instance.pages,
  'count': instance.count,
  'data': instance.data,
};
