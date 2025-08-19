import 'package:json_annotation/json_annotation.dart';

part 'Proportion.g.dart';


@JsonSerializable()
class Proportion extends Object {

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'type')
  int type;

  Proportion(this.count,this.type);

  factory Proportion.fromJson(Map<String, dynamic> srcJson) => _$ProportionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProportionToJson(this);
}