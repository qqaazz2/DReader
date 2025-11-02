import 'package:json_annotation/json_annotation.dart';

part 'ReadLogStatisticsItem.g.dart';

@JsonSerializable()
class ReadLogStatisticsItem extends Object {
  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'minutes')
  int minutes;

  ReadLogStatisticsItem(this.date, this.minutes);

  factory ReadLogStatisticsItem.fromJson(Map<String, dynamic> srcJson) => _$ReadLogStatisticsItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReadLogStatisticsItemToJson(this);
}
