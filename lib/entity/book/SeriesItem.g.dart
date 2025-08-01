// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesItem _$SeriesItemFromJson(Map<String, dynamic> json) => SeriesItem(
      (json['id'] as num).toInt(),
      (json['love'] as num).toInt(),
      json['author'] as String?,
      json['cover'] as String?,
      json['minioCover'] as String?,
      json['lastReadTime'] as String?,
      json['name'] as String,
      (json['num'] as num).toInt(),
      (json['overStatus'] as num).toInt(),
      json['profile'] as String?,
      (json['status'] as num).toInt(),
      (json['filesId'] as num).toInt(),
    );

Map<String, dynamic> _$SeriesItemToJson(SeriesItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'author': instance.author,
      'overStatus': instance.overStatus,
      'status': instance.status,
      'love': instance.love,
      'profile': instance.profile,
      'lastReadTime': instance.lastReadTime,
      'num': instance.num,
      'cover': instance.cover,
      'minioCover': instance.minioCover,
      'filesId': instance.filesId,
    };
