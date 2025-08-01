// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResult<T> _$BaseResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseResult<T>(
      json['code'] as String,
      json['message'] as String,
      _$nullableGenericFromJson(json['result'], fromJsonT),
    );

Map<String, dynamic> _$BaseResultToJson<T>(
  BaseResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'result': _$nullableGenericToJson(instance.result, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
