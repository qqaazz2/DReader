// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseListResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseListResult<T> _$BaseListResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseListResult<T>(
      json['code'] as String,
      json['message'] as String,
      json['result'] == null
          ? null
          : ListData<T>.fromJson(json['result'] as Map<String, dynamic>,
              (value) => fromJsonT(value)),
    );

Map<String, dynamic> _$BaseListResultToJson<T>(
  BaseListResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'result': instance.result?.toJson(
        (value) => toJsonT(value),
      ),
    };
