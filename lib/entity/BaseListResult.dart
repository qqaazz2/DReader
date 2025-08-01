import 'package:json_annotation/json_annotation.dart';
import 'package:DReader/entity/ListData.dart';

part 'BaseListResult.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseListResult<T>{
  String code;
  String message;
  ListData<T>? result;


  BaseListResult(this.code,this.message,this.result);

  factory BaseListResult.fromJson(
      Map<String,dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) => _$BaseListResultFromJson(json,fromJsonT);

  Map<String,dynamic> toJson(Object? Function(T value) toJsonT) => _$BaseListResultToJson(this,toJsonT);
}