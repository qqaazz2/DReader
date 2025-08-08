import 'package:json_annotation/json_annotation.dart';

part 'LogData.g.dart';

@JsonSerializable()
class LogData extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'callerClass')
  String callerClass;

  LogData(this.id, this.time, this.message, this.level, this.callerClass);

  factory LogData.fromJson(Map<String, dynamic> srcJson) => _$LogDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LogDataToJson(this);
}
