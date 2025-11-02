import 'package:json_annotation/json_annotation.dart';

part 'ReadLogListItem.g.dart';

@JsonSerializable()
class ReadLogListItem extends Object {
  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'minutes')
  int minutes;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'bookId')
  int bookId;

  @JsonKey(name: 'bookName')
  String bookName;

  ReadLogListItem(this.id, this.minutes,this.bookId,this.bookName,this.time);

  factory ReadLogListItem.fromJson(Map<String, dynamic> srcJson) => _$ReadLogListItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReadLogListItemToJson(this);
}
