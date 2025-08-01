import 'package:json_annotation/json_annotation.dart';

part 'BaseResult.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResult<T>{
  String code;
  String message;
  T? result;

  BaseResult(this.code,this.message,this.result);

  factory BaseResult.fromJson(
      Map<String,dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) => _$BaseResultFromJson(json,fromJsonT);

  Map<String,dynamic> toJson(Object? Function(T value) toJsonT) => _$BaseResultToJson(this,toJsonT);
}