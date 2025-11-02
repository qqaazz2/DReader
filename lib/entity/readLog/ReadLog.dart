import 'package:json_annotation/json_annotation.dart';

part 'ReadLog.g.dart';

@JsonSerializable()
class ReadLog extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'bookId')
  int bookId;

  @JsonKey(name: 'seconds')
  int seconds;

  ReadLog(this.id, this.time, this.bookId, this.seconds);

  factory ReadLog.fromJson(Map<String, dynamic> srcJson) => _$ReadLogFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReadLogToJson(this);
}
