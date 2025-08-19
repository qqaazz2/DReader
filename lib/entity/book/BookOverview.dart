import 'package:json_annotation/json_annotation.dart';

part 'BookOverview.g.dart';


@JsonSerializable()
class BookOverview extends Object {

  @JsonKey(name: 'seriesCount')
  int seriesCount;

  @JsonKey(name: 'bookCount')
  int bookCount;

  @JsonKey(name: 'overCount')
  int overCount;

  @JsonKey(name: 'unreadCount')
  int unreadCount;


  BookOverview(this.seriesCount,this.bookCount,this.overCount,this.unreadCount);

  factory BookOverview.fromJson(Map<String, dynamic> srcJson) => _$BookOverviewFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BookOverviewToJson(this);

}