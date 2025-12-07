// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookItem _$BookItemFromJson(Map<String, dynamic> json) => BookItem(
  (json['id'] as num).toInt(),
  (json['filesId'] as num).toInt(),
  (json['progress'] as num).toDouble(),
  (json['readTagNum'] as num).toInt(),
);

Map<String, dynamic> _$BookItemToJson(BookItem instance) => <String, dynamic>{
  'id': instance.id,
  'filesId': instance.filesId,
  'progress': instance.progress,
  'readTagNum': instance.readTagNum,
};
