// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReadLogListItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadLogListItem _$ReadLogListItemFromJson(Map<String, dynamic> json) =>
    ReadLogListItem(
      (json['id'] as num).toInt(),
      (json['minutes'] as num).toInt(),
      (json['bookId'] as num).toInt(),
      json['bookName'] as String,
      json['time'] as String,
    );

Map<String, dynamic> _$ReadLogListItemToJson(ReadLogListItem instance) =>
    <String, dynamic>{
      'time': instance.time,
      'minutes': instance.minutes,
      'id': instance.id,
      'bookId': instance.bookId,
      'bookName': instance.bookName,
    };
