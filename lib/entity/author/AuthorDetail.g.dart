// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthorDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorDetail _$AuthorDetailFromJson(Map<String, dynamic> json) => AuthorDetail(
  (json['id'] as num?)?.toInt(),
  json['name'] as String,
  json['avatar'] as String?,
  json['profile'] as String?,
  json['vocational'] as String?,
  (json['bgmId'] as num?)?.toInt(),
  json['date'] as String?,
);

Map<String, dynamic> _$AuthorDetailToJson(AuthorDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'profile': instance.profile,
      'vocational': instance.vocational,
      'bgmId': instance.bgmId,
      'date': instance.date,
    };
