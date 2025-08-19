import 'package:json_annotation/json_annotation.dart';

part 'TimeCount.g.dart';

@JsonSerializable()
class TimeCount extends Object {

  @JsonKey(name: 'time')
  int time;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'children')
  List<TimeCount>? children;

  TimeCount(this.time,this.count,this.children);

  factory TimeCount.fromJson(Map<String, dynamic> srcJson) => _$TimeCountFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TimeCountToJson(this);

}